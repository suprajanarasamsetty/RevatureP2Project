package com.example.demo.config;
 
import org.springframework.beans.factory.annotation.Autowired;

import org.springframework.cloud.client.loadbalancer.reactive.ReactorLoadBalancerExchangeFilterFunction;

import org.springframework.context.annotation.Bean;

import org.springframework.context.annotation.Configuration;

import org.springframework.web.reactive.function.client.WebClient;
 
@Configuration

public class WebClientConfig {

	@Autowired

	private ReactorLoadBalancerExchangeFilterFunction lbFunction;

	@Bean
	public WebClient webClient() {

		return WebClient.builder().baseUrl("http://localhost:9000").build();
	}
 
}
 