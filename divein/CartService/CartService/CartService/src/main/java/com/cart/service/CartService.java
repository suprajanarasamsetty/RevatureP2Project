package com.cart.service;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Lazy;
import org.springframework.stereotype.Service;

import com.cart.dto.CartRequest;
import com.cart.dto.CartResponse;
import com.cart.dto.FavouriteRequest;
import com.cart.model.Cart;
import com.cart.repository.CartRepository;

@Service
public class CartService {
    @Autowired
    private CartRepository cartRepository;

    @Autowired
    @Lazy
    private FavouriteService favouriteService;

    // Create a new cart
    public String createCart(CartRequest cartRequest) {
        Cart cart = new Cart();
        int quantity = 1;
        cart.setId(cartRequest.getId());
        cart.setName(cartRequest.getName());
        cart.setUserId(cartRequest.getUserId());
        cart.setQuantity(quantity);
        cart.setSkuCode(cartRequest.getSkuCode());
        cart.setUnitPrice(cartRequest.getUnitPrice());
        cart.setTotalPrice(calculateTotalPrice(cart.getUnitPrice(), cart.getQuantity()));
        
        cart = cartRepository.save(cart);
        return "Cart created successfully with ID: " + cart.getCartId();
    }

    // Get a cart by ID
    public Optional<CartResponse> getCartById(Long cartId) {
        return cartRepository.findById(cartId)
                             .map(this::mapToResponse);
    }

    // Delete a cart by ID
    public void deleteCartById(Long cartId) {
        if (cartRepository.existsById(cartId)) {
            cartRepository.deleteById(cartId);
        } else {
            throw new RuntimeException("Cart with ID " + cartId + " does not exist.");
        }
    }

    // Get carts by user_id
    public List<CartResponse> getCartsByUserId(String userId) {
        List<Cart> carts = cartRepository.findByUserId(userId);
        return carts.stream().map(this::mapToResponse).collect(Collectors.toList());
    }

    // Update cart quantity using `cartId` instead of `productId`
    public CartResponse updateCartQuantity(Long cartId, int quantity) {
        Cart cart = cartRepository.findById(cartId).orElseThrow(() -> new RuntimeException("Cart not found"));
        cart.setQuantity(quantity);
        cart.setTotalPrice(calculateTotalPrice(cart.getUnitPrice(), quantity));
        Cart updatedCart = cartRepository.save(cart);
        return mapToResponse(updatedCart);
    }

    // Move to favourites method
    public void moveToFavourites(Long cartId) {
        Optional<Cart> optionalCart = cartRepository.findById(cartId);
        if (optionalCart.isPresent()) {
            Cart cart = optionalCart.get();
            Long id = cart.getId();
            String userId = cart.getUserId();
            FavouriteRequest favouriteRequest = new FavouriteRequest();
            favouriteRequest.setId(id);;
            favouriteRequest.setUserId(userId);

            favouriteService.addFavourite(favouriteRequest);
            cartRepository.delete(cart);
        }
    }

    // Helper method to calculate total price
    private Double calculateTotalPrice(Double unitPrice, int quantity) {
        return unitPrice * quantity;
    }

    // Helper method to convert Cart to CartResponse
    private CartResponse mapToResponse(Cart cart) {
        return CartResponse.builder()
                           .cartId(cart.getCartId())
                           .id(cart.getId())
                           .name(cart.getName())
                           .skuCode(cart.getSkuCode())
                           .userId(cart.getUserId())
                           .quantity(cart.getQuantity())
                           .unitPrice(cart.getUnitPrice())
                           .totalPrice(cart.getTotalPrice())
                           .build();
    }
}
