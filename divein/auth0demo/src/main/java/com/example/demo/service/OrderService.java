package com.example.demo.service;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.reactive.function.client.WebClient;

import com.example.demo.dto.OrderRequest;
import com.example.demo.dto.OrderResponse; // Assuming OrderResponse is a DTO for order responses

@Service
public class OrderService {

    private final WebClient webClient;

    @Autowired
    public OrderService(WebClient webClient) {
        this.webClient = webClient;
    }

    // Place an order
    public String placeOrder(OrderRequest orderRequest) {
        return webClient.post()
                .uri("/api/orders") // Modify the URI based on your actual endpoint
                .bodyValue(orderRequest)
                .retrieve()
                .bodyToMono(String.class)
                .block(); // Blocking call
    }

    // Get orders by user ID
    public List<OrderResponse> getOrdersByUserId(String userId) {
        return webClient.get()
                .uri(uriBuilder -> uriBuilder
                        .path("/api/orders/user")
                        .queryParam("userId", userId)
                        .build())
                .retrieve()
                .bodyToFlux(OrderResponse.class) // Use OrderResponse DTO instead of Order model
                .collectList()
                .block(); // Blocking call to return List<OrderResponse>
    }

    // Delete an order by ID
    public String deleteOrder(Long id) {
        return webClient.delete()
                .uri(uriBuilder -> uriBuilder
                        .path("/api/orders/delete")
                        .queryParam("id", id)
                        .build())
                .retrieve()
                .bodyToMono(String.class)
                .block(); // Blocking call
    }

    // Update an order by ID
    public String updateOrder(Long id, OrderRequest orderRequest) {
        return webClient.put()
                .uri(uriBuilder -> uriBuilder
                        .path("/api/orders/update")
                        .queryParam("id", id)
                        .build())
                .bodyValue(orderRequest)
                .retrieve()
                .bodyToMono(String.class)
                .block(); // Blocking call
    }

    // Get orders by status
    public List<OrderResponse> getOrdersByStatus(String status) {
        return webClient.get()
                .uri(uriBuilder -> uriBuilder
                        .path("/api/orders/status/{status}")
                        .build(status))
                .retrieve()
                .bodyToFlux(OrderResponse.class) // Use OrderResponse DTO instead of Order model
                .collectList()
                .block(); // Blocking call to return List<OrderResponse>
    }
}
