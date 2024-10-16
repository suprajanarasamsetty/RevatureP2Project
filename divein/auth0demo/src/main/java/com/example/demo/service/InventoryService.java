package com.example.demo.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.reactive.function.client.WebClient;

import com.example.demo.dto.InventoryRequest;
import com.example.demo.dto.InventoryResponse;
import com.example.demo.dto.OrderLineItemsDto;

import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

@Service
public class InventoryService {

    private final WebClient webClient;

    @Autowired
    public InventoryService(WebClient webClient) {
        this.webClient = webClient;
    }

    public InventoryResponse createInventoryEntry(InventoryRequest inventoryRequest) {
        // Make a POST request to create an inventory entry
        return webClient.post()
                .uri("/api/inventory")
                .bodyValue(inventoryRequest)
                .retrieve()
                .bodyToMono(InventoryResponse.class)
                .block(); // Block to get the response synchronously
    }

    public List<Boolean> areItemsInStock(List<OrderLineItemsDto> orderLineItems) {
        // Check stock availability for multiple items
        return Flux.fromIterable(orderLineItems)
                .flatMap(item -> webClient.get()
                        .uri("/api/inventory/instock/{skuCode}", item.getSkuCode())
                        .retrieve()
                        .bodyToMono(Boolean.class))
                .collectList()
                .block(); // Block to get the response synchronously
    }

    public InventoryResponse updateInventory(Long id, InventoryRequest inventoryRequest) {
        // Update an inventory entry by ID
        return webClient.put()
                .uri("/api/inventory/update?id={id}", id)
                .bodyValue(inventoryRequest)
                .retrieve()
                .bodyToMono(InventoryResponse.class)
                .block(); // Block to get the response synchronously
    }

    public String deleteInventory(Long id) {
        // Delete an inventory entry by ID
        return webClient.delete()
                .uri("/api/inventory/{id}", id)
                .retrieve()
                .bodyToMono(String.class)
                .block(); // Block to get the response synchronously
    }

    public InventoryResponse getInventoryById(Long id) {
        // Get an inventory entry by ID
        return webClient.get()
                .uri("/api/inventory/{id}", id)
                .retrieve()
                .bodyToMono(InventoryResponse.class)
                .block(); // Block to get the response synchronously
    }

    public List<InventoryResponse> getAllInventoryEntries() {
        // Get all inventory entries
        return webClient.get()
                .uri("/api/inventory/all")
                .retrieve()
                .bodyToFlux(InventoryResponse.class)
                .collectList()
                .block(); // Block to get the response synchronously
    }

    public InventoryResponse getInventoryByUserId(String userId) {
        // Get an inventory entry by user ID
        return webClient.get()
                .uri("/api/inventory/user?userId={userId}", userId)
                .retrieve()
                .bodyToMono(InventoryResponse.class)
                .block(); // Block to get the response synchronously
    }
}
