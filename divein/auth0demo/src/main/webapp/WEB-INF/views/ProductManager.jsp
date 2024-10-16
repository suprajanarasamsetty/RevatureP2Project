<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Product List</title>
    <style>
		body {
		    font-family: 'Arial', sans-serif;
		    margin: 20px;
		    background-color: #f4f4f4;
		}

		.dashboard-item {
		    margin-bottom: 20px;
		    display: flex;
		    justify-content: space-between;
		}

		.product-container {
		    display: flex;
		    flex-wrap: wrap;
		    justify-content: space-around;
		    margin-top: 20px;
		}

		.product-card {
		    background-color: #ffffff;
		    border: 1px solid #dee2e6;
		    border-radius: 10px; /* Increased border-radius for a softer look */
		    margin: 10px;
		    padding: 20px; /* Increased padding for more spacing */
		    text-align: center;
		    width: 220px; /* Slightly increased width */
		    box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1); /* Enhanced shadow for depth */
		    transition: transform 0.2s; /* Smooth scaling effect on hover */
		}

		.product-card:hover {
		    transform: scale(1.05); /* Slightly scale up on hover */
		}

		.product-image {
		    width: 100px;
		    height: auto;
		    border-radius: 5px;
		    margin-bottom: 10px; /* Add space below the image */
		}

		.product-price {
		    font-size: 18px;
		    color: #28a745;
		    margin: 10px 0;
		    font-weight: bold; /* Make the price bold */
		}

		.product-description {
		    font-size: 14px;
		    color: #555;
		    margin: 5px 0;
		}

		.action-button {
		    margin: 5px;
		    cursor: pointer;
		    background-color: #007bff;
		    color: white;
		    border: none;
		    padding: 8px 12px; /* Slightly larger padding for buttons */
		    border-radius: 5px; /* Increased border-radius */
		    transition: background-color 0.3s, transform 0.2s; /* Add scale on hover */
		}

		.action-button:hover {
		    background-color: #0056b3;
		    transform: scale(1.05); /* Slightly scale up on hover */
		}

		.search-box {
		    display: flex;
		    justify-content: center; /* Centered search box */
		    gap: 10px;
		    margin-bottom: 20px; /* Add margin below the search box */
		}

		.search-input {
		    width: 250px; /* Slightly increased width */
		    padding: 8px; /* Increased padding */
		    border: 1px solid #ccc;
		    border-radius: 5px; /* Increased border-radius */
		}

		.search-button {
		    background-color: #28a745;
		    color: white;
		    border: none;
		    padding: 8px 12px; /* Slightly larger padding */
		    cursor: pointer;
		    border-radius: 5px; /* Increased border-radius */
		    transition: background-color 0.3s, transform 0.2s; /* Add scale on hover */
		}

		.search-button:hover {
		    background-color: #218838;
		    transform: scale(1.05); /* Slightly scale up on hover */
		}

		/* Modal Styles */
		.modal {
		    display: none;
		    position: fixed;
		    z-index: 1;
		    left: 0;
		    top: 0;
		    width: 100%;
		    height: 100%;
		    overflow: auto;
		    background-color: rgba(0, 0, 0, 0.4);
		    padding-top: 60px;
		}

		.modal-content {
		    background-color: #fefefe;
		    margin: 5% auto;
		    padding: 20px;
		    border: 1px solid #888;
		    width: 300px;
		    border-radius: 10px; /* Increased border-radius */
		    box-shadow: 0 4px 10px rgba(0, 0, 0, 0.2); /* Added shadow for depth */
		}

		.close {
		    color: #aaa;
		    float: right;
		    font-size: 28px;
		    font-weight: bold;
		}

		.close:hover,
		.close:focus {
		    color: black;
		    text-decoration: none;
		    cursor: pointer;
		}
