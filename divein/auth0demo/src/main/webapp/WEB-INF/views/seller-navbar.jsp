<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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

<style>
        body {
            font-family: 'Arial', sans-serif;
            background-color: #f3f3f3;
        }

        .navbar {
            background-color: #232F3E;
            padding: 10px;
        }

        .navbar .navbar-brand, .navbar .navbar-nav .nav-link {
            color: white;
        }

        .navbar .navbar-brand:hover, .navbar .navbar-nav .nav-link:hover {
            color: #ff9900;
        }

        .search-form {
            flex-grow: 1;
            max-width: 500px;
            margin: 0 20px;
        }

        .search-form .input-group {
            width: 100%;
        }

        .nav-icon {
            font-size: 1.2em;
            margin-right: 5px;
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
<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
    <a class="navbar-brand" href="/jsp/	sellerdashboard">DiveIn</a>
    <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarContent" aria-controls="navbarContent" aria-expanded="false" aria-label="Toggle navigation">
        <span class="navbar-toggler-icon"></span>
    </button>

    <div class="collapse navbar-collapse" id="navbarContent">
        <!-- Search Bar -->
        <c:if test="${products != null}">
            <form class="form-inline search-form" action="/jsp/sellerdashboard" method="GET">
                <div class="input-group">
                    <input class="form-control" type="search" name="search" placeholder="Search for products" aria-label="Search">
                    <div class="input-group-append">
                        <button class="btn btn-outline-light" type="submit"><i class="fas fa-search"></i></button>
                    </div>
                </div>
            </form>
        </c:if>

        <ul class="navbar-nav ml-auto">
			<li class="nav-item">
			               <a class="nav-link" href="/jsp/ProductManager">
			                   <i class="fas fa-box nav-icon"></i>Products
			               </a>
			           </li>
           <!-- <li class="nav-item">
                <a class="nav-link" href="/jsp/sellerdashboard">
                    <i class="fas fa-home nav-icon"></i>Home
                </a>
            </li>-->
            <li class="nav-item">
                <a class="nav-link" href="/jsp/createProduct">
                    <i class="fas fa-plus-circle"></i> Add Product
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="/jsp/inventory">
                    <i class="fas fa-warehouse"></i> Inventory
                </a>
            </li>
            <!-- Profile Dropdown -->
<li class="nav-item dropdown">
    <a class="nav-link dropdown-toggle" href="#" id="profileDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
        <i class="fas fa-user"></i> Account
    </a>
    <div class="dropdown-menu dropdown-menu-right" aria-labelledby="profileDropdown">
        <a class="dropdown-item" href="/jsp/profile">View Profile</a>
        <div class="dropdown-divider"></div>
        <a class="dropdown-item" onclick="window.location.href='/logout'">Logout</a>
    </div>
</li>


        </ul>
    </div>
</nav>


<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.9.1/dist/umd/popper.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>


</body>
</html>