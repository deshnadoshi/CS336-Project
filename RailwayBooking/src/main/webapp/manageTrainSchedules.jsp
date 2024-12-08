<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
                String deleteStopsAtQuery = "DELETE FROM stops_at WHERE line_name = ?";
                String deleteTrainSchedulesQuery = "DELETE FROM trainschedules WHERE line_name = ?";
                
                PreparedStatement ps1 = con.prepareStatement(deleteStopsAtQuery);
                ps1.setString(1, lineName);
                ps1.executeUpdate();
                ps1.close();
                
                PreparedStatement ps2 = con.prepareStatement(deleteTrainSchedulesQuery);
                ps2.setString(1, lineName);
                ps2.executeUpdate();
                ps2.close();
                
                con.close();
                out.println("<p>Successfully deleted train schedule for line: " + lineName + "</p>");
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
