<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.trains.pkg.ApplicationDB" %>
<!DOCTYPE html>
<html>
<head>
    <title>Edit Train Schedule</title>
    <link rel="stylesheet" href="loginStyle.css">
</head>
<body>
    <%
        String lineName = request.getParameter("line_name");
        ApplicationDB db = new ApplicationDB();
        Connection con = db.getConnection();
        
        // Retrieve train schedule details
        String trainScheduleQuery = "SELECT * FROM trainschedules WHERE line_name = ?";
        PreparedStatement ps1 = con.prepareStatement(trainScheduleQuery);
        ps1.setString(1, lineName);
        ResultSet rs1 = ps1.executeQuery();
        
        if (rs1.next()) {
    %>
            <h2>Edit Train Schedule for <%= lineName %></h2>
            <form action="updateTrainSchedule.jsp" method="post">
                <input type="hidden" name="line_name" value="<%= lineName %>">
                <label for="num_stops">Number of Stops:</label>
                <input type="text" name="num_stops" value="<%= rs1.getInt("num_stops") %>">
                <label for="fare">Fare:</label>
                <input type="text" name="fare" value="<%= rs1.getInt("fare") %>">
                <label for="train_arrival_time">Train Arrival Time:</label>
                <input type="text" name="train_arrival_time" value="<%= rs1.getTimestamp("train_arrival_time") %>">
                <label for="train_departure_time">Train Departure Time:</label>
                <input type="text" name="train_departure_time" value="<%= rs1.getTimestamp("train_departure_time") %>">
                <label for="travel_time">Travel Time:</label>
                <input type="text" name="travel_time" value="<%= rs1.getInt("travel_time") %>">
                <input type="submit" value="Update Train Schedule">
            </form>
    <%
        }
        rs1.close();
        ps1.close();

        // Retrieve stops details and join with stations table
        String stopsAtQuery = "SELECT stops_at.*, stations.name AS station_name FROM stops_at JOIN stations ON stops_at.station_id = stations.station_id WHERE stops_at.line_name = ?";
        PreparedStatement ps2 = con.prepareStatement(stopsAtQuery);
        ps2.setString(1, lineName);
        ResultSet rs2 = ps2.executeQuery();
        
        while (rs2.next()) {
    %>
            <h2>Edit Stop at Station <%= rs2.getString("station_name") %></h2>
            <form action="updateStop.jsp" method="post">
                <input type="hidden" name="line_name" value="<%= lineName %>">
                <input type="hidden" name="station_id" value="<%= rs2.getInt("station_id") %>">
                <label for="stop_arrival_time">Stop Arrival Time:</label>
                <input type="text" name="stop_arrival_time" value="<%= rs2.getTime("stop_arrival_time") %>">
                <label for="stop_departure_time">Stop Departure Time:</label>
                <input type="text" name="stop_departure_time" value="<%= rs2.getTime("stop_departure_time") %>">
                <label for="stop_number">Stop Number:</label>
                <input type="text" name="stop_number" value="<%= rs2.getInt("stop_number") %>">
                <input type="submit" value="Update Stop">
            </form>
    <%
        }
        rs2.close();
        ps2.close();
        con.close();
    %>
</body>
</html>
