package com.example.demo.controller;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.example.demo.dto.CartRequest;
import com.example.demo.dto.CartResponse;
import com.example.demo.service.CartService;

import io.github.resilience4j.circuitbreaker.annotation.CircuitBreaker;

@CrossOrigin(origins = "http://localhost")
@RestController
@RequestMapping("/api/cart")
public class CartController {
    
    @Autowired
    private CartService cartService;

    @PostMapping("/create")
    @CircuitBreaker(name = "CartService", fallbackMethod = "createCartFallback")
    public String createCart(@RequestBody CartRequest cartRequest, Model model) {
        String result = cartService.createCart(cartRequest);
        model.addAttribute("message", result);
        return "cart"; 
    }
    
    public ResponseEntity<String> createCartFallback(@ModelAttribute CartRequest cartRequest, RuntimeException runtimeException) {
        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                             .body("Something went wrong, please try after sometime.");
    }

    @GetMapping("/get/{cartId}")
    @CircuitBreaker(name = "CartService", fallbackMethod = "getCartByIdFallback")
    public ResponseEntity<CartResponse> getCartById(@PathVariable Long cartId) {
        Optional<CartResponse> cartResponse = cartService.getCartById(cartId);
        return cartResponse.map(ResponseEntity::ok)
                           .orElse(ResponseEntity.notFound().build());
    }


    public ResponseEntity<String> getCartByIdFallback(@PathVariable Long cartId, RuntimeException runtimeException) {
        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                             .body("Something went wrong, please try after sometime.");
    }

    @DeleteMapping("/{cartId}")
    @CircuitBreaker(name = "CartService", fallbackMethod = "deleteCartByIdFallback")
    public ResponseEntity<Void> deleteCartById(@PathVariable Long cartId) {
        cartService.deleteCartById(cartId);
        return ResponseEntity.noContent().build();
    }

    public ResponseEntity<String> deleteCartByIdFallback(@PathVariable Long cartId, RuntimeException runtimeException) {
        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                             .body("Something went wrong, please try after sometime.");
    }

    @GetMapping("/user")
    @CircuitBreaker(name = "CartService", fallbackMethod = "getCartsByUserIdFallback")
    public ResponseEntity<List<CartResponse>> getCartsByUserId(@RequestParam("userId") String userId) {
        List<CartResponse> cartItems = cartService.getCartsByUserId(userId);
        return ResponseEntity.ok(cartItems);
    }

    public ResponseEntity<String> getCartsByUserIdFallback(@RequestParam("userId") String userId, RuntimeException runtimeException) {
        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                             .body("Something went wrong, please try again later.");
    }

    @PostMapping("/updateQuantity")
    @CircuitBreaker(name = "CartService", fallbackMethod = "updateCartQuantityFallback")
    public String updateCartQuantity(@RequestParam("cartId") Long cartId, @RequestParam("quantity") int quantity, Model model) {
        CartResponse updatedCart = cartService.updateCartQuantity(cartId, quantity);
        List<CartResponse> cartItems = cartService.getCartsByUserId(updatedCart.getUserId());
        model.addAttribute("cartItems", cartItems);

        double cartTotal = cartItems.stream().mapToDouble(CartResponse::getTotalPrice).sum();
        model.addAttribute("cartTotal", cartTotal);
        model.addAttribute("message", "Cart updated successfully!");

        return "cart";
    }

    public ResponseEntity<String> updateCartQuantityFallback(@RequestParam("cartId") Long cartId, @RequestParam("quantity") int quantity, RuntimeException runtimeException) {
        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                             .body("Something went wrong, please try after sometime.");
    }

    @PostMapping("/favourite/{cartId}")
    public ResponseEntity<String> moveToFavourites(@PathVariable Long cartId) {
        try {
            cartService.moveToFavourites(cartId);
            return ResponseEntity.ok("Moved to favourites successfully!");
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Failed to move to favourites.");
        }
    }
}
