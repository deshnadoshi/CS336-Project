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
                
                String updateReservationsQuery = "UPDATE reservations SET status = 'CANCELLED' WHERE line_name = ?";
                PreparedStatement ps1 = con.prepareStatement(updateReservationsQuery);
                ps1.setString(1, lineName);
                ps1.executeUpdate();
                ps1.close();
                
                String updateTrainSchedulesQuery = "UPDATE trainschedules SET is_operational = 0 WHERE line_name = ?";
                PreparedStatement ps2 = con.prepareStatement(updateTrainSchedulesQuery);
                ps2.setString(1, lineName);
                ps2.executeUpdate();
                ps2.close();
                
                con.close();
                out.println("<p>Successfully updated train schedule for line: " + lineName + " to non-operational and updated corresponding reservations to CANCELED.</p>");
            } catch (Exception e) {
                out.println("Error: " + e.getMessage());
            }
        } else if ("Edit".equals(action)) {
            response.sendRedirect("editTrainSchedule.jsp?line_name=" + lineName);
        }
    %>
</body>
</html>
