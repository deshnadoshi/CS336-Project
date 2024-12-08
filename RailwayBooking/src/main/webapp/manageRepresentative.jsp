<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.trains.pkg.ApplicationDB" %>
<!DOCTYPE html>
<html>
<head>
    <title>Manage Customer Representative</title>
    <link rel="stylesheet" href="loginStyle.css">
    <script>
        function showLogoutAlert() {
            alert("You have been logged out successfully.");
        }
    </script>
</head>
<body>
    <div class="logout-container">
        <!-- Logout Button -->
        <form action="logout.jsp" method="post">
            <input type="submit" value="Logout" class="logout-button" onclick="showLogoutAlert();">
        </form>
    </div>

    <h2 class="centered-message">Manage Customer Representatives</h2>

    <!-- Action Selection -->
    <form action="manageRepresentative.jsp" method="get">
        <h4>Please choose what you would like to do below.</h4>

        <label for="action">Action:</label>
        <select name="action" id="action" required>
            <option value="add">Add Representative</option>
            <option value="edit">Edit Representative</option>
            <option value="delete">Delete Representative</option>
        </select>

        <label for="representative">Customer Representative:</label>
        <select name="representative" id="representative">
            <option value="">-- Select a Representative --</option>
            <%
                Connection conn = null;
                PreparedStatement stmt = null;
                ResultSet rs = null;

                try {
                    ApplicationDB db = new ApplicationDB(); // Create an instance of ApplicationDB
                    conn = db.getConnection(); // Use the instance to get the connection
                    String query = "SELECT ssn, first_name, last_name FROM employees WHERE is_admin = 0";
                    stmt = conn.prepareStatement(query);
                    rs = stmt.executeQuery();

                    while (rs.next()) {
                        int ssn = rs.getInt("ssn");
                        String fullName = rs.getString("first_name") + " " + rs.getString("last_name");
                        out.println("<option value='" + ssn + "'>" + fullName + "</option>");
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                } finally {
                    if (rs != null) try { rs.close(); } catch (SQLException ignore) {}
                    if (stmt != null) try { stmt.close(); } catch (SQLException ignore) {}
                    if (conn != null) try { conn.close(); } catch (SQLException ignore) {}
                }
            %>
        </select>

        <input type="submit" value="Select Action">
    </form>

    <!-- Form for Adding, Editing, and Deleting Representatives -->
    <%
        String action = request.getParameter("action");
        String representativeSSN = request.getParameter("representative");

        if ("add".equalsIgnoreCase(action)) {
    %>
        <h3>Add New Representative</h3>
        <form action="processManageRepresentative.jsp" method="post">
            <input type="hidden" name="action" value="add">
            <label for="ssn">SSN:</label><input type="text" name="ssn" required><br>
            <label for="first_name">First Name:</label><input type="text" name="first_name" required><br>
            <label for="last_name">Last Name:</label><input type="text" name="last_name" required><br>
            <label for="username">Username:</label><input type="text" name="username" required><br>
            <label for="password">Password:</label><input type="password" name="password" required><br>
            <input type="hidden" name="is_admin" value="0">
            <input type="submit" value="Add Representative">
        </form>
    <%
        } else if ("edit".equalsIgnoreCase(action) && representativeSSN != null && !representativeSSN.isEmpty()) {
            try {
                ApplicationDB db = new ApplicationDB(); // Create an instance of ApplicationDB
                conn = db.getConnection(); // Use the instance to get the connection
                String query = "SELECT * FROM employees WHERE ssn = ?";
                stmt = conn.prepareStatement(query);
                stmt.setInt(1, Integer.parseInt(representativeSSN));
                rs = stmt.executeQuery();

                if (rs.next()) {
    %>
        <h3>Edit Representative</h3>
        <form action="processManageRepresentative.jsp" method="post">
            <input type="hidden" name="action" value="edit">
            <input type="hidden" name="original_ssn" value="<%= rs.getInt("ssn") %>">
            <label for="ssn">SSN:</label><input type="text" name="ssn" value="<%= rs.getInt("ssn") %>" required><br>
            <label for="first_name">First Name:</label><input type="text" name="first_name" value="<%= rs.getString("first_name") %>" required><br>
            <label for="last_name">Last Name:</label><input type="text" name="last_name" value="<%= rs.getString("last_name") %>" required><br>
            <label for="username">Username:</label><input type="text" name="username" value="<%= rs.getString("username") %>" required><br>
            <label for="password">Password:</label><input type="password" name="password" value="<%= rs.getString("password") %>" required><br>
            <input type="hidden" name="is_admin" value="0">
            <input type="submit" value="Update Representative">
        </form>
    <%
                }
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                if (rs != null) try { rs.close(); } catch (SQLException ignore) {}
                if (stmt != null) try { stmt.close(); } catch (SQLException ignore) {}
                if (conn != null) try { conn.close(); } catch (SQLException ignore) {}
            }
        } else if ("delete".equalsIgnoreCase(action) && representativeSSN != null && !representativeSSN.isEmpty()) {
    %>
        <h3>Delete Representative</h3>
        <form action="processManageRepresentative.jsp" method="post">
            <input type="hidden" name="action" value="delete">
            <input type="hidden" name="ssn" value="<%= representativeSSN %>">
            <p>Are you sure you want to delete this representative?</p>
            <input type="submit" value="Delete Representative">
        </form>
    <%
        }
    %>
    <%
	    String message = request.getParameter("message");
	    if (message != null) {
	        out.println("<p style='color: white;'>" + message + "</p>");
	    }
	%>
</body>
</html>
