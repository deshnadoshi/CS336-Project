<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ page import="com.trains.pkg.ApplicationDB" %>
<!DOCTYPE html>
<html>
<head>
    <title>Display Reservations</title>
    <link rel="stylesheet" href="loginStyle.css">
</head>
<body>
    <h2 class="centered-message">Reservations</h2>
    <table border="1">
        <thead>
            <tr>
                <th>Reservation Number</th>
                <th>Date</th>
                <th>Total Fare</th>
                <th>Round Trip</th>
                <th>Discount Type</th>
                <th>Origin Station</th>
                <th>Destination Station</th>
                <th>Line Name</th>
                <th>Customer Username</th>
                <th>Status</th>
            </tr>
        </thead>
        <tbody>
            <% 
                String lineName = request.getParameter("line_name");
                String customerName = request.getParameter("portfolio_username");

                Connection con = null;
                Statement stmt = null;
                ResultSet rs = null;

                try {
                    ApplicationDB db = new ApplicationDB();
                    con = db.getConnection();
                    String query = "SELECT * FROM reservations";

                    if (lineName != null && !lineName.isEmpty()) {
                        query += " WHERE line_name = '" + lineName + "'";
                    } else if (customerName != null && !customerName.isEmpty()) {
                        query += " WHERE portfolio_username = '" + customerName + "'";
                    }

                    stmt = con.createStatement();
                    rs = stmt.executeQuery(query);

                    while (rs.next()) {
                        int resNumber = rs.getInt("res_number");
                        Date resDatetime = rs.getDate("res_datetime");
                        float totalFare = rs.getFloat("total_fare");
                        boolean isRoundtrip = rs.getBoolean("is_roundtrip");
                        String discountType = rs.getString("discount_type");
                        int originStationId = rs.getInt("res_origin_station_id");
                        int destinationStationId = rs.getInt("res_destination_station_id");
                        String line = rs.getString("line_name");
                        String portfolioUsername = rs.getString("portfolio_username");
                        String status = rs.getString("status");

                        DecimalFormat df = new DecimalFormat("#.00");
                        String totalFareStr = df.format(totalFare);
            %>
            <tr>
                <td><%= resNumber %></td>
                <td><%= resDatetime %></td>
                <td>$<%= totalFareStr %></td>
                <td><%= isRoundtrip ? "Yes" : "No" %></td>
                <td><%= discountType %></td>
                <td><%= originStationId %></td>
                <td><%= destinationStationId %></td>
                <td><%= line %></td>
                <td><%= portfolioUsername %></td>
                <td><%= status %></td>
            </tr>
            <% 
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                } finally {
                    if (rs != null) rs.close();
                    if (stmt != null) stmt.close();
                    if (con != null) con.close();
                }
            %>
        </tbody>
    </table>
</body>
</html>
