<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.trains.pkg.ApplicationDB" %>
<%
    // Redirect to login if the session is not valid
    HttpSession currentsession = request.getSession(false);
    if (currentsession == null || currentsession.getAttribute("username") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    // Get the action type from the form submission
    String action = request.getParameter("action");
    String message = "";
    Connection conn = null;
    PreparedStatement stmt = null;

    try {
        ApplicationDB db = new ApplicationDB();
        conn = db.getConnection();

        if ("add".equalsIgnoreCase(action)) {
            // Add new representative
            String ssn = request.getParameter("ssn");
            String firstName = request.getParameter("first_name");
            String lastName = request.getParameter("last_name");
            String username = request.getParameter("username");
            String password = request.getParameter("password");
            int isAdmin = Integer.parseInt(request.getParameter("is_admin"));

            String addQuery = "INSERT INTO employees (ssn, first_name, last_name, username, password, is_admin) VALUES (?, ?, ?, ?, ?, ?)";
            stmt = conn.prepareStatement(addQuery);
            stmt.setInt(1, Integer.parseInt(ssn));
            stmt.setString(2, firstName);
            stmt.setString(3, lastName);
            stmt.setString(4, username);
            stmt.setString(5, password); // In production, hash passwords before storing them
            stmt.setInt(6, isAdmin);

            int rowsInserted = stmt.executeUpdate();
            message = (rowsInserted > 0) ? "Representative added successfully!" : "Failed to add representative.";

        } else if ("edit".equalsIgnoreCase(action)) {
            // Edit existing representative
            String originalSSN = request.getParameter("original_ssn");
            String ssn = request.getParameter("ssn");
            String firstName = request.getParameter("first_name");
            String lastName = request.getParameter("last_name");
            String username = request.getParameter("username");
            String password = request.getParameter("password");
            int isAdmin = Integer.parseInt(request.getParameter("is_admin"));

            String editQuery = "UPDATE employees SET ssn = ?, first_name = ?, last_name = ?, username = ?, password = ?, is_admin = ? WHERE ssn = ?";
            stmt = conn.prepareStatement(editQuery);
            stmt.setInt(1, Integer.parseInt(ssn));
            stmt.setString(2, firstName);
            stmt.setString(3, lastName);
            stmt.setString(4, username);
            stmt.setString(5, password); // In production, hash passwords before storing them
            stmt.setInt(6, isAdmin);
            stmt.setInt(7, Integer.parseInt(originalSSN));

            int rowsUpdated = stmt.executeUpdate();
            message = (rowsUpdated > 0) ? "Representative updated successfully!" : "Failed to update representative.";

        } else if ("delete".equalsIgnoreCase(action)) {
            // Delete representative
            String ssn = request.getParameter("ssn");

            String deleteQuery = "DELETE FROM employees WHERE ssn = ?";
            stmt = conn.prepareStatement(deleteQuery);
            stmt.setInt(1, Integer.parseInt(ssn));

            int rowsDeleted = stmt.executeUpdate();
            message = (rowsDeleted > 0) ? "Representative deleted successfully!" : "Failed to delete representative.";
        }
    } catch (Exception e) {
        e.printStackTrace();
        message = "Error: " + e.getMessage();
    } finally {
        if (stmt != null) try { stmt.close(); } catch (SQLException ignore) {}
        if (conn != null) try { conn.close(); } catch (SQLException ignore) {}
    }

    // Redirect back to the main page with a success or error message
    response.sendRedirect("manageRepresentative.jsp?message=" + java.net.URLEncoder.encode(message, "UTF-8"));
%>
