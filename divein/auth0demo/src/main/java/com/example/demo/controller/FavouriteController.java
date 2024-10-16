package com.example.demo.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.example.demo.dto.FavouriteRequest;
import com.example.demo.dto.FavouriteResponse;
import com.example.demo.service.FavouriteService;

import reactor.core.publisher.Mono;


@CrossOrigin(origins = "http://localhost")
@RestController
@RequestMapping("/api/favourites")
public class FavouriteController {
    
    private final FavouriteService favouriteService;

    @Autowired
    public FavouriteController(FavouriteService favouriteService) {
        this.favouriteService = favouriteService;
    }

    // Add a new favourite
    @PostMapping("/add")
    public ResponseEntity<Mono<FavouriteResponse>> addFavourite(@RequestBody FavouriteRequest request) {
    	Mono<FavouriteResponse> response = favouriteService.addFavourite(request);
        return new ResponseEntity<>(response, HttpStatus.CREATED);
    }

    // Retrieve favourites by user ID
    @GetMapping("/")
    public ResponseEntity<Mono<List<FavouriteResponse>>> getFavouritesByUserId(@RequestParam String userId) {
    	Mono<List<FavouriteResponse>> favourites = favouriteService.getFavouritesByUserId(userId);
        return new ResponseEntity<>(favourites, HttpStatus.OK);
    }

    // Delete a favourite by ID (use POST to align with auth0)
    @DeleteMapping("/delete/{favouriteId}")
    public ResponseEntity<Void> deleteFavourite(@PathVariable Long favouriteId) {
        favouriteService.deleteFavouriteById(favouriteId);
        return new ResponseEntity<>(HttpStatus.NO_CONTENT);
    }

    // Move to cart and remove from favourites
//    @PostMapping("/moveToCart/{favouriteId}")
//    public ResponseEntity<Void> moveToCart(@PathVariable Long favouriteId, @RequestParam String userId) {
//        favouriteService.moveToCart(favouriteId);
//        return new ResponseEntity<>(HttpStatus.OK);
//    }
}
