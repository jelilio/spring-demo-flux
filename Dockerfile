# First stage: JDK with GraalVM
FROM ghcr.io/graalvm/jdk:ol8-java17-22.3.3 AS build

COPY . .

RUN ./gradlew nativeCompile

FROM debian:bookworm-slim

WORKDIR /app

# Copy the native binary from the build stage
COPY --from=build build/native/nativeCompile/demo-flux /app/demo-flux

# Run the application
CMD ["/app/demo-flux"]