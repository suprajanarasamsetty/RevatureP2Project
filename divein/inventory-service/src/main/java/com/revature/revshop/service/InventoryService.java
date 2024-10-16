package com.revature.revshop.service;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.revature.revshop.dto.InventoryRequest;
import com.revature.revshop.dto.InventoryResponse;
import com.revature.revshop.dto.OrderLineItemsDto;
import com.revature.revshop.model.Inventory;
import com.revature.revshop.repository.InventoryRepository;

@Service
public class InventoryService {
    
    private final InventoryRepository inventoryRepository;

    @Autowired
    public InventoryService(InventoryRepository inventoryRepository) {
        this.inventoryRepository = inventoryRepository;
    }
    
    public Inventory mapToInventory(InventoryRequest inventoryRequest) {
        return Inventory.builder()
                .name(inventoryRequest.getName())
                .quantity(inventoryRequest.getQuantity())
                .skuCode(inventoryRequest.getSkuCode())
                .status(inventoryRequest.getStatus())
                .userId(inventoryRequest.getUserId())
                .build();
    }

    private InventoryResponse mapToInventoryResponse(Inventory inventory) {
        return InventoryResponse.builder()
                .id(inventory.getId())
                .name(inventory.getName())
                .quantity(inventory.getQuantity())
                .skuCode(inventory.getSkuCode())
                .status(inventory.getStatus())
                .userId(inventory.getUserId())
                .build();
    }
    public InventoryResponse createInventoryEntry(InventoryRequest inventoryRequest) {
        Inventory inventory = inventoryRepository.save(mapToInventory(inventoryRequest));
        return mapToInventoryResponse(inventory);
    }

    public List<Boolean> areItemsInStock(List<OrderLineItemsDto> orderLineItems) {
        List<Boolean> itemsInStock = new ArrayList<>();
        for (OrderLineItemsDto olidto : orderLineItems) {
        	
        	List<Inventory> inventory = inventoryRepository.findAllBySkuCode(olidto.getSkuCode());
        	int quantity =0;
        	
        	for(Inventory i: inventory) {
        		if(i.getStatus().toString().equals("AVAILABLE")) {
        			quantity+=i.getQuantity();
        		}
        		
        		
        	}
        	if(quantity>=olidto.getQuantity()) {
                itemsInStock.add(true);

        		
        	}
            itemsInStock.add(false);

        }
        return itemsInStock;
    }

    public InventoryResponse updateInventory(Long id, InventoryRequest inventoryRequest) {
        Inventory existingInventory = inventoryRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Inventory item not found"));
        
        existingInventory.setName(inventoryRequest.getName());
        existingInventory.setQuantity(inventoryRequest.getQuantity());
        existingInventory.setSkuCode(inventoryRequest.getSkuCode());
        existingInventory.setStatus(inventoryRequest.getStatus());
        existingInventory.setUserId(inventoryRequest.getUserId());

        Inventory updatedInventory = inventoryRepository.save(existingInventory);
        return mapToInventoryResponse(updatedInventory);
    }

    public String deleteInventory(Long id) {
        Inventory existingInventory = inventoryRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Inventory item not found"));
        inventoryRepository.delete(existingInventory);
        return "Inventory item deleted successfully";
    }

    public InventoryResponse getInventoryById(Long id) {
        Inventory inventory = inventoryRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Inventory item not found"));
        return mapToInventoryResponse(inventory);
    }

    public List<InventoryResponse> getAllInventoryEntries() {
        List<Inventory> inventories = inventoryRepository.findAll();
        List<InventoryResponse> responses = new ArrayList<>();
        for (Inventory inventory : inventories) {
            responses.add(mapToInventoryResponse(inventory));
        }
        return responses;
    }
    
    public List<InventoryResponse> getInventoryByUserId(String userId) {
        // Retrieve the inventory list for the specified user ID
        List<Inventory> inventories = inventoryRepository.findByUserId(userId);

        // Check if the inventories are empty and throw an exception if so
        if (inventories.isEmpty()) {
            throw new RuntimeException("No inventory items found for user ID: " + userId);
        }

        // Map the Inventory entities to InventoryResponse DTOs
        return inventories.stream()
                .map(this::mapToInventoryResponse)
                .collect(Collectors.toList());
    }

}
