<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Buyer Dashboard</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style>
        body {
            background-color: #f4f4f4;
            font-family: 'Arial', sans-serif;
        }

        .product-image {
            width: 100%;
            height: 200px;
            object-fit: contain;
            padding: 10px;
            background-color: #f8f9fa;
            border-radius: 5px;
            border: 1px solid #e1e1e1; /* Light border around product image */
        }

        .product-item {
            margin-bottom: 20px;
        }

        .card {
            transition: transform 0.2s; /* Animation for hover effect */
        }

        .card:hover {
            transform: scale(1.02); /* Slight zoom on hover */
        }

        .card-title {
            font-weight: bold;
            color: #333; /* Darker title color */
        }

        .card-text {
            color: #666; /* Softer color for description */
        }

        .btn {
            border-radius: 5px; /* Rounded buttons */
            font-weight: bold; /* Bold button text */
        }

        .btn-primary {
            background-color: #007bff; /* Bootstrap primary color */
            border: none; /* Remove border */
        }

        .btn-primary:hover {
            background-color: #0056b3; /* Darker blue on hover */
        }

        .btn-warning {
            background-color: #ffc107; /* Bootstrap warning color */
            border: none; /* Remove border */
        }

        .btn-warning:hover {
            background-color: #e0a800; /* Darker yellow on hover */
        }

        .alert {
            position: fixed;
            top: 20px;
            right: 20px;
            z-index: 1050; /* Ensure it appears above other elements */
        }
    </style>
</head>
<body>
    <jsp:include page="buyer-navbar.jsp">
        <jsp:param value="navbar" name=""/>
    </jsp:include>

    <!-- Main content -->
    <div class="container mt-4">
        <!-- Products Grid -->
        <div class="row" id="productGrid">
            <c:set var="searchQuery" value="${param.search}"/> <!-- Capture search query -->
            <c:forEach var="product" items="${products}">
                <c:if test="${empty searchQuery || fn:containsIgnoreCase(product.name, searchQuery) || fn:containsIgnoreCase(product.description, searchQuery)}">
                    <div class="col-md-4 mb-4 product-item">
                        <div class="card shadow-sm"> <!-- Added shadow for depth -->
                            <img class="card-img-top product-image" src="${product.imageurl}" alt="Product Image">
                            <div class="card-body">
                                <h5 class="card-title">${product.name}</h5>
                                <p class="card-text">${product.description}</p>
                                <p class="card-text"><strong>Price:</strong> $${product.price}</p>

                                <!-- Buttons side by side -->
                                <div class="d-flex justify-content-start">
                                    <a href="javascript:void(0);" class="btn btn-primary mr-2" 
                                       onclick="addToFavourites('${product.id}', '${product.name}', '${product.price}','${product.imageurl}')">
                                        <i class="fas fa-heart"></i> Add to Favourites
                                    </a>
                                    <button class="btn btn-warning mr-2" 
                                            onclick="addToCart('${product.id}', '${product.name}', '${product.skuCode}', '${product.price}')">
                                        <i class="fas fa-shopping-cart"></i> Add to Cart
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:if>
            </c:forEach>
        </div>
    </div>

    <script>
        // Get userId from session and store it in a variable
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
            fetch('http://localhost:9000/api/product')
                .then(response => {
                    if (!response.ok) {
                        throw new Error('Network response was not ok ' + response.statusText);
                    }
                    return response.json();
                })
                .then(products => {
                    renderProducts(products); // Ensure renderProducts function is defined
                })
                .catch(error => console.error('Error fetching products:', error));
        }

        function addToCart(id, name, skuCode, price) {
            const userId = '<%= session.getAttribute("userId") %>'; // Get userId from the session
            const quantity = 1; // Default quantity to add

            // Create the CartRequest object to be sent
            const cartRequest = {
                userId: newUserId,
                id: id,
                name: name,
                skuCode: skuCode,
                quantity: quantity,
                unitPrice: price,
                totalPrice: price * quantity
            };

            console.log(cartRequest);
            // Fetch API request to add the item to the cart
            fetch('http://localhost:8086/api/cart/create', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json' // Set the request type to JSON
                },
                body: JSON.stringify(cartRequest) // Convert the object to a JSON string
            })
            .then(response => {
                if (!response.ok) {
                    throw new Error('Network response was not ok ' + response.statusText);
                }
                return response.text(); // Get response as text since your controller returns a message string
            })
            .then(message => {
                alert('Item added to cart successfully! ' + message); // Show a success message
                window.location.href = '/jsp/buyerdashboard'; // Redirect to cart.jsp to see the updated cart
            })
            .catch(error => {
                console.error('Error adding item to cart:', error);
                alert('Failed to add item to cart. Please try again.');
            });
        }

        function addToFavourites(id, name, price, imageurl) {
            const userId = '<%= session.getAttribute("userId") %>'; // Get userId from the session

            // Create the favRequest object to be sent
            const favouriteRequest = {
                userId: newUserId,
                id: id,
                name: name,
                unitPrice: price,
                imageurl: imageurl
            };

            // Fetch API request to add the item to the favourites
            fetch('http://localhost:8086/api/favourites/add', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json' // Set the request type to JSON
                },
                body: JSON.stringify(favouriteRequest) // Convert the object to a JSON string
            })
            .then(response => {
                if (!response.ok) {
                    throw new Error('Network response was not ok ' + response.statusText);
                }
                return response.text(); // Get response as text since your controller returns a message string
            })
            .then(message => {
                alert('Item added to favourites successfully!'); // Show a success message
                window.location.href = '/jsp/buyerdashboard'; // Redirect to favorites.jsp to see the updated favourites
            })
            .catch(error => {
                console.error('Error adding item to favourites:', error);
                alert('Failed to add item to favourites. Please try again.');
            });
        }
    </script>
</body>
</html