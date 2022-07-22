package com.example.histudent;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.web.servlet.ServletComponentScan;
import org.springframework.context.annotation.ImportResource;

@ServletComponentScan
@SpringBootApplication
public class HistudentApplication {

	public static void main(String[] args) {
		SpringApplication.run(HistudentApplication.class, args);
	}

}
