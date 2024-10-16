package com.example.demo.service;


import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.reactive.function.client.WebClient;

import com.example.demo.dto.ReviewRequest;
import com.example.demo.dto.ReviewResponse;


@Service
public class ReviewService {

    private final WebClient webClient;

    @Autowired
    public ReviewService(WebClient webClient) {
        this.webClient = webClient;
    }

    // Create a new review
    public ReviewResponse createReview(ReviewRequest reviewRequest) {
        return webClient.post()
                .uri("/api/review")
                .bodyValue(reviewRequest)
                .retrieve()
                .bodyToMono(ReviewResponse.class)
                .block(); // Block to get the response synchronously
    }

    // Get a review by ID
    public ReviewResponse getReviewById(Long id) {
        return webClient.get()
                .uri("/api/review/{id}", id)
                .retrieve()
                .bodyToMono(ReviewResponse.class)
                .block(); // Block to get the response synchronously
    }

    // Update a review by ID
    public ReviewResponse updateReviewById(ReviewRequest reviewRequest, Long id) {
        return webClient.put()
                .uri("/api/review/{id}", id)
                .bodyValue(reviewRequest)
                .retrieve()
                .bodyToMono(ReviewResponse.class)
                .block(); // Block to get the response synchronously
    }

    // Delete a review by ID
    public boolean deleteReviewById(Long id) {
        return webClient.delete()
                .uri("/api/review/{id}", id)
                .retrieve()
                .bodyToMono(Boolean.class)
                .block(); // Block to get the response synchronously
    }

    // Get all reviews for a specific product
    public List<ReviewResponse> getAllReviewsByProductId(Long productId) {
        return webClient.get()
                .uri("/api/review/product/{productId}", productId)
                .retrieve()
                .bodyToFlux(ReviewResponse.class)
                .collectList()
                .block(); // Block to get the response synchronously
    }

    // Get all reviews for a specific user
    public List<ReviewResponse> getAllReviewsByUserId(String userId) {
        return webClient.get()
                .uri("/api/review/user/{userId}", userId)
                .retrieve()
                .bodyToFlux(ReviewResponse.class)
                .collectList()
                .block(); // Block to get the response synchronously
    }
}
