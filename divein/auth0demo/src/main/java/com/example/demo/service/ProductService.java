package com.example.demo.service;


import java.util.List;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.reactive.function.client.WebClient;

import com.example.demo.dto.ProductRequest;
import com.example.demo.dto.ProductResponse;




@Service
public class ProductService {

    private final WebClient webClient;

    @Autowired
    public ProductService(WebClient webClient) {
        this.webClient = webClient;
    }

    // Create a new product
    public ProductResponse createProduct(ProductRequest productRequest, String userId) {
        return webClient.post()
                .uri("/api/product?userId={userId}", userId)
                .bodyValue(productRequest)
                .retrieve()
                .bodyToMono(ProductResponse.class)
                .block(); // Block to get the response synchronously
    }

    // Get a product by ID
    public ProductResponse getProductById(Long id) {
        return webClient.get()
                .uri("/api/product/{id}", id)
                .retrieve()
                .bodyToMono(ProductResponse.class)
                .block(); // Block to get the response synchronously
    }

    // Check if SKU code exists
    public boolean existsBySkuCode(String skuCode) {
        return webClient.get()
                .uri("/api/product/exists/{skuCode}", skuCode)
                .retrieve()
                .bodyToMono(Boolean.class)
                .block(); // Block to get the response synchronously
    }

    // Get all products
    public List<ProductResponse> getAllProducts() {
        return webClient.get()
                .uri("/api/product") // Adjust the endpoint as necessary
                .retrieve()
                .bodyToFlux(ProductResponse.class)
                .collectList()
                .block(); // Block to get the response synchronously
    }

    // Get products by user ID
    public List<ProductResponse> getProductsByUserId(String userId) {
        return webClient.get()
                .uri("/api/product/user/{userId}", userId)
                .retrieve()
                .bodyToFlux(ProductResponse.class)
                .collectList()
                .block(); // Block to get the response synchronously
    }

    // Update a product by ID
    public ProductResponse updateProductById(ProductRequest productRequest, Long id, String userId) {
        return webClient.put()
                .uri("/api/product/{id}?userId={userId}", id, userId)
                .bodyValue(productRequest)
                .retrieve()
                .bodyToMono(ProductResponse.class)
                .block(); // Block to get the response synchronously
    }

    // Delete a product by ID
    public void deleteProductById(Long id) {
        webClient.delete()
                .uri("/api/product?id={id}", id)
                .retrieve()
                .bodyToMono(Void.class)
                .block(); // Block to get the response synchronously
    }
    public List<ProductResponse> getProductsByCategory(String categoryName) {
        return webClient.get()
        		.uri(uriBuilder -> uriBuilder
        		        .path("/api/product/category/")
        		        .queryParam("categoryName", categoryName)
        		        .build())
            .retrieve()
            .bodyToFlux(ProductResponse.class) // Expect a flux of ProductResponse
            .collectList()  // Collect the flux into a list
            .block();  // Block to get the response synchronously
    }

}
