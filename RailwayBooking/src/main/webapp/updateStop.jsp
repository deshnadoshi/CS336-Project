<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.trains.pkg.ApplicationDB" %>
<!DOCTYPE html>
<html>
<head>
    <title>Update Stop</title>
    <link rel="stylesheet" href="loginStyle.css">
</head>
<body>
    <%
        String lineName = request.getParameter("line_name");
        int stationId = Integer.parseInt(request.getParameter("station_id"));
        Time stopArrivalTime = Time.valueOf(request.getParameter("stop_arrival_time"));
        Time stopDepartureTime = Time.valueOf(request.getParameter("stop_departure_time"));
        int stopNumber = Integer.parseInt(request.getParameter("stop_number"));

        try {
            ApplicationDB db = new ApplicationDB();
            Connection con = db.getConnection();
            String updateQuery = "UPDATE stops_at SET stop_arrival_time = ?, stop_departure_time = ?, stop_number = ? WHERE line_name = ? AND station_id = ?";
            PreparedStatement ps = con.prepareStatement(updateQuery);
            ps.setTime(1, stopArrivalTime);
            ps.setTime(2, stopDepartureTime);
            ps.setInt(3, stopNumber);
            ps.setString(4, lineName);
            ps.setInt(5, stationId);
            ps.executeUpdate();
            ps.close();
            con.close();
            out.println("<p>Successfully updated stop information for line: " + lineName + " at station: " + stationId + "</p>");
        } catch (Exception e) {
            out.println("Error: " + e.getMessage());
        }
    %>
</body>
</html>
