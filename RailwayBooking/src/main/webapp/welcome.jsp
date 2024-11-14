<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Welcome</title>
    <script>
        function showLogoutAlert() {
            alert("You have been logged out successfully.");
        }
    </script>
    <style>
        /* Style for the logout button container */
        .logout-container {
            position: absolute;
            top: 10px;
            right: 10px;
        }
        /* Additional styling for the button */
        .logout-button {
            padding: 5px 10px;
            font-size: 14px;
            cursor: pointer;
        }
        /* Centering the hello message */
        .centered-message {
            text-align: center;
            margin-top: 50px; /* Optional: Add some space from the top */
        }
    </style>
</head>
<body>
    <div class="logout-container">
        <!-- Logout Button -->
        <form action="logout.jsp" method="post">
            <input type="submit" value="Logout" class="logout-button" onclick="showLogoutAlert();">
        </form>
    </div>

    <h2 class="centered-message">
        Hello, <%= request.getParameter("firstName") %> <%= request.getParameter("lastName") %>! You are successfully logged in!
    </h2>
</body>
</html>