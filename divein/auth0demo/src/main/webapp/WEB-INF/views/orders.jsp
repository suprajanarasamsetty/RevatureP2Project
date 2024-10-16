<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Your Orders</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <script>
        // Fetch the user ID from the session (assuming userId is stored in the session)
        const userId = '<%= session.getAttribute("userId") %>';
        const newUserId = removeFirstSixCharacters(userId);

        function removeFirstSixCharacters(userId) {
            return userId.slice(6);
        }

        document.addEventListener("DOMContentLoaded", () => {
            fetchOrdersByUserId(newUserId);
        });

        // Fetch orders for the logged-in user
        async function fetchOrdersByUserId(userId) {
            try {
                const response = await fetch(`http://localhost:8082/api/order/user?userId=\${newUserId}`);
                
                if (!response.ok) {
                    throw new Error('Failed to fetch orders. Please try again.');
                }
                
                const orders = await response.json();
                displayOrders(orders);
            } catch (error) {
                console.error("Error fetching orders:", error);
                document.getElementById("order-message").innerText = "Unable to load your orders. Please try again later.";
            }
        }

        // Function to display orders on the UI
        function displayOrders(orders) {
            const ordersTableBody = document.getElementById("orders-body");
            ordersTableBody.innerHTML = ""; // Clear existing table rows

            if (orders.length === 0) {
                document.getElementById("order-message").innerText = "You have no orders.";
                return;
            }

            orders.forEach(order => {
                const orderRow = document.createElement("tr");

                orderRow.innerHTML = `
                    <td>\${order.orderNumber}</td>
                    <td>\${order.status}</td>
                    <td>\${order.billingAddress}</td>
                    <td>\${order.shippingAddress}</td>
                    
                `;

                ordersTableBody.appendChild(orderRow);
            });
        }

        // Function to display order line items in a modal
        function showOrderDetails(orderId) {
            const selectedOrder = document.querySelector(`#order-${orderId}`);
            if (selectedOrder) {
                const orderLineItems = JSON.parse(selectedOrder.value);
                const modalBody = document.getElementById("modal-body");
                modalBody.innerHTML = "";

                orderLineItems.forEach(item => {
                    modalBody.innerHTML += `
                        <tr>
                            <td>\${item.name}</td>
                            <td>\${item.skuCode}</td>
                            <td>\${item.quantity}</td>
                            <td>\${item.price}</td>
                        </tr>
                    `;
                });

                // Show the modal
                $('#orderDetailsModal').modal('show');
            }
        }
    </script>
</head>
<body>
	<jsp:include page="buyer-navbar.jsp">
	        <jsp:param value="navbar" name=""/>
	    </jsp:include>
    <div class="container mt-4">
        <h2>Your Orders</h2>
        <p id="order-message"></p> <!-- Display error message if any -->

        <!-- Orders table -->
        <table class="table table-striped">
            <thead>
                <tr>
                    <th>Order Number</th>
                    <th>Order Status</th>
                    <th>Billing Address</th>
                    <th>Shipping Address</th>
                    
                </tr>
            </thead>
            <tbody id="orders-body">
                <!-- Orders will be dynamically inserted here -->
            </tbody>
        </table>

        <!-- Order Details Modal -->
        <div class="modal fade" id="orderDetailsModal" tabindex="-1" aria-labelledby="orderDetailsModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="orderDetailsModalLabel">Order Details</h5>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <div class="modal-body">
                        <table class="table">
                            <thead>
                                <tr>
                                    <th>Product Name</th>
                                    <th>SKU Code</th>
                                    <th>Quantity</th>
                                    <th>Unit Price</th>
                                </tr>
                            </thead>
                            <tbody id="modal-body">
                                <!-- Order line items will be displayed here -->
                            </tbody>
                        </table>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap and jQuery scripts -->
    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.5.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
