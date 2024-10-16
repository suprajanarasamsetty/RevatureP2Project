package com.example.demo.service;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.reactive.function.client.WebClient;

import com.example.demo.dto.CartRequest;
import com.example.demo.dto.CartResponse;

@Service
public class CartService {

    private final WebClient webClient;

    @Autowired
    public CartService(WebClient webClient) {
        this.webClient = webClient;
    }

    // Create cart
    public String createCart(CartRequest cartRequest) {
        return webClient.post()
                .uri("/api/cart/create")
                .bodyValue(cartRequest)
                .retrieve()
                .bodyToMono(String.class)
                .block(); // Block to get the response synchronously
    }

 // Get cart by ID
    public Optional<CartResponse> getCartById(Long cartId) {
        return Optional.ofNullable(
            webClient.get()
                     .uri("/api/cart/get/{cartId}", cartId)
                     .retrieve()
                     .bodyToMono(CartResponse.class)
                     .block() // Block to get the response synchronously
        );
    }


    // Get carts by User ID
    public List<CartResponse> getCartsByUserId(String userId) {
        return webClient.get()
                .uri("/api/cart/user?userId={userId}", userId)
                .retrieve()
                .bodyToFlux(CartResponse.class)
                .collectList()
                .block(); // Block to get the response synchronously
    }

    // Update cart quantity
    public CartResponse updateCartQuantity(Long cartId, int quantity) {
        return webClient.post()
                .uri("/api/cart/updateQuantity?cartId={cartId}&quantity={quantity}", cartId, quantity)
                .retrieve()
                .bodyToMono(CartResponse.class)
                .block(); // Block to get the response synchronously
    }

    // Delete cart by ID
    public boolean deleteCartById(Long cartId) {
        return webClient.delete()
                .uri("/api/cart/{cartId}", cartId)
                .retrieve()
                .bodyToMono(Boolean.class)
                .block(); // Block to get the response synchronously
    }

    // Move to favourites
    public String moveToFavourites(Long cartId) {
        return webClient.post()
                .uri("/api/cart/favourite/{cartId}", cartId)
                .retrieve()
                .bodyToMono(String.class)
                .block(); // Block to get the response synchronously
    }
}
