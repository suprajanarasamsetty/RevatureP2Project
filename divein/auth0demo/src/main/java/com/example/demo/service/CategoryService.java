package com.example.demo.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.reactive.function.client.WebClient;

import com.example.demo.dto.CategoryResponse;
import com.example.demo.dto.CategoryRequest;

@Service
public class CategoryService {

    private final WebClient webClient;

    @Autowired
    public CategoryService(WebClient webClient) {
        this.webClient = webClient;
    }

    // Create category
    public CategoryResponse createCategory(CategoryRequest categoryRequest) {
        // Make a POST request and block to get the response synchronously
        return webClient.post()
                .uri("/api/category") // Adjust the endpoint as necessary
                .bodyValue(categoryRequest)
                .retrieve()
                .bodyToMono(CategoryResponse.class)
                .block(); // Block to get the response synchronously
    }

    // Get category by ID
    public CategoryResponse getCategoryById(Long id) {
        // Make a GET request and block to get the response synchronously
        return webClient.get()
                .uri("/api/category/id?id={id}", id)
                .retrieve()
                .bodyToMono(CategoryResponse.class)
                .block(); // Block to get the response synchronously
    }

    // Update category by ID
    public CategoryResponse updateCategoryById(Long id, CategoryRequest categoryRequest) {
        // Make a PUT request and block to get the response synchronously
        return webClient.put()
                .uri("/api/category?id={id}", id)
                .bodyValue(categoryRequest)
                .retrieve()
                .bodyToMono(CategoryResponse.class)
                .block(); // Block to get the response synchronously
    }

    // Delete category by ID
    public boolean deleteCategoryById(Long id) {
        // Make a DELETE request and block to get the response synchronously
        return webClient.delete()
                .uri("/api/category?id={id}", id)
                .retrieve()
                .bodyToMono(Boolean.class)
                .block(); // Block to get the response synchronously
    }

    // Get all categories
    public List<CategoryResponse> getAllCategories() {
        // Make a GET request and block to get the list response synchronously
        return webClient.get()
                .uri("/api/category") // Adjust the endpoint as necessary
                .retrieve()
                .bodyToFlux(CategoryResponse.class)
                .collectList()
                .block(); // Block to get the response synchronously
    }
}
