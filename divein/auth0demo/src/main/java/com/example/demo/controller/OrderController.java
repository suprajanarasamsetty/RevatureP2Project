package com.example.demo.controller;

import java.util.List;
import java.util.concurrent.CompletableFuture;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import com.example.demo.dto.OrderRequest;
import com.example.demo.dto.OrderResponse; // Assuming OrderResponse is a DTO for order responses
import com.example.demo.service.OrderService;

import io.github.resilience4j.circuitbreaker.annotation.CircuitBreaker;
import io.github.resilience4j.retry.annotation.Retry;

@CrossOrigin(origins = "*")
@RestController
@RequestMapping("/api/order")
public class OrderController {

    private final OrderService orderService;

    @Autowired
    public OrderController(OrderService orderService) {
        this.orderService = orderService;
    }

    @PostMapping
    @ResponseBody
    @ResponseStatus(HttpStatus.OK)
    @CircuitBreaker(name = "inventory-service", fallbackMethod = "fallbackResponse")
    @Retry(name = "inventory-service")
    public CompletableFuture<String> placeOrder(@RequestBody OrderRequest orderRequest) throws Exception {
        return CompletableFuture.supplyAsync(() -> orderService.placeOrder(orderRequest));
    }

    public CompletableFuture<ResponseEntity<String>> fallbackResponse(OrderRequest orderRequest, RuntimeException runtimeException) {
        return CompletableFuture.supplyAsync(() -> ResponseEntity.status(HttpStatus.SERVICE_UNAVAILABLE)
                .body("Service is currently unavailable, please try again later."));
    }

    // Get orders by user ID
    @GetMapping("/user")
    @CircuitBreaker(name = "order-service", fallbackMethod = "fallbackGetOrdersByUserId")
    public ResponseEntity<List<OrderResponse>> getOrdersByUserId(@RequestParam String userId) {
        List<OrderResponse> orders = orderService.getOrdersByUserId(userId);
        return ResponseEntity.ok(orders);
    }

    public ResponseEntity<String> fallbackGetOrdersByUserId(String userId, Throwable t) {
        return ResponseEntity.status(HttpStatus.SERVICE_UNAVAILABLE).body("Unable to get orders, please try again later");
    }

    // Delete an order
    @DeleteMapping("/delete")
    @CircuitBreaker(name = "order-service", fallbackMethod = "fallbackDeleteOrder")
    public ResponseEntity<String> deleteOrder(@RequestParam Long id) {
        String response = orderService.deleteOrder(id);
        return ResponseEntity.ok(response);
    }

    public ResponseEntity<String> fallbackDeleteOrder(Long id, Throwable t) {
        return ResponseEntity.status(HttpStatus.SERVICE_UNAVAILABLE).body("Unable to delete order, please try again later.");
    }

    // Update an order
    @PutMapping("/update")
    @CircuitBreaker(name = "order-service", fallbackMethod = "fallbackUpdateOrder")
    public ResponseEntity<String> updateOrder(@RequestParam Long id, @RequestBody OrderRequest orderRequest) {
        String response = orderService.updateOrder(id, orderRequest);
        return ResponseEntity.ok(response);
    }

    public ResponseEntity<String> fallbackUpdateOrder(Long id, OrderRequest orderRequest, Throwable t) {
        return ResponseEntity.status(HttpStatus.SERVICE_UNAVAILABLE).body("Unable to update order, please try again later.");
    }

    // Get orders by status
    @GetMapping("/status/{status}")
    @CircuitBreaker(name = "order-service", fallbackMethod = "fallbackGetOrdersByStatus")
    public ResponseEntity<List<OrderResponse>> getOrdersByStatus(@PathVariable String status) {
        List<OrderResponse> orders = orderService.getOrdersByStatus(status);
        return ResponseEntity.ok(orders);
    }

    public ResponseEntity<List<OrderResponse>> fallbackGetOrdersByStatus(String status, Throwable t) {
        return ResponseEntity.status(HttpStatus.SERVICE_UNAVAILABLE).body(null);
    }
}
