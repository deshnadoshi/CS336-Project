<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.trains.pkg.ApplicationDB" %>
<!DOCTYPE html>
<html>
<head>
    <title>Update Train Schedule</title>
    <link rel="stylesheet" href="loginStyle.css">
</head>
<body>
    <%
        String lineName = request.getParameter("line_name");
        int numStops = Integer.parseInt(request.getParameter("num_stops"));
        int fare = Integer.parseInt(request.getParameter("fare"));
        Timestamp trainArrivalTime = Timestamp.valueOf(request.getParameter("train_arrival_time"));
        Timestamp trainDepartureTime = Timestamp.valueOf(request.getParameter("train_departure_time"));
        int travelTime = Integer.parseInt(request.getParameter("travel_time"));

        try {
            ApplicationDB db = new ApplicationDB();
            Connection con = db.getConnection();
            String updateQuery = "UPDATE trainschedules SET num_stops = ?, fare = ?, train_arrival_time = ?, train_departure_time = ?, travel_time = ? WHERE line_name = ?";
            PreparedStatement ps = con.prepareStatement(updateQuery);
            ps.setInt(1, numStops);
            ps.setInt(2, fare);
            ps.setTimestamp(3, trainArrivalTime);
            ps.setTimestamp(4, trainDepartureTime);
            ps.setInt(5, travelTime);
            ps.setString(6, lineName);
            ps.executeUpdate();
            ps.close();
            con.close();
            out.println("<p>Successfully updated train schedule for line: " + lineName + "</p>");
        } catch (Exception e) {
            out.println("Error: " + e.getMessage());
        }
    %>
</body>
</html>
