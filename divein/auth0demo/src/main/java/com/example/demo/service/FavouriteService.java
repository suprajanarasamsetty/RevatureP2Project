package com.example.demo.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.reactive.function.client.WebClient;

import com.example.demo.dto.CartRequest;
import com.example.demo.dto.FavouriteRequest;
import com.example.demo.dto.FavouriteResponse;

import reactor.core.publisher.Mono;

@Service
public class FavouriteService {

    private final WebClient webClient;
    private final CartService cartService; // Assuming you have a CartService that handles cart operations

    @Autowired
    public FavouriteService(WebClient.Builder webClientBuilder, CartService cartService) {
        this.webClient = webClientBuilder.baseUrl("http://localhost:9000/api/favourites").build(); // Replace with actual base URL
        this.cartService = cartService;
    }

    // Add a favourite item using WebClient
    public Mono<FavouriteResponse> addFavourite(FavouriteRequest request) {
        return webClient.post()
                .uri("/add")
                .bodyValue(request)
                .retrieve()
                .bodyToMono(FavouriteResponse.class);
    }

    // Get favourite items by userId using WebClient
    public Mono<List<FavouriteResponse>> getFavouritesByUserId(String userId) {
        return webClient.get()
                .uri(uriBuilder -> uriBuilder
                        .path("/{userId}")
                        .build(userId))
                .retrieve()
                .bodyToFlux(FavouriteResponse.class) // For a list of responses
                .collectList(); // Collect into a Mono List
    }

    // Delete a favourite item using WebClient
    public Mono<Void> deleteFavouriteById(Long favouriteId) {
        return webClient.delete()
                .uri("/{favouriteId}", favouriteId)
                .retrieve()
                .bodyToMono(Void.class);
    }

//    // Move item to cart and delete from favourites using WebClient and CartService
//    public Mono<Void> moveToCart(Long favouriteId) {
//        return webClient.get()
//                .uri("/{favouriteId}", favouriteId)
//                .retrieve()
//                .bodyToMono(FavouriteResponse.class)
//                .flatMap(favourite -> {
//                    CartRequest cartRequest = new CartRequest();
//                    cartRequest.setId(favourite.getId());
//                    cartRequest.setUserId(favourite.getUserId());
//                    cartRequest.setQuantity(1); // Set default quantity
//
//                    // Assume the product price is handled inside CartService or fetched separately
//                    return cartService.createCart(cartRequest)
//                            .then(deleteFavouriteById(favouriteId)); // Delete favourite after moving to cart
//                });
   // }
}
