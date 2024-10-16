<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Flippy - Welcome</title>
  <style>
    body {
      font-family: Arial, sans-serif;
      margin: 0;
      padding: 0;
      background-color: #f3f3f3;
    }

    /* Navbar styling */
    .navbar {
      background-color: #232f3e;
      padding: 15px;
      position: fixed;
      width: 100%;
      top: 0;
      z-index: 1000;
    }

    .navbar ul {
      list-style-type: none;
      margin: 0;
      padding: 0;
      display: flex;
      justify-content: flex-end;
    }

    .navbar ul li {
      margin-left: 20px;
    }

    .navbar ul li a {
      text-decoration: none;
      color: white;
      font-size: 14px;
      padding: 10px 20px;
      border-radius: 3px;
      transition: background-color 0.3s ease;
      font-weight: 500;
    }

    .navbar ul li a:hover {
      background-color: #37475a;
    }

    /* Hero section styling */
    .hero {
      display: flex;
      flex-direction: column;
      justify-content: center;
      align-items: center;
      height: 100vh;
      text-align: center;
      background-color: #ffffff;
      padding: 20px;
      box-shadow: inset 0 0 15px rgba(0, 0, 0, 0.1);
      margin-top: 60px; /* Offset to account for fixed navbar */
    }

    .hero h1 {
      font-size: 48px;
      color: #131a22;
      margin-bottom: 20px;
      line-height: 1.2;
    }

    .hero p {
      font-size: 22px;
      color: #111111;
    }

    /* Buttons for login/register */
    .button-container {
      margin-top: 40px;
    }

    .button-container a {
      text-decoration: none;
      background-color: #ffa41b;
      color: #0f1111;
      padding: 15px 30px;
      border-radius: 3px;
      margin: 0 10px;
      font-size: 18px;
      transition: background-color 0.3s ease, box-shadow 0.2s ease;
      box-shadow: 0 2px 5px rgba(0, 0, 0, 0.15);
      font-weight: bold;
    }

    .button-container a:hover {
      background-color: #ff9900;
      box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
    }

  </style>
</head>
<body>

  <!-- Navbar -->
  <nav class="navbar">
    <ul>
      <li><a href="/login">Login</a></li>
      <li><a href="/login">Register</a></li>
      <li><a href="/jsp/registerAsSeller">Register As Seller</a></li>
    </ul>
  </nav>

  <!-- Hero Section -->
  <section class="hero">
    <h1>Welcome to DiveIn</h1>
    <p>Your favorite place to shop online!</p>
    <div class="button-container">
      <a href="https://dev-nvbdyema8gq6gsle.us.auth0.com/u/login?state=hKFo2SBwRm1HRWxiSUhJdFBsYm40YUpBNmlIX09mSmRuVUFNOKFur3VuaXZlcnNhbC1sb2dpbqN0aWTZIFpxU3g2RmJwSHBqTVowbWdzdWhzUkF2RE02cWhfci1jo2NpZNkgREtEdjF1TFFpWXg0UnE5WGtlanhjMjVNTHJ0NHRlQmQ">Login</a>
      <a href="https://dev-nvbdyema8gq6gsle.us.auth0.com/u/login?state=hKFo2SBwRm1HRWxiSUhJdFBsYm40YUpBNmlIX09mSmRuVUFNOKFur3VuaXZlcnNhbC1sb2dpbqN0aWTZIFpxU3g2RmJwSHBqTVowbWdzdWhzUkF2RE02cWhfci1jo2NpZNkgREtEdjF1TFFpWXg0UnE5WGtlanhjMjVNTHJ0NHRlQmQ">Register</a>
    </div>
  </section>

</body>
</html>
