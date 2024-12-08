<%@ page language="java" contentType="text/html; charset=UTF-8"%>
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
            
            // Update train schedule
            String updateTrainScheduleQuery = "UPDATE trainschedules SET num_stops = ?, fare = ?, train_arrival_time = ?, train_departure_time = ?, travel_time = ? WHERE line_name = ?";
            PreparedStatement ps1 = con.prepareStatement(updateTrainScheduleQuery);
            ps1.setInt(1, numStops);
            ps1.setInt(2, fare);
            ps1.setTimestamp(3, trainArrivalTime);
            ps1.setTimestamp(4, trainDepartureTime);
            ps1.setInt(5, travelTime);
            ps1.setString(6, lineName);
            ps1.executeUpdate();
            ps1.close();
            
            // Update corresponding reservations status to CHANGED
            String updateReservationsQuery = "UPDATE reservations SET status = 'CHANGED' WHERE line_name = ?";
            PreparedStatement ps2 = con.prepareStatement(updateReservationsQuery);
            ps2.setString(1, lineName);
            ps2.executeUpdate();
            ps2.close();
            
            con.close();
            out.println("<p>Successfully updated train schedule and corresponding reservations to CHANGED for line: " + lineName + "</p>");
        } catch (Exception e) {
            out.println("Error: " + e.getMessage());
        }
    %>
</body>
</html>
