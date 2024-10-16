package com.cart.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Builder
@Data
public class FavouriteResponse {
	private long favouriteId;
	private Long id;
	private String name;
	private String userId;
	private Double unitPrice;
	private String imageurl;

	

}
