<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Inventory</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            margin: 0;
            padding: 20px;
        }
        .inventory-container {
            max-width: 800px;
            margin: 0 auto;
            background-color: #ffffff;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 0 15px rgba(0, 0, 0, 0.1);
        }
        h1 {
            color: #4CAF50;
            text-align: center;
            margin-bottom: 20px;
            font-size: 2em;
            text-shadow: 1px 1px 2px rgba(0, 0, 0, 0.2);
        }
        .inventory-item {
            display: flex;
            justify-content: space-between;
            border-bottom: 1px solid #eee;
            padding: 15px 0;
            transition: background-color 0.3s, transform 0.3s;
        }
        .inventory-item:hover {
            background-color: #f9f9f9;
            transform: translateY(-2px);
        }
        .item-details {
            flex-grow: 1;
            margin-right: 20px;
        }
        .item-details h3 {
            color: #333;
            margin: 0;
            font-size: 1.2em;
        }
        .item-details p {
            color: #555;
            margin: 5px 0 0;
        }
        .item-status {
            font-weight: bold;
            color: #4CAF50; /* Change this color based on status if needed */
        }
        .no-items-message {
            text-align: center;
            color: #888;
            font-size: 1.1em;
            margin-top: 20px;
        }
    </style>
</head>
<body>
	<jsp:include page="seller-navbar.jsp">
			        <jsp:param value="navbar" name=""/>
			    </jsp:include>
<div class="inventory-container">
	
    <h1>User Inventory</h1>
    <div id="inventory-items"></div>
</div>

<script>
    const userId = '<%= session.getAttribute("userId") %>'; // Get userId from session
	const newUserId = removeFirstSixCharacters(userId);
	        
	function removeFirstSixCharacters(userId) {
	    return userId.slice(6);
	}
    document.addEventListener('DOMContentLoaded', function () {
        fetchInventoryItems();
    });

    function fetchInventoryItems() {
        fetch(`http://localhost:8083/api/inventory/user?userId=\${newUserId}`)
            .then(response => {
                if (!response.ok) {
                    throw new Error('Network response was not ok');
                }
                return response.json();
            })
            .then(data => {
                displayInventoryItems(data);
            })
            .catch(error => {
                console.error('Error fetching inventory:', error);
                document.getElementById('inventory-items').innerHTML = '<p>Error loading inventory. Please try again later.</p>';
            });
    }

    function displayInventoryItems(inventory) {
        const inventoryItemsDiv = document.getElementById('inventory-items');

        if (inventory && inventory.length > 0) {
            inventoryItemsDiv.innerHTML = '';
            inventory.forEach(item => {
                const itemDiv = document.createElement('div');
                itemDiv.classList.add('inventory-item');
                itemDiv.innerHTML = `
                    <div class="item-details">
                        <h3>\${item.name} (\${item.skuCode})</h3>
                        <p>Quantity: \${item.quantity}</p>
                    </div>
                    <div class="item-status">\${item.status}</div>
                `;
                inventoryItemsDiv.appendChild(itemDiv);
            });
        } else {
            inventoryItemsDiv.innerHTML = '<p class="no-items-message">No inventory items found.</p>';
        }
    }
</script>
</body>
</html>
