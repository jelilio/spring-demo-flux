# Simple Dockerfile adding Maven and GraalVM Native Image compiler to the standard
# https://github.com/graalvm/container/pkgs/container/graalvm-ce image
FROM ghcr.io/graalvm/graalvm-ce:ol7-java17-22.3.3 AS build

ADD . /build
WORKDIR /build

# For SDKMAN to work we need unzip & zip
RUN yum install -y unzip zip

RUN \
    # Install SDKMAN
    curl -s "https://get.sdkman.io" | bash; \
    source "$HOME/.sdkman/bin/sdkman-init.sh"; \
    sdk install gradle; \
    # Install GraalVM Native Image
    gu install native-image;

RUN source "$HOME/.sdkman/bin/sdkman-init.sh" && gradle --version

RUN native-image --version

RUN source "$HOME/.sdkman/bin/sdkman-init.sh" && gradle nativeCompile

# We use a Docker multi-stage build here in order that we only take the compiled native Spring Boot App from the first build container
FROM oraclelinux:7-slim

LABEL author="Jelili Adesina" 

# Add Spring Boot Native app demo-flux to Container
COPY --from=build "/build/build/native/nativeCompile/demo-flux" demo-flux

# Fire up our Spring Boot Native app by default
CMD [ "sh", "-c", "./demo-flux -Dserver.port=$PORT" ]