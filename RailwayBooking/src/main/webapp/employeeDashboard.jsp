<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="com.trains.pkg.ApplicationDB" %>
<!DOCTYPE html>
<html>
<head>
    <title>Employee Dashboard</title>
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
        Hello, <%= request.getParameter("firstName") %> <%= request.getParameter("lastName") %>! You are successfully logged in as an employee!
    </h2>

    <!-- Search Train Schedules Button -->
    <a href="searchTrainSchedules.jsp" class="search-button">Search Train Schedules</a>

    <!-- Employee-Specific Sections -->

    <h3>Manage Train Schedules</h3>
    <p>You can manage the available train schedules here. Click below to add, modify, or delete schedules.</p>
    <a href="manageTrainSchedules.jsp" class="action-button">Manage Schedules</a>

    <h3>View Reservation Reports</h3>
    <p>View and analyze reservation reports, including total fares, customer preferences, and other statistics.</p>
    <a href="viewReservationReports.jsp" class="action-button">View Reports</a>

    <h3>Customer Support</h3>
    <p>If you need to assist customers with their reservations or account issues, click below for the support tools.</p>
    <a href="customerSupport.jsp" class="action-button">Customer Support</a>

    <h3>Train Maintenance</h3>
    <p>Ensure trains are well-maintained and track maintenance requests.</p>
    <a href="trainMaintenance.jsp" class="action-button">View Maintenance Requests</a>

</body>
</html>
