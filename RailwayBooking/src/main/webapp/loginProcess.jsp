<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.trains.pkg.ApplicationDB" %>
<%@ page import="java.io.*,java.sql.*" %>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>

<!DOCTYPE html>
<html>
<head>
    <title>Login Process</title>
    <script>
        function showAlert(message) {
            alert(message);
        }
    </script>
</head>
<body>
    <%
        String userType = request.getParameter("userType");
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        try {
            ApplicationDB db = new ApplicationDB();
            Connection con = db.getConnection();
            
            String query = "";
            
            if ("customer".equals(userType)) {
                query = "SELECT first_name, last_name FROM customers WHERE username = ? AND password = ?";
            } else if ("employee".equals(userType)) {
                query = "SELECT first_name, last_name FROM employees WHERE username = ? AND password = ?";
            }

            PreparedStatement ps = con.prepareStatement(query);
            ps.setString(1, username);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                String firstName = rs.getString("first_name");
                String lastName = rs.getString("last_name");
                response.sendRedirect("welcome.jsp?firstName=" + firstName + "&lastName=" + lastName);
            } else {
                out.println("<script>showAlert('Invalid username or password for " + userType + "');</script>");
            }

            rs.close();
            ps.close();
            con.close();
        } catch (Exception e) {
            out.println("Error: " + e.getMessage());
        }
    %>
</body>
</html>
