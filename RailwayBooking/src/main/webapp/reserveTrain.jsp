<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="com.trains.pkg.ApplicationDB" %>
<%
    HttpSession currentsession = request.getSession(false);
    if (currentsession == null || currentsession.getAttribute("username") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String username = (String) currentsession.getAttribute("username");
    String firstName = (String) currentsession.getAttribute("firstName");
    String lastName = (String) currentsession.getAttribute("lastName");

    // Initialize reservation form variables
    String lineName = request.getParameter("lineName");
    String origin = request.getParameter("origin");
    String destination = request.getParameter("destination");
    String date = request.getParameter("date");
    String departureTime = request.getParameter("departureTime");
    String arrivalTime = request.getParameter("arrivalTime");
    int fare = Integer.parseInt(request.getParameter("fare"));

    // Variables for reservation logic
    int resNumber = 0;
    java.sql.Date resDate = null;
    String discountType = null;
    boolean isRoundtrip = false;
    float totalFare = fare;
    boolean reservationCreated = false;
    String message = "";

    // Execute reservation logic only when the form is submitted (POST request with specific inputs)
    if ("POST".equalsIgnoreCase(request.getMethod()) && request.getParameter("discountType") != null) {
        // Generate random reservation number
        Random rand = new Random();
        resNumber = 100000 + rand.nextInt(900000);
        
        // Parse the date
        try {
            resDate = java.sql.Date.valueOf(date);
        } catch (IllegalArgumentException e) {
            message = "Error: Invalid date format.";
        }

        if (resDate != null) {
            // Retrieve additional parameters
            discountType = request.getParameter("discountType");
            isRoundtrip = request.getParameter("isRoundtrip") != null;

            // Calculate total fare based on discounts and roundtrip
            if ("child".equals(discountType)) {
                totalFare *= 0.75;
            } else if ("senior".equals(discountType)) {
                totalFare *= 0.65;
            } else if ("disabled".equals(discountType)) {
                totalFare *= 0.50;
            }

            if (isRoundtrip) {
                totalFare *= 2;
            }

            // Add reservation to the database
            try {
                ApplicationDB db = new ApplicationDB();
                Connection con = db.getConnection();
                String insertQuery = "INSERT INTO reservations (res_number, res_datetime, total_fare, is_roundtrip, discount_type, res_origin_station_id, res_destination_station_id, line_name, portfolio_username) " +
                                     "VALUES (?, ?, ?, ?, ?, (SELECT station_id FROM stations WHERE name = ?), (SELECT station_id FROM stations WHERE name = ?), ?, ?)";
                PreparedStatement ps = con.prepareStatement(insertQuery);
                ps.setInt(1, resNumber);
                ps.setDate(2, resDate);
                ps.setFloat(3, totalFare);
                ps.setBoolean(4, isRoundtrip);
                ps.setString(5, discountType);
                ps.setString(6, origin);
                ps.setString(7, destination);
                ps.setString(8, lineName);
                ps.setString(9, username);

                int result = ps.executeUpdate();
                if (result > 0) {
                    reservationCreated = true;
                    message = "Reservation successful!";
                } else {
                    message = "Reservation failed!";
                }
                ps.close();
                con.close();
            } catch (Exception e) {
                message = "Error: " + e.getMessage();
            }
        }
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Create Reservation</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
    <form action="welcome.jsp" method="get" style="margin-bottom: 20px;">
        <input type="hidden" name="firstName" value="<%= firstName %>">
        <input type="hidden" name="lastName" value="<%= lastName %>">
        <button type="submit">View Your Dashboard</button>
    </form>
    <h2>Reserve Train</h2>
    <form action="reserveTrain.jsp" method="post">
        <label for="discountType">Discount Type:</label>
        <select id="discountType" name="discountType">
            <option value="">None</option>
            <option value="child">Child</option>
            <option value="senior">Senior</option>
            <option value="disabled">Disabled</option>
        </select><br><br>
        <label for="isRoundtrip">Roundtrip:</label>
        <input type="checkbox" id="isRoundtrip" name="isRoundtrip"><br><br>
        <input type="hidden" name="lineName" value="<%= lineName %>">
        <input type="hidden" name="origin" value="<%= origin %>">
        <input type="hidden" name="destination" value="<%= destination %>">
        <input type="hidden" name="date" value="<%= date %>">
        <input type="hidden" name="departureTime" value="<%= departureTime %>">
        <input type="hidden" name="arrivalTime" value="<%= arrivalTime %>">
        <input type="hidden" name="fare" value="<%= fare %>">
        <input type="hidden" name="firstName" value="<%= firstName %>">
        <input type="hidden" name="lastName" value="<%= lastName %>">
        <input type="submit" value="Confirm Reservation">
    </form>

    <% if (reservationCreated) { %>
        <h3><%= message %></h3>
        <h4>Reservation Details:</h4>
        <p>Reservation Number:<%= resNumber %></p>
        <p>Reservation Date: <%= resDate %></p>
        <p>Line Name: <%= lineName %></p>
        <p>Origin Station: <%= origin %></p>
        <p>Destination Station:<%= destination %></p>
        <p>Date of Travel:<%= date %></p>
        <p>Departure Time: <%= departureTime %></p>
        <p>Arrival Time: <%= arrivalTime %></p>
        <p>Fare: $<%= totalFare %></p>
        <p>Discount Type: <%= discountType != null ? discountType : "None" %></p>
        <p>Roundtrip:<%= isRoundtrip ? "Yes" : "No" %></p>
    <% } else if (message != "") { %>
        <h3><%= message %></h3>
    <% } %>
</body>
</html>
