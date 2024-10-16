package com.example.demo.dto;




import java.util.List;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class OrderRequest {
    private String orderNumber; // Unique order number
    private String userId; // ID of the user placing the order
    private List<OrderLineItemsDto> orderLineItems;// List of order line items
    private String billingAddress; // Billing address for the order
    private String shippingAddress; // Shipping address for the order
}
