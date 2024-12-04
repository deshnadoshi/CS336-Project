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

    <h2 class="centered-message">
        Manage Customer Representatives
    </h2>

    <!-- Action Selection -->
    <form action="manageRepresentative.jsp" method="get">
        <h4>Select Action:</h4>
        <label for="action">Action:</label>
        <select name="action" id="action" required>
            <option value="add">Add Representative</option>
            <option value="edit">Edit Representative</option>
            <option value="delete">Delete Representative</option>
        </select>
        <input type="submit" value="Select Action">
    </form>

    <hr>

    <!-- Form for Adding, Editing, and Deleting Representatives -->
    <%
        String action = request.getParameter("action");
        if ("add".equals(action)) {
    %>
        <h3>Add New Representative</h3>
        <form action="manageRepresentative.jsp" method="post">
            <input type="hidden" name="action" value="add">
            <label for="rep_name">Name:</label>
            <input type="text" id="rep_name" name="rep_name" required>
            <label for="rep_email">Email:</label>
            <input type="email" id="rep_email" name="rep_email" required>
            <label for="rep_phone">Phone Number:</label>
            <input type="text" id="rep_phone" name="rep_phone" required>
            <input type="submit" value="Add Representative">
        </form>
    <%
        } else if ("edit".equals(action)) {
    %>
        <h3>Edit Representative</h3>
        <form action="manageRepresentative.jsp" method="post">
            <input type="hidden" name="action" value="edit">
            <label for="rep_id">Representative ID:</label>
            <input type="number" id="rep_id" name="rep_id" required>
            <input type="submit" value="Edit Representative">
        </form>
    <%
        } else if ("delete".equals(action)) {
    %>
        <h3>Delete Representative</h3>
        <form action="manageRepresentative.jsp" method="post">
            <input type="hidden" name="action" value="delete">
            <label for="rep_id_delete">Representative ID:</label>
            <input type="number" id="rep_id_delete" name="rep_id_delete" required>
            <input type="submit" value="Delete Representative">
        </form>
    <%
        }
    %>

    <%
        // Handling form submission for add, edit, delete actions
        String actionPost = request.getParameter("action");
        
        if ("add".equals(actionPost)) {
            String name = request.getParameter("rep_name");
            String email = request.getParameter("rep_email");
            String phone = request.getParameter("rep_phone");

            ApplicationDB db = new ApplicationDB();
            Connection con = db.getConnection();
            String insertQuery = "INSERT INTO customer_representatives (name, email, phone) VALUES (?, ?, ?)";
            PreparedStatement stmt = con.prepareStatement(insertQuery);
            stmt.setString(1, name);
            stmt.setString(2, email);
            stmt.setString(3, phone);

            int rowsAffected = stmt.executeUpdate();
            if (rowsAffected > 0) {
                out.println("<p>Representative added successfully!</p>");
            } else {
                out.println("<p>Error adding representative.</p>");
            }
            db.closeConnection(con);

        } else if ("edit".equals(actionPost)) {
            int repId = Integer.parseInt(request.getParameter("rep_id"));

            ApplicationDB db = new ApplicationDB();
            Connection con = db.getConnection();
            String selectQuery = "SELECT * FROM customer_representatives WHERE id = ?";
            PreparedStatement stmt = con.prepareStatement(selectQuery);
            stmt.setInt(1, repId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                String name = rs.getString("name");
                String email = rs.getString("email");
                String phone = rs.getString("phone");

                // Display edit form
                out.println("<h3>Edit Representative</h3>");
                out.println("<form action='manageRepresentative.jsp' method='post'>");
                out.println("<input type='hidden' name='action' value='update'>");
                out.println("<input type='hidden' name='rep_id' value='" + repId + "'>");
                out.println("<label for='edit_rep_name'>Name:</label>");
                out.println("<input type='text' id='edit_rep_name' name='rep_name' value='" + name + "' required>");
                out.println("<label for='edit_rep_email'>Email:</label>");
                out.println("<input type='email' id='edit_rep_email' name='rep_email' value='" + email + "' required>");
                out.println("<label for='edit_rep_phone'>Phone:</label>");
                out.println("<input type='text' id='edit_rep_phone' name='rep_phone' value='" + phone + "' required>");
                out.println("<input type='submit' value='Update Representative'>");
                out.println("</form>");
            } else {
                out.println("<p>Representative not found.</p>");
            }
            db.closeConnection(con);

        } else if ("delete".equals(actionPost)) {
            int repId = Integer.parseInt(request.getParameter("rep_id_delete"));

            ApplicationDB db = new ApplicationDB();
            Connection con = db.getConnection();
            String deleteQuery = "DELETE FROM customer_representatives WHERE id = ?";
            PreparedStatement stmt = con.prepareStatement(deleteQuery);
            stmt.setInt(1, repId);

            int rowsAffected = stmt.executeUpdate();
            if (rowsAffected > 0) {
                out.println("<p>Representative deleted successfully!</p>");
            } else {
                out.println("<p>Error deleting representative.</p>");
            }
            db.closeConnection(con);
        }
    %>

</body>
</html>
