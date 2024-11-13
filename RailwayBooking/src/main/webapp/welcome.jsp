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
</head>
<body>
    <h2>Hello, <%= request.getParameter("firstName") %> <%= request.getParameter("lastName") %>! You are successfully logged in!</h2>

    <!-- Logout Button -->
    <form action="logout.jsp" method="post">
        <input type="submit" value="Logout" onclick="showLogoutAlert();">
    </form>
</body>
</html>
