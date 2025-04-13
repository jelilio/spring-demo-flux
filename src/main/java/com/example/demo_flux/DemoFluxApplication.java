package com.example.demo_flux;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import reactor.core.publisher.Mono;

@RestController
@SpringBootApplication
public class DemoFluxApplication {

	@GetMapping("/")
	Mono<String> home() {
		return Mono.just("Hello, World!");
	}

	public static void main(String[] args) {
		SpringApplication.run(DemoFluxApplication.class, args);
	}

}
