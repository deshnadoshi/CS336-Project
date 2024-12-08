<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.trains.pkg.ApplicationDB" %>
<!DOCTYPE html>
<html>
<head>
    <title>Send Question</title>
    <link rel="stylesheet" href="loginStyle.css">
</head>
<body>
    <h2 class="centered-message">Submit a Question</h2>
    <%
        HttpSession currentsession = request.getSession(false);
        String username = (String) currentsession.getAttribute("username");
        String question = request.getParameter("question");

        if (username != null && question != null && !question.trim().isEmpty()) {
            try {
                ApplicationDB db = new ApplicationDB();
                Connection con = db.getConnection();
                String insertQuery = "INSERT INTO faq (customer_id, question) VALUES (?, ?)";
                PreparedStatement insertStmt = con.prepareStatement(insertQuery);
                insertStmt.setString(1, username);
                insertStmt.setString(2, question);
                insertStmt.executeUpdate();

                insertStmt.close();
                con.close();
                out.println("<p>Your question has been submitted successfully. A customer representative will answer it shortly.</p>");
            } catch (Exception e) {
                out.println("Error: " + e.getMessage());
            }
        } else {
            out.println("<p>Please enter a valid question.</p>");
        }
    %>
</body>
</html>
