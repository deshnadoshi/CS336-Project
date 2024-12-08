<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.trains.pkg.ApplicationDB" %>
<!DOCTYPE html>
<html>
<head>
    <title>Respond to Question</title>
    <link rel="stylesheet" href="loginStyle.css">
</head>
<body>
    <h2 class="centered-message">Respond to Customer Question</h2>
    <%
        HttpSession currentsession = request.getSession(false);
        String repUsername = (String) currentsession.getAttribute("username");
        String customerId = request.getParameter("customer_id");
        String question = request.getParameter("question");
        String answer = request.getParameter("answer");

        if (repUsername != null && customerId != null && question != null && answer != null && !answer.trim().isEmpty()) {
            try {
                ApplicationDB db = new ApplicationDB();
                Connection con = db.getConnection();
                String updateQuery = "UPDATE faq SET answer = ?, rep_username = ? WHERE customer_id = ? AND question = ?";
                PreparedStatement pstmt = con.prepareStatement(updateQuery);
                pstmt.setString(1, answer);
                pstmt.setString(2, repUsername);
                pstmt.setString(3, customerId);
                pstmt.setString(4, question);
                pstmt.executeUpdate();

                pstmt.close();
                con.close();
                out.println("<p>Answer has been submitted successfully.</p>");
            } catch (Exception e) {
                out.println("Error: " + e.getMessage());
            }
        } else {
            out.println("<p>Invalid input. Please go back and try again.</p>");
        }
    %>
</body>
</html>
