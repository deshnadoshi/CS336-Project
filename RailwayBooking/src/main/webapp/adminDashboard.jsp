<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import='java.text.DecimalFormat'%>
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
	    <h4>Top Stats:</h4>
	    <div class="stats-box">
	        <% 
	            ApplicationDB db = new ApplicationDB();
	            Connection con = db.getConnection();
	
	            String bestCustomerQuery = "SELECT portfolio_username, SUM(total_fare) AS total_spent " +
	                                       "FROM reservations " +
	                                       "GROUP BY portfolio_username " +
	                                       "ORDER BY total_spent DESC LIMIT 1";
	
	            Statement stmt = con.createStatement();
	            ResultSet rs = stmt.executeQuery(bestCustomerQuery);
	
	            if (rs.next()) {
	                String bestCustomer = rs.getString("portfolio_username");
	                double totalSpent = rs.getDouble("total_spent");
	        %>
	                <h4>Best Customer:</h4>
	                <p><%= bestCustomer %> (Total Spent: $<%= new DecimalFormat("#.00").format(totalSpent) %>)</p>
	        <%
	            }
	
	            String activeLinesQuery = "SELECT line_name, DATE_FORMAT(res_datetime, '%Y-%m') AS month, COUNT(*) AS reservation_count " +
	                                      "FROM reservations " +
	                                      "GROUP BY line_name, month " +
	                                      "ORDER BY month DESC, reservation_count DESC";
	
	            rs = stmt.executeQuery(activeLinesQuery);
	
	        %>
	        <h4>Most Active Transit Lines:</h4>
	        <ul>
	            <% 
	                String currentMonth = "";
	                int rank = 0;
	
	                while (rs.next()) {
	                    String lineName = rs.getString("line_name");
	                    String month = rs.getString("month");
	                    int reservationCount = rs.getInt("reservation_count");
	
	                    if (!month.equals(currentMonth)) {
	                        if (!currentMonth.isEmpty()) {
	            %>
	                            </ul>
	            <%
	                        }
	                        currentMonth = month;
	                        rank = 0;
	            %>
	                        <h5>Month: <%= month %></h5>
	                        <ul>
	            <%
	                    }
	
	                    if (rank < 5) {
	                        rank++;
	            %>
	                        <li><%= lineName %> (Reservations: <%= reservationCount %>)</li>
	            <%
	                    }
	                }
	
	                if (rank > 0) {
	            %>
	                    </ul>
	            <%
	                }
	
	                
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
                        
                        DecimalFormat df = new DecimalFormat("#.00");
                        double totalRevenue = rsByLine.getDouble("total_revenue");
                        String totalRevenueStr = df.format(totalRevenue);
                %>
                <tr>
                    <td><%= lineName %></td>
                    <td><%= reservationCount %></td>
                    <td>$<%= totalRevenueStr %></td>
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
                    ApplicationDB db3 = new ApplicationDB();
                    Connection con3 = db3.getConnection();

                    String queryByCustomer = "SELECT portfolio_username, COUNT(*) AS reservation_count, SUM(total_fare) AS total_revenue FROM reservations GROUP BY portfolio_username";
                    Statement stmt3 = con3.createStatement();  // Use a new Statement object
                    ResultSet rsByCustomer = stmt3.executeQuery(queryByCustomer);

                    while (rsByCustomer.next()) {
                        String customerName = rsByCustomer.getString("portfolio_username");
                        int customerReservationCount = rsByCustomer.getInt("reservation_count");
                        
                        DecimalFormat df = new DecimalFormat("#.00");
                        double customerRevenue = rsByCustomer.getDouble("total_revenue");
                        String customerRevenueStr = df.format(customerRevenue); 

                %>
                <tr>
                    <td><%= customerName %></td>
                    <td><%= customerReservationCount %></td>
                    <td>$<%= customerRevenueStr %></td>
                </tr>
                <% 
                    }
                    db3.closeConnection(con3);  
                %>
            </tbody>
        </table>
    </div>
    <div class="section-divider"></div> <!-- Divider -->

    <h3>Manage Customer Representatives</h3>
    <!-- Admin can manage customer representatives (Add, Edit, Delete) -->
    <a href="manageRepresentative.jsp" class="manage-button">Manage Representatives</a>
    
    <div class="section-divider"></div> <!-- Divider -->
    
    <h4>Monthly Sales Report</h4>
    <a href="representativeSalesReport.jsp" class="manage-button">View Monthly Sales Reports</a>

    <div class="section-divider"></div> <!-- Divider -->
    
    <!-- Display Reservations by Transit Line Name -->
    <div class="stats-section">
        <h3>View Reservations by Transit Line</h3>
        <form action="adminViewReservations.jsp" method="get">
            <label for="line_name">Select Transit Line:</label>
            <select name="line_name" id="line_name">
                <option value="" disabled selected>Select a transit line</option>
                <% 
                    ApplicationDB db4 = new ApplicationDB();
                    Connection con4 = db4.getConnection();

                    String transitLinesQuery = "SELECT DISTINCT line_name FROM reservations";
                    Statement stmt4 = con4.createStatement();
                    ResultSet rs4 = stmt4.executeQuery(transitLinesQuery);

                    while (rs4.next()) {
                        String lineName = rs4.getString("line_name");
                %>
                <option value="<%= lineName %>"><%= lineName %></option>
                <% 
                    }
                    db4.closeConnection(con4);
                %>
            </select>
            <input type="submit" value="View Reservations">
        </form>
    </div>
    
    <div class="section-divider"></div> <!-- Divider -->
    
    <!-- Display Reservations by Customer Name -->
    <div class="stats-section">
        <h3>View Reservations by Customer</h3>
        <form action="adminViewReservations.jsp" method="get">
            <label for="portfolio_username">Select Customer:</label>
            <select name="portfolio_username" id="portfolio_username">
                <option value="" disabled selected>Select a customer</option>
                <% 
                    ApplicationDB db5 = new ApplicationDB();
                    Connection con5 = db5.getConnection();

                    String customersQuery = "SELECT DISTINCT portfolio_username FROM reservations";
                    Statement stmt5 = con5.createStatement();
                    ResultSet rs5 = stmt5.executeQuery(customersQuery);

                    while (rs5.next()) {
                        String customerName = rs5.getString("portfolio_username");
                %>
                <option value="<%= customerName %>"><%= customerName %></option>
                <% 
                    }
                    db5.closeConnection(con5);
                %>
            </select>
            <input type="submit" value="View Reservations">
        </form>
    </div>

</body>
</html>
                    