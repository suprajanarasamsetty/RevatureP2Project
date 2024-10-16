<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Favourite Items</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <style>
		.product-image {
			width: 100%;
			           height: 200px;
			           object-fit: contain;
			           padding: 10px;
			           background-color: #f8f9fa;
		       }
			   .card {
			               margin-bottom: 20px; /* Space between cards */
			               box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1); /* Optional: Add shadow to cards */
			           }			  
    </style>
</head>
<body>
	<jsp:include page="buyer-navbar.jsp">
		        <jsp:param value="navbar" name=""/>
		    </jsp:include>
    <div class="container mt-4">
        <h2 class="mb-4">Your Favourites</h2>
        <div class="row" id="favouriteGrid"></div>
    </div>

    <script>
        // Fetch and display favourite items for the user
        const userId = '<%= session.getAttribute("userId") %>';  // Retrieve userId from session
		const newUserId = removeFirstSixCharacters(userId);
				function removeFirstSixCharacters(userId) {
				    return userId.slice(6);
				}
		console.log(userId);
		function fetchFavouriteItems() {
		    fetch(`http://localhost:8086/api/favourites/?userId=\${newUserId}`)
		        .then(response => {
		            if (!response.ok) {
		                throw new Error('Failed to fetch favourites');
		            }
		            return response.json();
		        })
		        .then(favourites => {
		            renderFavourites(favourites);
		        })
		        .catch(error => console.error('Error fetching favourites:', error));
		}

		

        // Function to render favourite items on the page
        function renderFavourites(favourites) {
            const favouriteGrid = document.getElementById('favouriteGrid');
            favouriteGrid.innerHTML = "";  // Clear existing items

            favourites.forEach(favourite => {
                const productHTML = `
                    <div class="col-md-4 mb-4">
                        <div class="card">
                            <img class="product-image" src="\${favourite.imageurl}" alt="\${favourite.name}">
                            <div class="card-body">
                                <p class="card-text"><strong>Name:</strong> \${favourite.name}</p>
                                <p class="card-text"><strong>Price:</strong> $\${favourite.unitPrice}</p>
                                
								<button class="btn btn-danger" onclick="removeFromFavourites(\${favourite.favouriteId})">
								    Remove
								</button>

                            </div>
                        </div>
                    </div>
                `;
                favouriteGrid.innerHTML += productHTML;  // Append the HTML to the grid
            });
        }

       

        // Function to remove an item from favourites
		// Function to remove an item from favourites
		function removeFromFavourites(favouriteId) {
		    fetch(`http://localhost:8086/api/favourites/delete/\${favouriteId}`, {
		        method: 'DELETE'
		    })
		    .then(response => {
		        if (!response.ok) {
		            throw new Error('Failed to remove item from favourites');
		        }
		        alert('Item removed from favourites successfully!');
		        fetchFavouriteItems();  // Refresh the favourites list
		    })
		    .catch(error => {
		        console.error('Error removing item from favourites:', error);
		        alert('Failed to remove item from favourites.');
		    });
		}


        // Fetch favourites when the page loads
        window.onload = fetchFavouriteItems;
    </script>
</body>
</html>
