<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.trains.pkg.ApplicationDB" %>
<!DOCTYPE html>
<html>
<head>
    <title>View Train Schedules</title>
    <link rel="stylesheet" href="loginStyle.css">
</head>
<body>
    <%
        int stationId = Integer.parseInt(request.getParameter("station_id"));

        try {
            ApplicationDB db = new ApplicationDB();
            Connection con = db.getConnection();
            String query = "SELECT * FROM trainschedules WHERE origin_stop_station_id = ? OR destination_stop_station_id = ?";
            PreparedStatement ps = con.prepareStatement(query);
            ps.setInt(1, stationId);
            ps.setInt(2, stationId);
            ResultSet rs = ps.executeQuery();
    %>
            <h2>Train Schedules for Station ID: <%= stationId %></h2>
            <ul>
    <%
            while (rs.next()) {
                String lineName = rs.getString("line_name");
                int numStops = rs.getInt("num_stops");
                int fare = rs.getInt("fare");
                Timestamp trainArrivalTime = rs.getTimestamp("train_arrival_time");
                Timestamp trainDepartureTime = rs.getTimestamp("train_departure_time");
                int travelTime = rs.getInt("travel_time");
    %>
                <li>
                    <strong>Line Name:</strong> <%= lineName %><br>
                    <strong>Number of Stops:</strong> <%= numStops %><br>
                    <strong>Fare:</strong> <%= fare %><br>
                    <strong>Arrival Time:</strong> <%= trainArrivalTime %><br>
                    <strong>Departure Time:</strong> <%= trainDepartureTime %><br>
                    <strong>Travel Time:</strong> <%= travelTime %> minutes<br>
                </li>
                <hr>
    <%
            }
            rs.close();
            ps.close();
            con.close();
    %>
            </ul>
    <%
        } catch (Exception e) {
            out.println("Error: " + e.getMessage());
        }
    %>
</body>
</html>
