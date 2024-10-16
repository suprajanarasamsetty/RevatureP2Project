<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Order Placed Successfully - duveIn</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            margin: 0;
            padding: 0;
        }
        .container {
            width: 100%;
            max-width: 800px;
            margin: 50px auto;
            background-color: #fff;
            padding: 20px;
            text-align: center;
            border-radius: 10px;
            box-shadow: 0px 0px 15px rgba(0, 0, 0, 0.1);
        }
        .success-message {
            font-size: 36px;
            color: #2874F0; /* Flipkart's blue theme color */
            font-weight: bold;
            margin-top: 20px;
        }
        .success-note {
            font-size: 18px;
            color: #666;
            margin-top: 10px;
        }
        .cta-buttons {
            margin-top: 20px;
        }
        .cta-buttons a {
            display: inline-block;
            margin: 10px;
            padding: 10px 20px;
            font-size: 16px;
            color: #fff;
            background-color: #2874F0;
            text-decoration: none;
            border-radius: 5px;
        }
        .cta-buttons a:hover {
            background-color: #1a5bb8;
        }
    </style>
</head>
<body>
    <div class="container">
        <img src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRqdA3wOXEqP0mCP0nWQjzgLsGaFvrK7h687A&s" alt="Celebration" width="200px">
        <div class="success-message">Order Placed Successfully!</div>
        <div class="success-note">Thank you for shopping with duveIn. Your order will be delivered soon!</div>
        <div class="cta-buttons">
            <a href="/jsp/buyerdashboard">Continue Shopping</a>
        </div>
    </div>
</body>
</html>