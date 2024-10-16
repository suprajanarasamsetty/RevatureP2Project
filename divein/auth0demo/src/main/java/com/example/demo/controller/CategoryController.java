package com.example.demo.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import com.example.demo.dto.CategoryRequest;
import com.example.demo.dto.CategoryResponse;
import com.example.demo.dto.ProductResponse;
import com.example.demo.service.CategoryService;

@CrossOrigin(origins = "*")
@RestController
@RequestMapping("/api/category")
public class CategoryController {

    private final CategoryService categoryService;

    @Autowired
    public CategoryController(CategoryService categoryService) {
        this.categoryService = categoryService;
    }

    @PostMapping
    public ResponseEntity<CategoryResponse> createCategory(@RequestBody CategoryRequest categoryRequest) {
        // Using DTO for creating a category
        CategoryResponse response = categoryService.createCategory(categoryRequest);
        return new ResponseEntity<>(response, HttpStatus.CREATED);
    }
    



    @GetMapping("/id")
    public ResponseEntity<CategoryResponse> getCategoryById(@RequestParam Long id) {
        // Using DTO for fetching a category by ID
        CategoryResponse response = categoryService.getCategoryById(id);
        return new ResponseEntity<>(response, HttpStatus.OK);
    }

    @PutMapping
    public ResponseEntity<CategoryResponse> updateCategoryById(@RequestBody CategoryRequest categoryRequest, @RequestParam Long id) {
        // Using DTO for updating a category by ID
        CategoryResponse response = categoryService.updateCategoryById(id, categoryRequest);
        return new ResponseEntity<>(response, HttpStatus.ACCEPTED);
    }

    @DeleteMapping
    public ResponseEntity<Boolean> deleteCategoryById(@RequestParam Long id) {
        // Using DTO for deleting a category by ID
        Boolean isDeleted = categoryService.deleteCategoryById(id);
        return new ResponseEntity<>(isDeleted, HttpStatus.OK);
    }

    @GetMapping
    public ResponseEntity<List<CategoryResponse>> getAllCategories() {
        // Using DTO for fetching all categories
        List<CategoryResponse> response = categoryService.getAllCategories();
        return new ResponseEntity<>(response, HttpStatus.OK);
    }
}
