<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register as Seller - Flippy</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <style>
        body {
            background: url('https://img.freepik.com/free-vector/flat-delivery-boy-bike-background_23-2148157707.jpg?size=626&ext=jpg') no-repeat center center fixed;
            background-size: cover;
            font-family: 'Arial', sans-serif;
            height: 100vh;
            margin: 0;
            padding: 0;
            color: black; /* Changed the text color to black */
        }

        .overlay {
            background-color: rgba(0, 0, 0, 0.6); /* Dark overlay */
            height: 100%;
            display: flex;
            align-items: center;
            justify-content: center;
            text-align: center;
        }

        .content {
            background-color: rgba(255, 255, 255, 0.8); /* Light background for content */
            padding: 30px;
            border-radius: 10px;
            max-width: 600px;
            width: 100%;
        }

        h1 {
            color: #232F3E; /* Dark text for the heading */
            font-weight: bold;
            margin-bottom: 20px;
        }

        p {
            font-size: 1.2em;
            color: black; /* Set paragraph text color to black */
        }

        ul {
            color: black; /* Set list text color to black */
        }

        .btn-register {
            background-color: #ff9900;
            color: white;
            font-size: 1.2em;
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

        .btn-register:hover {
            background-color: #cc7a00;
        }

        .btn-register a {
            color: white;
            text-decoration: none;
        }

    </style>
</head>
<body>
    <div class="overlay">
        <div class="content">
            <h1>JOIN US:</h1>
            <p>Become a member of the Flippy family and enjoy huge benefits by connecting with buyers from almost 30+ countries and take your business to the next level.</p>
            <p>We have amazing offers for sellers, including:</p>
            <ul style="text-align: left;">
                <li>Less charges on shipping</li>
                <li>No package charges</li>
                <li>24x7 customer executive helpline</li>
            </ul>
            <!-- Register button -->
            <button class="btn-register">
                <a href="/login">Register</a>
            </button>
        </div>
    </div>
</body>
</html>
