<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="com.trains.pkg.ApplicationDB" %>
<!DOCTYPE html>
<html>
<head>
    <title>Welcome</title>
    <link rel="stylesheet" href="loginStyle.css">
    <script>
        function showLogoutAlert() {
            alert("You have been logged out successfully.");
        }

        function showCancelAlert() {
            alert("Reservation has been cancelled successfully.");
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
        Hello, <%= request.getParameter("firstName") %> <%= request.getParameter("lastName") %>! You are successfully logged in!
    </h2>
    
    <!-- Search Train Schedules Button -->
    <a href="searchTrainSchedules.jsp" class="search-button">Search Train Schedules</a>

    <h3>Current Reservations</h3>
    <%
        // Fetch current reservations
        HttpSession currentsession = request.getSession(false);
        String username = (String) currentsession.getAttribute("username");
        
        try {
            ApplicationDB db = new ApplicationDB();
            Connection con = db.getConnection();
            String currentQuery = "SELECT r.res_number, r.res_datetime, r.total_fare, r.is_roundtrip, r.discount_type, s1.name AS origin_name, s2.name AS destination_name, r.line_name " +
                                  "FROM reservations r " +
                                  "JOIN stations s1 ON r.res_origin_station_id = s1.station_id " +
                                  "JOIN stations s2 ON r.res_destination_station_id = s2.station_id " +
                                  "WHERE r.portfolio_username = ? AND r.status = 'CONFIRMED'";
            PreparedStatement currentStmt = con.prepareStatement(currentQuery);
            currentStmt.setString(1, username);
            ResultSet currentRs = currentStmt.executeQuery();
            
            while (currentRs.next()) {
                int resNumber = currentRs.getInt("res_number");
                String resDatetime = currentRs.getTimestamp("res_datetime").toString();
                float totalFare = currentRs.getFloat("total_fare");
                boolean isRoundtrip = currentRs.getBoolean("is_roundtrip");
                String discountType = currentRs.getString("discount_type");
                String originName = currentRs.getString("origin_name");
                String destinationName = currentRs.getString("destination_name");
                String lineName = currentRs.getString("line_name");
                
    %>
                <div class="reservation">
                    <p><strong>Reservation Number:</strong> <%= resNumber %></p>
                    <p><strong>Reservation Date and Time:</strong> <%= resDatetime %></p>
                    <p><strong>Line Name:</strong> <%= lineName %></p>
                    <p><strong>Origin Station:</strong> <%= originName %></p>
                    <p><strong>Destination Station:</strong> <%= destinationName %></p>
                    <p><strong>Total Fare:</strong> $<%= totalFare %></p>
                    <p><strong>Discount Type:</strong> <%= discountType %></p>
                    <p><strong>Roundtrip:</strong> <%= isRoundtrip ? "Yes" : "No" %></p>
                    <form action="cancelReservation.jsp" method="post" onsubmit="showCancelAlert();">
                        <input type="hidden" name="resNumber" value="<%= resNumber %>">
                        <input type="submit" value="Cancel Reservation">
                    </form>
                </div>
    <%
            }
            currentRs.close();
            currentStmt.close();
        } catch (Exception e) {
            out.println("Error: " + e.getMessage());
        }
    %>

    <h3>Past Reservations</h3>
    <%
        // Fetch past reservations
        try {
            ApplicationDB db = new ApplicationDB();
            Connection con = db.getConnection();
            String pastQuery = "SELECT r.res_number, r.res_datetime, r.total_fare, r.is_roundtrip, r.discount_type, s1.name AS origin_name, s2.name AS destination_name, r.line_name, r.status " +
                               "FROM reservations r " +
                               "JOIN stations s1 ON r.res_origin_station_id = s1.station_id " +
                               "JOIN stations s2 ON r.res_destination_station_id = s2.station_id " +
                               "WHERE r.portfolio_username = ? AND r.status <> 'CONFIRMED'";
            PreparedStatement pastStmt = con.prepareStatement(pastQuery);
            pastStmt.setString(1, username);
            ResultSet pastRs = pastStmt.executeQuery();
            
            while (pastRs.next()) {
                int resNumber = pastRs.getInt("res_number");
                String resDatetime = pastRs.getTimestamp("res_datetime").toString();
                float totalFare = pastRs.getFloat("total_fare");
                boolean isRoundtrip = pastRs.getBoolean("is_roundtrip");
                String discountType = pastRs.getString("discount_type");
                String originName = pastRs.getString("origin_name");
                String destinationName = pastRs.getString("destination_name");
                String lineName = pastRs.getString("line_name");
                String status = pastRs.getString("status");
    %>
                <div class="reservation">
                    <p><strong>Reservation Number:</strong> <%= resNumber %></p>
                    <p><strong>Reservation Date and Time:</strong> <%= resDatetime %></p>
                    <p><strong>Line Name:</strong> <%= lineName %></p>
                    <p><strong>Origin Station:</strong> <%= originName %></p>
                    <p><strong>Destination Station:</strong> <%= destinationName %></p>
                    <p><strong>Total Fare:</strong> $<%= totalFare %></p>
                    <p><strong>Discount Type:</strong> <%= discountType %></p>
                    <p><strong>Roundtrip:</strong> <%= isRoundtrip ? "Yes" : "No" %></p>
                    <p><strong>Status:</strong> <%= status %></p>
                </div>
    <%
            }
            pastRs.close();
            pastStmt.close();
        } catch (Exception e) {
            out.println("Error: " + e.getMessage());
        }
    %>
</body>
</html>
