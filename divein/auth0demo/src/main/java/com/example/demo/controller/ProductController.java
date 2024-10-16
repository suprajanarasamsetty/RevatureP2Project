package com.example.demo.controller;


import java.util.List;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import com.example.demo.dto.CategoryResponse;
import com.example.demo.dto.ProductRequest;
import com.example.demo.dto.ProductResponse;
import com.example.demo.service.CategoryService;
import com.example.demo.service.ProductService;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/api/product")
public class ProductController {

    private final ProductService productService;
    private final CategoryService categoryService;

    @Autowired
    public ProductController(ProductService productService, CategoryService categoryService) {
        this.productService = productService;
        this.categoryService = categoryService;
    }

    @GetMapping // Fetch all products
    public ResponseEntity<List<ProductResponse>> getProductPage() {
        List<ProductResponse> products = productService.getAllProducts(); 
        return ResponseEntity.ok(products);
    }

    // Fetch a product by ID (used for editing)
    @GetMapping("/{id}")
    public ResponseEntity<ProductResponse> getProductById(@PathVariable Long id) {
        ProductResponse productResponse = productService.getProductById(id);
        return ResponseEntity.ok(productResponse);
    }
    
    @GetMapping("/exists/{skuCode}")
    public ResponseEntity<Boolean> checkSkuCodeExists(@PathVariable String skuCode) {
        boolean exists = productService.existsBySkuCode(skuCode);
        return ResponseEntity.ok(exists);
    }

    @PostMapping
    public ResponseEntity<ProductResponse> createProduct(@RequestBody ProductRequest productRequest, @RequestParam String userId) { // Accept userId
        ProductResponse createdProduct = productService.createProduct(productRequest, userId);
        return new ResponseEntity<>(createdProduct, HttpStatus.CREATED);
    }
    
    @GetMapping("/user/{userId}")
    public ResponseEntity<List<ProductResponse>> getProductsByUserId(@PathVariable String userId) {
        List<ProductResponse> products = productService.getProductsByUserId(userId);
        return ResponseEntity.ok(products); // Return 200 with the product list
    }


    // Update an existing product
    @PutMapping("/{id}") // Use PUT for updates
    public ResponseEntity<ProductResponse> updateProductById(
            @PathVariable Long id,
            @RequestBody ProductRequest productRequest,
            @RequestParam String userId) { // Accept userId
        ProductResponse updatedProduct = productService.updateProductById(productRequest, id, userId);
        return ResponseEntity.ok(updatedProduct);
    }

    @DeleteMapping
    public ResponseEntity<Void> deleteProductById(@RequestParam Long id) {
        productService.deleteProductById(id);
        return ResponseEntity.noContent().build(); // Return 204 No Content
    }
    
}
