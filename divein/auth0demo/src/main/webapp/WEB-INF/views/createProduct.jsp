<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Product Form</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f7f7f7;
            padding: 20px;
        }

        .form-container {
            background-color: #ffffff;
            border: 1px solid #ddd;
            border-radius: 10px;
            padding: 30px;
            max-width: 600px;
            margin: 40px auto;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }

        .form-header {
            text-align: center;
            margin-bottom: 30px;
            font-size: 24px;
            font-weight: bold;
            color: #333;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-label {
            display: block;
            margin-bottom: 8px;
            font-weight: bold;
            color: #555;
        }

        .form-input, .form-select, .form-textarea {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 16px;
            box-sizing: border-box;
        }

        .form-input:focus, .form-select:focus, .form-textarea:focus {
            border-color: #007bff;
            outline: none;
            box-shadow: 0 0 5px rgba(0, 123, 255, 0.5);
        }

        .form-button {
            width: 100%;
            padding: 12px;
            background-color: #28a745;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 18px;
            transition: background-color 0.3s ease;
        }

        .form-button:hover {
            background-color: #218838;
        }
    </style>
    <script>
		const userId = '<%= session.getAttribute("userId") %>'; // Retrieve userId from session
				       const newUserId = removeFirstSixCharacters(userId);
				      
				       function removeFirstSixCharacters(userId) {
				           return userId.slice(6);
				       }
        // Handle form submission using Fetch API
        async function createProduct(event) {
            event.preventDefault(); // Prevent the form from submitting traditionally

            // Get the form data
            const productData = {
                userId: newUserId,
                name: document.getElementById('name').value,
                description: document.getElementById('description').value,
                skuCode: document.getElementById('skuCode').value,
                price: parseFloat(document.getElementById('price').value),
                categoryId: parseInt(document.getElementById('categoryId').value),
                imageurl: document.getElementById('imageurl').value
            };

            try {
                // Send POST request to the createProduct endpoint
                const response = await fetch(`http://localhost:8081/api/product?userId=\${productData.userId}`, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify(productData)
                });

                if (response.ok) {
                    alert('Product created successfully!');
                    // Reset form fields
					window.location.href = '/jsp/ProductManager';  // Redirect after successful creation

                    document.getElementById('productForm').reset();
                } else {
                    alert('Failed to create product. Please try again.');
                }
            } catch (error) {
                console.error('Error creating product:', error);
                alert('An error occurred. Please try again.');
            }
        }
    </script>
</head>
<body>
    <!-- Include the Seller Navbar -->
    <jsp:include page="seller-navbar.jsp">
        <jsp:param value="navbar" name=""/>
    </jsp:include>

    <!-- Product Form Container -->
    <div class="form-container">
        <div class="form-header">Product Information Form</div>

        <!-- Product Form -->
        <form id="productForm" onsubmit="createProduct(event)">

            <!-- Product Name -->
            <div class="form-group">
                <label for="name" class="form-label">Product Name:</label>
                <input type="text" id="name" name="name" class="form-input" placeholder="Enter Product Name" required>
            </div>

            <!-- Product Description -->
            <div class="form-group">
                <label for="description" class="form-label">Product Description:</label>
                <textarea id="description" name="description" class="form-textarea" placeholder="Enter Product Description" required></textarea>
            </div>

            <!-- SKU Code -->
            <div class="form-group">
                <label for="skuCode" class="form-label">SKU Code:</label>
                <input type="text" id="skuCode" name="skuCode" class="form-input" placeholder="Enter SKU Code" required>
            </div>

            <!-- Price -->
            <div class="form-group">
                <label for="price" class="form-label">Price (in ₹):</label>
                <input type="number" id="price" name="price" class="form-input" placeholder="Enter Price" step="0.01" required>
            </div>

            <!-- Category -->
            <div class="form-group">
                <label for="categoryId" class="form-label">Category:</label>
                <select id="categoryId" name="categoryId" class="form-select" required>
                    <option value="" disabled selected>Select Category</option>
                    <option value="1">Electronics</option>
                    <option value="2">Fashion</option>
                    <option value="3">Home Appliances</option>
                </select>
            </div>

            <!-- Image URL -->
            <div class="form-group">
                <label for="imageurl" class="form-label">Image URL:</label>
                <input type="text" id="imageurl" name="imageurl" class="form-input" placeholder="Enter Image URL">
            </div>

            <!-- Submit Button -->
            <button type="submit" class="form-button">Submit</button>
        </form>
    </div>
</body>
</html>
