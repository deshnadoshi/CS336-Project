<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.trains.pkg.ApplicationDB" %>
<!DOCTYPE html>
<html>
<head>
    <title>Customer Representative Sales Report</title>
    <link rel="stylesheet" href="loginStyle.css">
    <script>
        function showLogoutAlert() {
            alert("You have been logged out successfully.");
        }
    </script>
</head>
<body>


<div>
        <h3>Customer Representative Sales Report</h3>

        <!-- Sales Table -->
      <table>
            <thead>
                <tr>
                    <th>Month</th>
                    <th>Total Sales ($)</th>
                </tr>
            </thead>
            <tbody>
                <%
                    // Get the monthly sales data
                    ApplicationDB dbSales = new ApplicationDB();
                    Connection conSales = dbSales.getConnection();
                    String salesQuery = "SELECT EXTRACT(MONTH FROM reservation_date) AS month, " +
                                        "SUM(total_fare) AS total_sales " +
                                        "FROM reservations " +
                                        "GROUP BY EXTRACT(MONTH FROM reservation_date) " +
                                        "ORDER BY month";
                    Statement stmtSales = conSales.createStatement();
                    ResultSet rsSales = stmtSales.executeQuery(salesQuery);

                    // Display the monthly sales data
                    while (rsSales.next()) {
                        int month = rsSales.getInt("month");
                        double totalSales = rsSales.getDouble("total_sales");
                %>
                <tr>
                    <td><%= month %></td>
                    <td>$<%= totalSales %></td>
                </tr>
                <%
                    }
                    dbSales.closeConnection(conSales);
                %>
            </tbody>
        </table>
    </div>
    </body>
    </html>
