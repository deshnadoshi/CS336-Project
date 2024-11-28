<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.trains.pkg.ApplicationDB" %>
<%
	HttpSession currentsession = request.getSession(false);
	if (currentsession == null || currentsession.getAttribute("username") == null) {
	    response.sendRedirect("login.jsp");
	}

	// Retrieve parameters from the form
    String lineName = request.getParameter("lineName");
    String origin = request.getParameter("origin");
    String destination = request.getParameter("destination");
    String date = request.getParameter("date");
    String departureTime = request.getParameter("departureTime");
    String arrivalTime = request.getParameter("arrivalTime");
    String fare = request.getParameter("fare");
    String roundTrip = request.getParameter("roundTrip"); // Retrieve the round trip checkbox value
    String discount = request.getParameter("discount"); // Retrieve the discount selection

    
    // Here you can add your logic to process the reservation,
    // such as inserting the reservation into the database.

    // For demonstration, let's just display the information
%>
<!DOCTYPE html>
<html>
<head>
    <title>Reservation Confirmation</title>
</head>
<body>
    <h2>Reservation Confirmation</h2>
    <p><strong>Line Name:</strong> <%= lineName %></p>
    <p><strong>Origin:</strong> <%= origin %></p>
    <p><strong>Destination:</strong> <%= destination %></p>
    <p><strong>Date:</strong> <%= date %></p>
    <p><strong>Departure Time:</strong> <%= departureTime %></p>
    <p><strong>Arrival Time:</strong> <%= arrivalTime %></p>
    <p><strong>Fare:</strong> $<%= fare %></p>	    
	<p>
        <strong>Round Trip:</strong>
        <input type="checkbox" name="roundTrip" value="yes" <%= (roundTrip != null) ? "checked" : "" %>>
    </p>
    <p>
        <strong>Discount:</strong>
        <select name="discount">
            <option value="">Select Discount</option>
            <option value="Child" <%= ("C".equals(discount)) ? "selected" : "" %>>Child (25%)</option>
            <option value="Senior" <%= ("S".equals(discount)) ? "selected" : "" %>>Senior (35%)</option>
            <option value="Disability" <%= ("D".equals(discount)) ? "selected" : "" %>>Disability (50%)</option>
        </select>
    </p>    
</body>
</html>