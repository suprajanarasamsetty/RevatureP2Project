<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">

    <!-- jQuery (required for Bootstrap's JavaScript plugins) -->
    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>

    <!-- Popper.js (required for Bootstrap's dropdown) -->
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.9.1/dist/umd/popper.min.js"></script>

    <!-- Bootstrap JS -->
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>

    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Buyer Navbar</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style>
        body {
            font-family: 'Arial', sans-serif;
            background-color: #f3f3f3;
        }

        .navbar {
            background-color: #131921; /* Dark background */
            padding: 10px;
            position: sticky; /* Sticky navbar */
            top: 0;
            z-index: 1000; /* Keep above other elements */
        }

        .navbar .navbar-brand {
			color: #ffffff; /* White for links */
            font-size: 1.8em; /* Increase brand size */
            font-weight: bold;
        }

        .navbar .navbar-brand:hover {
			color: #ff9900; /* Amazon yellow for brand */
        }

        .navbar .navbar-nav .nav-link {
            color: #ffffff; /* White for links */
            font-size: 1.1em;
            margin-left: 15px; /* Spacing between links */
        }

        .navbar .navbar-nav .nav-link:hover {
            color: #ff9900; /* Hover effect */
        }

        .search-form {
            max-width: 400px; /* Adjusted max-width for better layout */
            margin-right: 10px; /* Margin to separate from categories */
        }

        .nav-icon {
            font-size: 1.3em; /* Slightly larger icons */
            margin-right: 5px;
        }

        .dropdown-menu {
            background-color: #ffffff; /* White dropdown */
            border-radius: 0; /* Remove borders for a flat design */
        }

        .dropdown-item {
            color: #ff9900; /* Dark text for dropdown */
        }

        .dropdown-item:hover {
            color: #ff9900; /* Light hover effect */
        }

        @media (max-width: 992px) {
            .search-form {
                margin: 10px 0;
                max-width: 100%;
            }
        }
    </style>
</head>
<body>
    <!-- Top Navigation Bar -->
    <nav class="navbar navbar-expand-lg">
        <a class="navbar-brand" href="/jsp/buyerdashboard">
			<img src="https://media.istockphoto.com/id/1170138456/vector/waves-and-jumping-dolphin-logo-design-vector-illustrations.jpg?s=612x612&w=0&k=20&c=tic6MX4It7qvPliMtp5aTdnMMkZw8L5EehJFOVCj2d4="  alt="Dolphin Logo" style="height: 40px;">
		</a>
		

        <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarContent" aria-controls="navbarContent" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="navbarContent">
            <div class="mx-auto d-flex align-items-center"> <!-- Centering container -->
                <!-- Centered Search Bar -->
                <form class="form-inline search-form" action="/jsp/buyerdashboard" method="GET">
                    <div class="input-group">
                        <input class="form-control" type="search" name="search" placeholder="Search for products" aria-label="Search">
                        <div class="input-group-append">
                            <button class="btn btn-outline-light" type="submit"><i class="fas fa-search"></i></button>
                        </div>
                    </div>
                </form>

                <!-- Categories Dropdown -->
                <div class="nav-item dropdown"> 
                    <a class="nav-link dropdown-toggle" href="#" id="categoryDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                        <i class="fas fa-th nav-icon"></i>All
                    </a>
                    <div class="dropdown-menu dropdown-menu-right" aria-labelledby="categoryDropdown">
                        <form class="p-2" id="categoryForm" action="${pageContext.request.contextPath}/jsp/buyerdashboard" method="GET">
                            <select class="form-control" name="category" onchange="this.form.submit();">
                                <option value="">All Categories</option>
                                <c:forEach var="category" items="${categories}">
                                    <option value="${category.name}" <c:if test="${param.category == category.name}">selected</c:if>>${category.name}</option>
                                </c:forEach>
                            </select>
                        </form>
                    </div>
                </div>
            </div>

            <ul class="navbar-nav ml-auto">
                <c:if test="${sessionScope.userId != null}">
                    <!-- Favorites -->
                    <li class="nav-item">
                        <a class="nav-link" href="/jsp/favorite">
                            <i class="fas fa-heart nav-icon"></i>Favorites
                        </a>
                    </li>

                    <!-- Other nav items -->
                    <li class="nav-item">
                        <a class="nav-link" href="/jsp/cart">
                            <i class="fas fa-shopping-cart nav-icon"></i>Cart
                        </a>
                    </li>

                    <li class="nav-item">
                        <a class="nav-link" href="/jsp/orders">
                            <i class="fas fa-box nav-icon"></i>Orders
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="/jsp/profile">
                            <i class="fas fa-user nav-icon"></i>Profile
                        </a>
                    </li>
                </c:if>

                <c:if test="${sessionScope.userId == null}">
                    <!-- Login Dropdown -->
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" href="#" id="loginDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                            <i class="fas fa-sign-in-alt nav-icon"></i>Login
                        </a>
                        <div class="dropdown-menu dropdown-menu-right" aria-labelledby="loginDropdown">
                            <a class="dropdown-item" href="/jsp/login">User Login</a>
                            <div class="dropdown-divider"></div>
                            <a class="dropdown-item" href="/jsp/sellerLogin">Seller Login</a>
                        </div>
                    </li>
                </c:if>
            </ul>
        </div>
    </nav>

    <!-- Include Bootstrap JS and other dependencies -->
    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.9.1/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>
