<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.trains.pkg.ApplicationDB" %>
<%@ page import="java.io.*,java.sql.*" %>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>

<!DOCTYPE html>
<html>
<head>
    <title>Login Process</title>
    <link rel="stylesheet" href="loginStyle.css">
    <script>
        function showAlertAndReload(message) {
            alert(message);
            window.location.href = 'login.jsp'; 
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
            
            // Determine the query based on user type
            if ("customer".equals(userType)) {
                query = "SELECT first_name, last_name FROM customers WHERE LOWER(username) = LOWER(?) AND password = ?";
            } else if ("employee".equals(userType)) {
                query = "SELECT first_name, last_name, is_admin FROM employees WHERE LOWER(username) = LOWER(?) AND password = ?";
            }

            PreparedStatement ps = con.prepareStatement(query);
            ps.setString(1, username);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                String firstName = rs.getString("first_name");
                String lastName = rs.getString("last_name");

                // If the user is an employee, check if they are an admin
                boolean isAdmin = false;
                if ("employee".equals(userType)) {
                    isAdmin = rs.getBoolean("is_admin");
                }

                // Establish a session
                HttpSession currentsession = request.getSession(true);
                currentsession.setAttribute("username", username); 
                currentsession.setAttribute("userType", userType); 
                currentsession.setAttribute("firstName", firstName); 
                currentsession.setAttribute("lastName", lastName); 

                // Redirect based on user type and admin status
                if ("customer".equals(userType)) {
                    // Redirect customer to the welcome page
                    response.sendRedirect("welcome.jsp?firstName=" + firstName + "&lastName=" + lastName);
                } else if ("employee".equals(userType)) {
                    if (isAdmin) {
                        // Redirect to admin dashboard if the employee is an admin
                        response.sendRedirect("adminDashboard.jsp?firstName=" + firstName + "&lastName=" + lastName);
                    } else {
                        // Redirect to customer representative dashboard if not an admin
                        response.sendRedirect("custRepDashboard.jsp?firstName=" + firstName + "&lastName=" + lastName);
                    }
                }
            } else {
                // Show an alert and reload if login fails
                out.println("<script>showAlertAndReload('Invalid username or password for " + userType + "');</script>");
            }

            rs.close();
            ps.close();
            con.close();
        } catch (Exception e) {
            // Show an alert if there is any error
            out.println("<script>showAlertAndReload('Error: " + e.getMessage() + "');</script>");
        }
    %>
</body>
</html>