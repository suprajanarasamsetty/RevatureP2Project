package com.cart.service;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Lazy;
import org.springframework.stereotype.Service;

import com.cart.dto.CartRequest;
import com.cart.dto.FavouriteRequest;
import com.cart.dto.FavouriteResponse;
import com.cart.model.Favourites;
import com.cart.repository.FavouriteRepository;

@Service
public class FavouriteService {

    private final FavouriteRepository favouriteRepository;
    
    @Autowired
    @Lazy
    private final CartService cartService;

    @Autowired
    public FavouriteService(FavouriteRepository favouriteRepository, CartService cartService) {
        this.favouriteRepository = favouriteRepository;
        this.cartService = cartService;
    }

    // Add
    public FavouriteResponse addFavourite(FavouriteRequest request) {
        Favourites favourite = new Favourites();
        favourite.setId(request.getId());
        favourite.setUserId(request.getUserId());
        favourite.setName(request.getName());
        favourite.setUnitPrice(request.getUnitPrice());
        favourite.setImageurl(request.getImageurl());
        Favourites savedFavourite = favouriteRepository.save(favourite);
        return mapToFavouriteResponse(savedFavourite);
    }

    // Get by userId
    public List<FavouriteResponse> getFavouritesByUserId(String userId) {
        return favouriteRepository.findByUserId(userId)
                .stream()
                .map(this::mapToFavouriteResponse)
                .collect(Collectors.toList());
    }

    // Delete
    public void deleteFavouriteById(Long favouriteId) {
        if (favouriteRepository.existsById(favouriteId)) {
            favouriteRepository.deleteById(favouriteId);
        } else {
            throw new RuntimeException("Favourite with ID " + favouriteId + " does not exist.");
        }
    }

    // Move to cart
    public void moveToCart(Long favouriteId) {
        Optional<Favourites> favouriteOpt = favouriteRepository.findById(favouriteId);
        favouriteOpt.ifPresent(favourite -> {
            CartRequest cartRequest = new CartRequest();
            cartRequest.setId(favourite.getId());
            cartRequest.setUserId(favourite.getUserId());
            cartRequest.setName(favourite.getName());
            cartRequest.setUnitPrice(favourite.getUnitPrice());
            cartService.createCart(cartRequest);
            favouriteRepository.deleteById(favouriteId); // Remove from favourites
        });
    }

    // Utility method to map entity to response
    private FavouriteResponse mapToFavouriteResponse(Favourites favourite) {
    		return  FavouriteResponse.builder()
    				.favouriteId(favourite.getFavouriteId())
    				.id(favourite.getId())
    				.name(favourite.getName())
    				.userId(favourite.getUserId())
    				.unitPrice(favourite.getUnitPrice())
    				.imageurl(favourite.getImageurl())
    				.build();
    }
}
