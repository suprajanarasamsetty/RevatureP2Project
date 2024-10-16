<%@ page import="com.example.demo.dto.ProductResponse" %>
<%@ page import="java.util.List" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Seller Dashboard</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style>
        .product-image {
        width: 100%;              /* Makes the image take full width of the card */
        height: 200px;            /* Fixed height for uniformity */
        object-fit: contain;      /* Ensures the whole image is shown without cropping */
        padding: 10px;            /* Adds padding inside the image for spacing */
        background-color: #f8f9fa; /* Light background to make padding more visible */
    }
    </style>
</head>
<body>
    <jsp:include page="seller-navbar.jsp">
        <jsp:param value="navbar" name=""/>
    </jsp:include>

    <!-- Main content -->
    <div class="dashboard-wrapper">

        <!-- Products Grid -->
        <div class="row" id="productGrid">
            <c:set var="searchQuery" value="${param.search}"/> <!-- Capture search query -->
            <c:forEach var="product" items="${products}">
                <c:if test="${empty searchQuery || fn:containsIgnoreCase(product.name, searchQuery) || fn:containsIgnoreCase(product.description, searchQuery)}">
                    <div class="col-md-4 mb-4 product-item">
                        <div class="card">
                            <img class="card-img-top product-image" src="${product.imageurl}" alt="Product Image">
                            <div class="card-body">
                                <h5 class="card-title">${product.name}</h5>
                                <p class="card-text"><strong>Description : </strong>${product.description}</p>
                                <p class="card-test"><strong>SKU Code :</strong>${product.skuCode}</p>
                                <p class="card-text"><strong>Price :</strong> $${product.price}</p>

                                <!-- Buttons side by side -->
                                <div class="d-flex justify-content-start">
                                    <form method="post" action="/addToCart" class="mr-2">
                                        <input type="hidden" name="productId" value="${product.id}">
                                    </form>
                                    <form method="post" action="/buyNow">
                                        <input type="hidden" name="productId" value="${product.id}">
                                    </form>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:if>
            </c:forEach>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.9.1/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>