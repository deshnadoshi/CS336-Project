<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="com.trains.pkg.ApplicationDB" %>
<!DOCTYPE html>
<html>
<head>
    <title>Admin Dashboard</title>
    <link rel="stylesheet" href="loginStyle.css">
    <script>
        function showLogoutAlert() {
            alert("You have been logged out successfully.");
        }
    </script>
</head>
<body>
    <div class="logout-container">
        <!-- Logout Button -->
        <form action="logout.jsp" method="post">
            <input type="submit" value="Logout" class="logout-button" onclick="showLogoutAlert();">
        </form>
    </div>

    <h2 class="centered-message">
        Welcome, <%= request.getParameter("firstName") %> <%= request.getParameter("lastName") %>!
    </h2>

    <h3>Manage Users</h3>
    <!-- Admin can view all customers and employees -->
    <a href="viewAllUsers.jsp" class="manage-button">View All Users</a>

    <h3>Manage Reservations</h3>
    <!-- Admin can view all reservations -->
    <a href="viewAllReservations.jsp" class="manage-button">View All Reservations</a>

    <h3>System Settings</h3>
    <!-- Admin can access system settings -->
    <a href="systemSettings.jsp" class="manage-button">System Settings</a>

    <h3>Reservation Statistics</h3>
    <!-- Admin can view reservation statistics -->
    <a href="reservationStats.jsp" class="manage-button">View Reservation Stats</a>
</body>
</html>
