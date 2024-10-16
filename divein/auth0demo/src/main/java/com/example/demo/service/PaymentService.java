package com.example.demo.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.reactive.function.client.WebClient;

import com.example.demo.dto.PaymentStatus; // Assuming PaymentStatusDTO is the DTO for payment status

@Service
public class PaymentService {

    private final WebClient webClient;

    @Autowired
    public PaymentService(WebClient webClient) {
        this.webClient = webClient;
    }

    // Create payment link
    public String createLink(String orderId) {
        return webClient.post()
                .uri("/payment/createLink") // Adjust the URI based on your actual payment service endpoint
                .bodyValue(orderId)
                .retrieve()
                .bodyToMono(String.class)
                .block(); // Blocking call to return a String response
    }

    // Get payment status
    public PaymentStatus getPaymentStatus(String paymentId, String orderId) {
        return webClient.get()
                .uri(uriBuilder -> uriBuilder
                        .path("/payment/getPaymentStatus")
                        .queryParam("paymentId", paymentId)
                        .queryParam("orderId", orderId)
                        .build())
                .retrieve()
                .bodyToMono(PaymentStatus.class)
                .block(); // Blocking call to return a PaymentStatusDTO object
    }
}
