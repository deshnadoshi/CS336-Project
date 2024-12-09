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

    <div class="section-divider"></div> <!-- Divider -->
    
    <!-- Train Schedules Management -->
    <h3>Manage Train Schedules</h3>
    <form action="manageTrainSchedules.jsp" method="post">
        <label for="line_name">Select Line Name:</label>
        <select name="line_name" id="line_name">
            <%
                try {
                    ApplicationDB db = new ApplicationDB();
                    Connection con = db.getConnection();
                    String query = "SELECT line_name FROM trainschedules WHERE is_operational = 1";
                    Statement stmt = con.createStatement();
                    ResultSet rs = stmt.executeQuery(query);
                    
                    while (rs.next()) {
                        String lineName = rs.getString("line_name");
                        out.println("<option value=\"" + lineName + "\">" + lineName + "</option>");
                    }
                    
                    rs.close();
                    stmt.close();
                    con.close();
                } catch (Exception e) {
                    out.println("Error: " + e.getMessage());
                }
            %>
        </select>
        <input type="submit" name="action" value="Edit">
        <input type="submit" name="action" value="Delete">
    </form>

    <div class="section-divider"></div> <!-- Divider -->

    <!-- New Section: Train Schedules for a Given Station -->
    <h3>Train Schedules for a Given Station</h3>
    <form action="viewTrainSchedules.jsp" method="post">
        <label for="station_id">Select Station:</label>
        <select name="station_id" id="station_id">
            <%
                try {
                    ApplicationDB db = new ApplicationDB();
                    Connection con = db.getConnection();
                    String query = "SELECT station_id, name FROM stations";
                    Statement stmt = con.createStatement();
                    ResultSet rs = stmt.executeQuery(query);
                    
                    while (rs.next()) {
                        int stationId = rs.getInt("station_id");
                        String stationName = rs.getString("name");
                        out.println("<option value=\"" + stationId + "\">" + stationName + "</option>");
                    }
                    
                    rs.close();
                    stmt.close();
                    con.close();
                } catch (Exception e) {
                    out.println("Error: " + e.getMessage());
                }
            %>
        </select>
        <input type="submit" value="View Schedules">
    </form>

    <div class="section-divider"></div> <!-- Divider -->

    <!-- Customers with Reservations -->
    <h3>Customers with Reservations on a Given Line and Date</h3>
    <form action="viewReservations.jsp" method="post">
        <label for="line_name">Select Line Name:</label>
        <select name="line_name" id="line_name">
            <%
                try {
                    ApplicationDB db = new ApplicationDB();
                    Connection con = db.getConnection();
                    String query = "SELECT line_name FROM trainschedules WHERE is_operational = 1";
                    Statement stmt = con.createStatement();
                    ResultSet rs = stmt.executeQuery(query);
                    
                    while (rs.next()) {
                        String lineName = rs.getString("line_name");
                        out.println("<option value=\"" + lineName + "\">" + lineName + "</option>");
                    }
                    
                    rs.close();
                    stmt.close();
                    con.close();
                } catch (Exception e) {
                    out.println("Error: " + e.getMessage());
                }
            %>
        </select>
        <label for="reservation_date">Select Date:</label>
        <input type="date" name="reservation_date" id="reservation_date">
        <input type="submit" value="View Customers">
    </form>

    <div class="section-divider"></div> <!-- Divider -->
    
    <!-- Respond to Customer Questions -->
    <h3>Respond to Customer Questions</h3>
    <%
        try {
            ApplicationDB db = new ApplicationDB();
            Connection con = db.getConnection();
            String query = "SELECT customer_id, question FROM faq WHERE answer = 'A customer representative will answer this question shortly.'";
            Statement stmt = con.createStatement();
            ResultSet rs = stmt.executeQuery(query);
            
            while (rs.next()) {
                String customerId = rs.getString("customer_id");
                String question = rs.getString("question");
    %>
                <div class="faq">
                    <p><strong>Customer ID:</strong> <%= customerId %></p>
                    <p><strong>Question:</strong> <%= question %></p>
                    <form action="respondToQuestion.jsp" method="post">
                        <input type="hidden" name="customer_id" value="<%= customerId %>">
                        <input type="hidden" name="question" value="<%= question %>">
                        <label for="answer">Your Answer:</label>
                        <textarea name="answer" id="answer" rows="4" required></textarea>
                        <input type="submit" value="Submit Answer">
                    </form>
                </div>
                <hr> <!-- Divider between each question -->
    <%
            }
            rs.close();
            stmt.close();
            con.close();
        } catch (Exception e) {
            out.println("Error: " + e.getMessage());
        }
    %>

</body>
</html>
