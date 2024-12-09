<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.trains.pkg.ApplicationDB" %>
<!DOCTYPE html>
<html>
<head>
    <title>Monthly Sales Report</title>
	<link rel="stylesheet" href="loginStyle.css">
</head>
<body>
    <h1>Monthly Sales Report</h1>

    <table border="1">
        <thead>
            <tr>
                <th>Month</th>
                <th>Total Sales (USD)</th>
            </tr>
        </thead>
        <tbody>
            <%
                Connection conn = null;
                PreparedStatement stmt = null;
                ResultSet rs = null;

                try {
                    ApplicationDB db = new ApplicationDB();
                    conn = db.getConnection();

                    String query = "SELECT DATE_FORMAT(res_datetime, '%Y-%m') AS month, SUM(total_fare) AS total_sales " +
                                   "FROM reservations " +
                                   "WHERE status = 'CONFIRMED' " + 
                                   "GROUP BY DATE_FORMAT(res_datetime, '%Y-%m') " +
                                   "ORDER BY month ASC";

                    stmt = conn.prepareStatement(query);
                    rs = stmt.executeQuery();

                    while (rs.next()) {
                        String month = rs.getString("month");
                        float totalSales = rs.getFloat("total_sales");
            %>
                        <tr>
                            <td><%= month %></td>
                            <td><%= String.format("%.2f", totalSales) %></td>
                        </tr>
            <%
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    out.println("<tr><td colspan='2' style='color: red;'>Error: " + e.getMessage() + "</td></tr>");
                } finally {
                    if (rs != null) try { rs.close(); } catch (SQLException ignore) {}
                    if (stmt != null) try { stmt.close(); } catch (SQLException ignore) {}
                    if (conn != null) try { conn.close(); } catch (SQLException ignore) {}
                }
            %>
        </tbody>
    </table>
</body>
</html>