</style>
</head>
<body>
	<jsp:include page="seller-navbar.jsp">
	        <jsp:param value="navbar" name=""/>
	    </jsp:include>

    <div class="dashboard-item">

        <!-- Search form -->
        <div align="center" class="search-box">
            <input type="text" id="searchInput" class="search-input" placeholder="Search products..." />
            <button class="search-button" onclick="searchProducts()">Search</button>
        </div>
    </div>

    <div id="productsList" class="product-container">
        <!-- Dynamic product cards will be added here -->
    </div>

    <!-- Modal for Adding Stock -->
    <div id="addStockModal" class="modal">
        <div class="modal-content">
            <span class="close" onclick="document.getElementById('addStockModal').style.display='none'">&times;</span>
            <h2>Add to Stock</h2>
            <form id="addStockForm">
                <input type="hidden" id="modalProductId" required ><br>

                <input type="hidden" id="modalProductName" required><br>

                <input type="hidden" id="modalSkuCode" required><br>

                <input type="hidden" id="modalUserId" required><br>

                <label for="quantity">Quantity:</label><br>
                <input type="number" id="modalQuantity" required min="1"><br>
				
				<label for="productStatus">Product Status:</label>
				<select id="productStatus" name="productStatus">
				    <option value="AVAILABLE">AVAILABLE</option>
				    <option value="OUT_OF_STOCK">OUT OF STOCK</option>
				    <option value="DISCONTINUED">DISCONTINUED</option>
				</select>

                <button type="submit">Submit</button>
            </form>
        </div>
    </div>

    <script>
		
		const userId = '<%= session.getAttribute("userId") %>'; // Retrieve userId from session
		       const newUserId = removeFirstSixCharacters(userId);
		      
		       function removeFirstSixCharacters(userId) {
		           return userId.slice(6);
		       }
		       
        // Fetch products automatically on page load
        window.onload = function() {
            fetchProducts();
        };
		
		function fetchProducts() {
		    console.log(newUserId); // Ensure newUserId is correct
		    const apiUrl = `http://localhost:8081/api/product/user/\${newUserId}`; // Build the URL dynamically
		    console.log(apiUrl); // Log the URL for debugging
		    fetch(apiUrl)
		        .then(response => response.json())
		        .then(products => {
		            window.productsData = products; // Store products data for search functionality
		            displayProducts(products);
		        })
		        .catch(error => console.error('Error fetching products:', error));
		}


        function displayProducts(products) {
            const productsContainer = document.querySelector('#productsList');
            productsContainer.innerHTML = ''; // Clear previous products
            products.forEach(product => {
                const productCard = document.createElement('div');
                productCard.classList.add('product-card');
                productCard.innerHTML = `
                    <img src="\${product.imageurl}" alt="\${product.name}" class="product-image" onerror="this.onerror=null; this.src='path/to/placeholder-image.jpg';">
                    <h3>\${product.name}</h3>
                    <div class="product-price">&#8377;\${product.price.toFixed(2)}</div>
                    <div class="product-description">\${product.description}</div>
                    <div>SKU: \${product.skuCode}</div>
                    <button class="action-button" onclick="deleteProduct(\${product.id})">Delete</button>
                    <button class="action-button" onclick="openAddStockModal('\${product.skuCode}','\${product.name}','\${product.userId}')">Add to Stock</button>
                `;
                productsContainer.appendChild(productCard);
            });
        }

        function searchProducts() {
            const searchInput = document.getElementById('searchInput').value.toLowerCase();

            const filteredProducts = window.productsData.filter(product =>
                product.name.toLowerCase().includes(searchInput)
            );

            displayProducts(filteredProducts);
        }

		function openAddStockModal( skuCode, name, userId) {
		    document.getElementById('modalSkuCode').value = skuCode; // Set SKU Code in the modal
		    document.getElementById('modalProductName').value = name; // Set Product Name in the modal
		    document.getElementById('modalUserId').value = userId; // Set User ID in the modal
		    document.getElementById('addStockModal').style.display = 'block'; // Show the modal
		}

		document.getElementById('addStockForm').onsubmit = async function(event) {
		    event.preventDefault(); // Prevent the default form submission

		    // Retrieve values from the modal inputs
		    const quantity = document.getElementById('modalQuantity').value;
		    const skuCode = document.getElementById('modalSkuCode').value; // If needed
		    const name = document.getElementById('modalProductName').value; // If needed
		    const userId = document.getElementById('modalUserId').value; // If needed
		    const status = document.getElementById('productStatus').value;

		    try {
		        const response = await fetch("http://localhost:8083/api/inventory", {
		            method: 'POST',
		            headers: {
		                'Content-Type': 'application/json',
		            },
		            body: JSON.stringify({
		                
		                quantity,
		                skuCode,    // Include SKU code if needed
		                name, // Include Product name if needed
		                userId,     // Include User ID if needed
		                status      // Include Product Status
		            }),
		        });

		        if (!response.ok) {
		            throw new Error('Network response was not ok');
		        }

		        alert('Stock added successfully!');
		        document.getElementById('addStockModal').style.display = 'none'; // Close the modal
		        document.getElementById('addStockForm').reset(); // Reset form
		    } catch (error) {
		        console.error('Error adding stock:', error);
		        alert('Failed to add stock. Please try again later.');
		    }
		};

        function updateProduct(productId) {
            window.location.href = `/editProduct?id=\${productId}`;
        }

		
		    // Delete product function
		    async function deleteProduct(productId) {
		        if (confirm("Are you sure you want to delete this product?")) {  // Confirm deletion
		            try {
		                const response = await fetch(`http://localhost:8081/api/product?id=\${productId}`, {
		                    method: 'DELETE',
		                });

		                if (response.status === 204) {
		                    alert("Product deleted successfully!");
							location.reload(); 
		                    // Optionally, refresh the product list or remove the deleted product from the UI
		                    document.getElementById(`product-${productId}`).remove();  // Assuming each product has an ID like `product-<productId>`
		                } else {
		                    alert("Failed to delete product. Please try again.");
		                }
		            } catch (error) {
		                console.error('Error deleting product:', error);
		            }
		        }
		    }
		

    </script>

</body>
</html>