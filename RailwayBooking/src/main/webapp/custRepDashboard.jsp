<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="com.trains.pkg.ApplicationDB" %>
<!DOCTYPE html>
<html>
<head>
    <title>Customer Representative Dashboard</title>
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

    <h3>Assist Customers</h3>
    <!-- Customer representative can search and manage reservations for customers -->
    <a href="searchCustomerReservations.jsp" class="assist-button">Search Customer Reservations</a>

    <h3>View Customer Feedback</h3>
    <!-- Customer representative can view feedback -->
    <a href="viewCustomerFeedback.jsp" class="assist-button">View Customer Feedback</a>

    <h3>Reservation Cancellation</h3>
    <!-- Customer representative can cancel customer reservations -->
    <a href="cancelCustomerReservation.jsp" class="assist-button">Cancel Reservation</a>
</body>
</html>
