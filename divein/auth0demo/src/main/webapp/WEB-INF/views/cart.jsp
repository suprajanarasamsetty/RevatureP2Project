<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Your Shopping Cart</title>
	
	<style>
	    body {
	        background-color: #f8f9fa; /* Light background for contrast */
	    }

	    .container {
	        background: white; /* White background for the cart container */
	        border-radius: 8px; /* Rounded corners */
	        box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1); /* Subtle shadow */
	        padding: 20px; /* Padding for the content */
	        margin-top: 20px; /* Margin for top space */
	    }

	    h2 {
	        font-size: 2rem; /* Larger heading */
	        color: #333; /* Darker color for text */
	        margin-bottom: 20px; /* Space below heading */
	    }

	    .table {
	        background-color: #ffffff; /* White table background */
	        border-radius: 8px; /* Rounded corners */
	        overflow: hidden; /* Prevent overflow for rounded corners */
	    }

	    .table th {
	        background-color: #ff9900; /* Amazon-like orange background */
	        color: #fff; /* White text color for contrast */
	        text-align: center; /* Centered header text */
	        padding: 12px; /* Add some padding for spacing */
	        font-weight: bold; /* Bold text for emphasis */
	        border-bottom: 2px solid #cc7a00; /* Darker bottom border for separation */
	        border-top-left-radius: 8px; /* Rounded corners */
	        border-top-right-radius: 8px; /* Rounded corners */
	    }

	    .table td {
	        text-align: center; /* Centered data text */
	        vertical-align: middle; /* Vertically center data */
	        padding: 10px; /* Padding for table data cells */
	        border-bottom: 1px solid #ddd; /* Light bottom border for separation */
	    }

	    input[type="number"] {
	        width: 60px; /* Fixed width for quantity input */
	        text-align: center; /* Center the number in the input */
	    }

		.grand-total {
		    font-size: 1.5rem;
		    font-weight: bold;
		    color: #2c3e50; /* Darker blue for a more professional look */
		    margin-bottom: 20px; /* Add some space below */
		}


		.checkout-btn {
		    background-color: #f0c14b; /* Amazon-like yellow for checkout button */
		    color: #111; /* Dark text color for contrast */
		    padding: 10px 20px; /* Padding around the button */
		    font-size: 1.2rem; /* Font size */
		    border-radius: 5px; /* Rounded corners */
		    transition: background-color 0.3s; /* Smooth transition */
		    border: 1px solid #a88734; /* Border to match Amazon style */
		    cursor: pointer; /* Pointer cursor on hover */
		}

		.checkout-btn:hover {
		    background-color: #ddb347; /* Slightly darker yellow on hover */
		}


	    .remove-btn {
	        background-color: #ffcccb; /* Lighter red for remove button */
	        color: #d9534f; /* Slightly muted red text */
	        padding: 5px 10px; /* Padding around the button */
	        border: none; /* No border */
	        border-radius: 5px; /* Rounded corners */
	        cursor: pointer; /* Pointer cursor on hover */
	        transition: background-color 0.3s; /* Smooth transition */
	    }

	    .remove-btn:hover {
	        background-color: #ffb3b3; /* Light red on hover */
	    }

	    /* Responsive design for mobile devices */
	    @media (max-width: 768px) {
	        .container {
	            padding: 15px; /* Smaller padding on mobile */
	        }

	        h2 {
	            font-size: 1.5rem; /* Smaller heading on mobile */
	        }

	        .checkout-btn {
	            width: 100%; /* Full-width button on mobile */
	            font-size: 1rem; /* Smaller font size on mobile */
	        }
	    }
	</style>




    <script>
        // Function to fetch cart items for a user
		const userId = '<%= session.getAttribute("userId") %>';
		let cartItems = [];
		const newUserId = removeFirstSixCharacters(userId);
				function removeFirstSixCharacters(userId) {
				    return userId.slice(6);
				}
				console.log(newUserId)
        async function fetchCartItems(newUserId) {
            try {
                // Use the Fetch API to call the backend service
                const response = await fetch(`http://localhost:9000/api/cart/user?userId=\${newUserId}`);
                
                if (!response.ok) {
                    throw new Error('Network response was not ok');
                }
                
                const cartItems = await response.json();
                
                // Call the function to update the UI with the fetched items
                populateCartItems(cartItems);
            } catch (error) {
                console.error("Error fetching cart items:", error);
                document.getElementById("cart-message").innerText = "Unable to load cart items. Please try again later.";
            }
        }
		
		// Function to update the total price based on the quantity
		function updateTotalPrice(cartId, unitPrice, quantity) {
		    const totalPrice = unitPrice * quantity; // Calculate total price
		    document.getElementById(`total-price-\${cartId}`).innerText = totalPrice.toFixed(2); // Update total price display
		}


        // Function to dynamically update the table with cart items
        function populateCartItems(cartItems) {
            const tableBody = document.getElementById("cart-items-body");
            tableBody.innerHTML = "";  // Clear any existing rows

            if (cartItems.length === 0) {
                document.getElementById("cart-message").innerText = "Your cart is empty.";
                return;
            }
			let grandTotal=0;
	
            // Iterate over each item and create a new row in the table
            cartItems.forEach(item => {
                const row = document.createElement("tr");

                row.innerHTML = `
                    <td>\${item.name}</td>
					<td>
				    <input type="number" value="\${item.quantity}" min="1" onchange="updateTotalPrice(\${item.cartId}, \${item.unitPrice}, this.value)" />
			      </td>                    
				   <td>\${item.unitPrice}</td>
				   <td id="total-price-\${item.cartId}">\${item.totalPrice}</td>
					<td>
					    <button class="btn btn-danger" onclick="removeFromCart(\${item.cartId})">Remove</button>
					</td>

                `;
				const totalPrice = item.unitPrice * item.quantity;
				grandTotal += totalPrice; // Add to grand total
				tableBody.appendChild(row);
            });
			document.getElementById('grand-total').innerText = grandTotal.toFixed(2);
        }

		// Standalone removeFromCart function as defined above
		   async function removeFromCart(cartId) {
		       try {
		           const response = await fetch(`http://localhost:8086/api/cart/\${cartId}`, {
		               method: 'DELETE',
		               headers: {
		                   'Content-Type': 'application/json',
		               }
		           });

		           if (response.ok) {
		               alert("Item removed successfully!");
		               location.reload();
		           } else {
		               throw new Error("Failed to remove item");
		           }
		       } catch (error) {
		           console.error("Error removing item:", error);
		           alert("Unable to remove item. Please try again.");
		       }
		   }
		   
		   // Function to update the grand total
		   function updateGrandTotal() {
		       const totalPriceCells = document.querySelectorAll('[id^="total-price-"]');
		       let grandTotal = 0;

		       totalPriceCells.forEach(cell => {
		           grandTotal += parseFloat(cell.innerText) || 0; // Add each total price to grand total
		       });

		       document.getElementById('grand-total').innerText = grandTotal.toFixed(2); // Update grand total display
		   }

		   

		
		async function proceedToCheckout() {
		            const billingAddress = document.querySelector('input[name="billingAddress"]').value.trim();
		            const shippingAddress = document.querySelector('input[name="shippingAddress"]').value.trim();

		            // Check if either field is empty
		            if (!billingAddress || !shippingAddress) {
		                alert('Please enter both billing and shipping addresses before proceeding to checkout.');
		                return; // Stop further execution
		            }
					console.log(cartItems)
					
		            // Prepare orderLineItems from the cart items
		            let orderLineItems = cartItems.map(item => ({
		                id: item.cartId, // Use cartId as the ID
		                name: item.name,
		                skuCode: item.skuCode, // Make sure skuCode exists in your cart item object
		                price: item.unitPrice,
		                quantity: item.quantity
		            }));
					console.log(orderLineItems);
		            const orderRequest = {
		                orderLineItems: orderLineItems,
		                userId: newUserId,
		                billingAddress: billingAddress,
		                shippingAddress: shippingAddress,
		                orderStatus: "SUCCESSFULL" // Set a default order status
		            };

		            try {
		                const response = await fetch(`http://localhost:8082/api/order`, {
		                    method: 'POST',
		                    headers: {
		                        'Content-Type': 'application/json',
		                    },
		                    body: JSON.stringify(orderRequest) // Send the orderRequest object as JSON
		                });

		                if (response.ok) {
		                    alert("Checkout successful! Redirecting to confirmation page.");
		                    window.location.href = "/jsp/successpage"; // Redirect to confirmation page
		                } else {
		                    throw new Error("Failed to proceed to checkout");
		                }
		            } catch (error) {
		                console.error("Error during checkout:", error);
		                alert("Unable to proceed to checkout. Please try again.");
		            }
		        }



        // On page load, fetch the cart items for a given user ID
        document.addEventListener("DOMContentLoaded", () => {
            fetchCartItems(newUserId);
        });
    </script>
