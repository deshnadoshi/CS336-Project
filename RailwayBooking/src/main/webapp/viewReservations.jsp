<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.trains.pkg.ApplicationDB" %>
<!DOCTYPE html>
<html>
<head>
    <title>View Reservations</title>
    <link rel="stylesheet" href="loginStyle.css">
</head>
<body>
    <%
        String lineName = request.getParameter("line_name");
        Date reservationDate = Date.valueOf(request.getParameter("reservation_date"));

        try {
            ApplicationDB db = new ApplicationDB();
            Connection con = db.getConnection();
            String query = "SELECT portfolio_username, res_number, res_origin_station_id, res_destination_station_id, total_fare " +
                           "FROM reservations " +
                           "WHERE line_name = ? AND DATE(res_datetime) = ?";
            PreparedStatement ps = con.prepareStatement(query);
            ps.setString(1, lineName);
            ps.setDate(2, reservationDate);
            ResultSet rs = ps.executeQuery();
    %>
            <h2>Customers with Reservations on Line <%= lineName %> for <%= reservationDate %></h2>
            <ul>
    <%
            while (rs.next()) {
                int resNumber = rs.getInt("res_number");
                int originStationId = rs.getInt("res_origin_station_id");
                int destinationStationId = rs.getInt("res_destination_station_id");
                float totalFare = rs.getFloat("total_fare");
                String customerUsername = rs.getString("portfolio_username"); 
    %>
                <li>
                    <strong>Reservation Number:</strong> <%= resNumber %><br>
                    <strong>Customer:</strong> <%= customerUsername %><br>
                    <strong>Origin Station ID:</strong> <%= originStationId %><br>
                    <strong>Destination Station ID:</strong> <%= destinationStationId %><br>
                    <strong>Total Fare:</strong> $<%= totalFare %><br>
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
