<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.trains.pkg.ApplicationDB" %>
<!DOCTYPE html>
<html>
<head>
    <title>Admin Dashboard</title>
    <link rel="stylesheet" href="loginStyle.css">
    <script>
        function showLogoutAlert() {
            alert("You have been logged out successfully.");
        }
    </script>
    <style>
        .section-divider {
            margin: 20px 0;
            border-bottom: 2px solid #ccc;
        }
    </style>
</head>
<body>
    <div class="logout-container">
        <!-- Logout Button -->
        <form action="logout.jsp" method="post">
            <input type="submit" value="Logout" class="logout-button" onclick="showLogoutAlert();">
        </form>
    </div>

    <h2 class="centered-message">
        Welcome, <%= request.getParameter("firstName") %> <%= request.getParameter("lastName") %>!
    </h2>

    <!-- Display Best Customer and Most Active Transit Lines Section -->
    <div class="stats-section">
        <h3>Top Stats</h3>
        <div class="stats-box">
            <% 
                // Create a new instance of ApplicationDB
                ApplicationDB db = new ApplicationDB();
                Connection con = db.getConnection();

                // Query to get the best customer (the customer with most reservations)
                String bestCustomerQuery = "SELECT portfolio_username, COUNT(*) AS reservation_count " +
                                           "FROM reservations " +
                                           "GROUP BY portfolio_username " +
                                           "ORDER BY reservation_count DESC LIMIT 1";
                Statement stmt = con.createStatement();
                ResultSet rs = stmt.executeQuery(bestCustomerQuery);

                // Display Best Customer
                if (rs.next()) {
                    String bestCustomer = rs.getString("portfolio_username");
                    int reservationCount = rs.getInt("reservation_count");
            %>
                <h4>Best Customer:</h4>
                <p><%= bestCustomer %> (Reservations: <%= reservationCount %>)</p>
            <% 
                }

                // Query to get the top 5 most active transit lines
                String activeLinesQuery = "SELECT line_name, COUNT(*) AS reservation_count " +
                                          "FROM reservations " +
                                          "GROUP BY line_name " +
                                          "ORDER BY reservation_count DESC LIMIT 5";
                rs = stmt.executeQuery(activeLinesQuery);

                // Display the top 5 active lines
                if (rs.next()) {
            %>
                <h4>Most Active Transit Lines:</h4>
                <ul>
                    <% 
                        do {
                            String lineName = rs.getString("line_name");
                            int activeLineCount = rs.getInt("reservation_count");
                    %>
                            <li><%= lineName %> (Reservations: <%= activeLineCount %>)</li>
                    <% 
                        } while (rs.next());
                    %>
                </ul>
            <% 
                }
                // Close the connection
                db.closeConnection(con);
            %>
        </div>
    </div>
    <div class="section-divider"></div> <!-- Divider -->

    <!-- Reservations Section: Display Reservations by Transit Line -->
    <div class="stats-section">
        <h3>Stats by Transit Line</h3>
        <table border="1">
            <thead>
                <tr>
                    <th>Transit Line</th>
                    <th>Total Reservations</th>
                    <th>Total Revenue</th>
                </tr>
            </thead>
            <tbody>
                <% 
                    // Create a new instance of ApplicationDB
                    ApplicationDB db2 = new ApplicationDB();
                    Connection con2 = db2.getConnection();

                    // Query to get reservations and revenue by transit line
                    String queryByLine = "SELECT line_name, COUNT(*) AS reservation_count, SUM(total_fare) AS total_revenue FROM reservations GROUP BY line_name";
                    Statement stmt2 = con2.createStatement();  // Separate statement object
                    ResultSet rsByLine = stmt2.executeQuery(queryByLine);

                    // Display reservations and revenue by transit line
                    while (rsByLine.next()) {
                        String lineName = rsByLine.getString("line_name");
                        int reservationCount = rsByLine.getInt("reservation_count");
                        double totalRevenue = rsByLine.getDouble("total_revenue");
                %>
                <tr>
                    <td><%= lineName %></td>
                    <td><%= reservationCount %></td>
                    <td>$<%= totalRevenue %></td>
                </tr>
                <% 
                    }
                    db2.closeConnection(con2);  // Close connection after use
                %>
            </tbody>
        </table>
    </div>
    <div class="section-divider"></div> <!-- Divider -->

    <!-- Reservations Section: Display Reservations by Customer -->
    <div class="stats-section">
        <h3>Stats by Customer</h3>
        <table border="1">
            <thead>
                <tr>
                    <th>Customer Name</th>
                    <th>Total Reservations</th>
                    <th>Total Revenue</th>
                </tr>
            </thead>
            <tbody>
                <% 
                    // Create a new instance of ApplicationDB
                    ApplicationDB db3 = new ApplicationDB();
                    Connection con3 = db3.getConnection();

                    // Query to get reservations and revenue by customer name (portfolio_username)
                    String queryByCustomer = "SELECT portfolio_username, COUNT(*) AS reservation_count, SUM(total_fare) AS total_revenue FROM reservations GROUP BY portfolio_username";
                    Statement stmt3 = con3.createStatement();  // Use a new Statement object
                    ResultSet rsByCustomer = stmt3.executeQuery(queryByCustomer);

                    // Display reservations and revenue by customer name
                    while (rsByCustomer.next()) {
                        String customerName = rsByCustomer.getString("portfolio_username");
                        int customerReservationCount = rsByCustomer.getInt("reservation_count");
                        double customerRevenue = rsByCustomer.getDouble("total_revenue");
                %>
                <tr>
                    <td><%= customerName %></td>
                    <td><%= customerReservationCount %></td>
                    <td>$<%= customerRevenue %></td>
                </tr>
                <% 
                    }
                    db3.closeConnection(con3);  // Close connection after use
                %>
            </tbody>
        </table>
    </div>
    <div class="section-divider"></div> <!-- Divider -->

    <h3>Manage Customer Representatives</h3>
    <!-- Admin can manage customer representatives (Add, Edit, Delete) -->
    <a href="manageRepresentative.jsp" class="manage-button">Manage Representatives</a>
</body>
</html>
