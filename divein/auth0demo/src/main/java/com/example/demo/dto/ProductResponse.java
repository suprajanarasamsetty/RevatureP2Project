package com.example.demo.dto;


import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Builder
@ToString

public class ProductResponse {
	
	    
	    private Long id;
	
        private String userId;
	    private String name;

	    private String description;

	   
	    private String skuCode;

	    private Double price;
	    
	 
	    private long categoryId;
	    private String imageurl;
	   

}