</head>
<body>
    <jsp:include page="buyer-navbar.jsp">
        <jsp:param value="navbar" name=""/>
    </jsp:include>
    <div class="container mt-4">
        <h2>Your Shopping Cart</h2>
        <p id="cart-message" class="text-center"></p>  <!-- Message for empty cart or error -->

        <table class="table table-striped">
            <thead>
                <tr>
                    <th>Product Name</th>
                    <th>Quantity</th>
                    <th>Unit Price</th>
                    <th>Total Price</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody id="cart-items-body">
                <!-- Cart items will be dynamically inserted here using JavaScript -->
            </tbody>
        </table>
        <div class="form-group" align="center">
            <label for="shipping-address">Shipping Address:</label>
            <input type="text" name="shippingAddress" id="shipping-address" placeholder="Enter shipping address" required>
            <label for="billing-address">Billing Address:</label>
            <input type="text" name="billingAddress" id="billing-address" placeholder="Enter billing address" required>
            <input type="hidden" name="orderLineItems" id="orderLineItems">
        </div>
        <div class="mt-4" align="right">
            <h4 class="grand-total">Grand Total: ₹ <span id="grand-total">0.00</span></h4>
            <button class="checkout-btn" onclick="proceedToCheckout()">
                <i class="fas fa-shopping-cart"></i> Proceed to Checkout
            </button>
        </div>
    </div>
</body>

</html>
