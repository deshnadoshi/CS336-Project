<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.trains.pkg.ApplicationDB" %>
<!DOCTYPE html>
<html>
<head>
    <title>Manage Train Schedules</title>
    <link rel="stylesheet" href="loginStyle.css">
</head>
<body>
    <%
        String lineName = request.getParameter("line_name");
        String action = request.getParameter("action");

        if ("Delete".equals(action)) {
            try {
                ApplicationDB db = new ApplicationDB();
                Connection con = db.getConnection();
                
                // Update reservations status to CANCELED
                String updateReservationsQuery = "UPDATE reservations SET status = 'CANCELED' WHERE line_name = ?";
                PreparedStatement ps1 = con.prepareStatement(updateReservationsQuery);
                ps1.setString(1, lineName);
                ps1.executeUpdate();
                ps1.close();
                
                // Delete from stops_at
                String deleteStopsAtQuery = "DELETE FROM stops_at WHERE line_name = ?";
                PreparedStatement ps2 = con.prepareStatement(deleteStopsAtQuery);
                ps2.setString(1, lineName);
                ps2.executeUpdate();
                ps2.close();
                
                // Delete from trainschedules
                String deleteTrainSchedulesQuery = "DELETE FROM trainschedules WHERE line_name = ?";
                PreparedStatement ps3 = con.prepareStatement(deleteTrainSchedulesQuery);
                ps3.setString(1, lineName);
                ps3.executeUpdate();
                ps3.close();
                
                con.close();
                out.println("<p>Successfully deleted train schedule for line: " + lineName + " and updated corresponding reservations to CANCELED.</p>");
            } catch (Exception e) {
                out.println("Error: " + e.getMessage());
            }
        } else if ("Edit".equals(action)) {
            // Redirect to a page for editing
            response.sendRedirect("editTrainSchedule.jsp?line_name=" + lineName);
        }
    %>
</body>
</html>
