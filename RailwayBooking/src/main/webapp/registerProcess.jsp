<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.trains.pkg.ApplicationDB" %>
<%@ page import="java.io.*,java.sql.*" %>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>

<!DOCTYPE html>
<html>
<head>
    <title>Registration Process</title>
    <script>
        function showAlertAndRedirect(message) {
            alert(message);
            window.location.href = 'login.jsp'; 
        }
    </script>
</head>
<body>
    <%
        String firstName = request.getParameter("first_name");
        String lastName = request.getParameter("last_name");
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String email = request.getParameter("email");

        if (firstName.length() > 20 || lastName.length() > 20 || username.length() > 10 || password.length() > 16 || email.length() > 50) {
            out.println("<script>showAlertAndRedirect('Error: Input exceeds allowed length.');</script>");
        } else {
            try {
                ApplicationDB db = new ApplicationDB();
                Connection con = db.getConnection();

                String checkUsernameQuery = "SELECT * FROM customers WHERE username = ?";
                PreparedStatement checkUsernameStmt = con.prepareStatement(checkUsernameQuery);
                checkUsernameStmt.setString(1, username);
                ResultSet rsUsername = checkUsernameStmt.executeQuery();

                String checkEmailQuery = "SELECT * FROM customers WHERE email = ?";
                PreparedStatement checkEmailStmt = con.prepareStatement(checkEmailQuery);
                checkEmailStmt.setString(1, email);
                ResultSet rsEmail = checkEmailStmt.executeQuery();

                if (rsUsername.next()) {
                    out.println("<script>showAlertAndRedirect('Error: Username already exists.');</script>");
                } else if (rsEmail.next()) {
                    out.println("<script>showAlertAndRedirect('Error: Email already exists.');</script>");
                } else {
                    String insertQuery = "INSERT INTO customers (first_name, last_name, username, password, email) VALUES (?, ?, ?, ?, ?)";
                    PreparedStatement ps = con.prepareStatement(insertQuery);
                    ps.setString(1, firstName);
                    ps.setString(2, lastName);
                    ps.setString(3, username);
                    ps.setString(4, password);
                    ps.setString(5, email);

                    int result = ps.executeUpdate();

                    if (result > 0) {
                        response.sendRedirect("welcome.jsp?firstName=" + firstName + "&lastName=" + lastName);
                    } else {
                        out.println("<script>showAlertAndRedirect('Error: Registration failed.');</script>");
                    }

                    ps.close();
                }

                rsUsername.close();
                rsEmail.close();
                checkUsernameStmt.close();
                checkEmailStmt.close();
                con.close();
            } catch (SQLException e) {
                out.println("<script>showAlertAndRedirect('Error: " + e.getMessage() + "');</script>");
            }
        }
    %>
</body>
</html>
