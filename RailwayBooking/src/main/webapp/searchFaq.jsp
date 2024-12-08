<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.trains.pkg.ApplicationDB" %>
<!DOCTYPE html>
<html>
<head>
    <title>Search FAQ</title>
    <link rel="stylesheet" href="loginStyle.css">
</head>
<body>
    <h2 class="centered-message">Search Results</h2>
    <%
        String keyword = request.getParameter("keyword");
        if (keyword != null && !keyword.isEmpty()) {
            try {
                ApplicationDB db = new ApplicationDB();
                Connection con = db.getConnection();
                String searchQuery = "SELECT question, answer FROM faq WHERE question LIKE ?";
                PreparedStatement searchStmt = con.prepareStatement(searchQuery);
                searchStmt.setString(1, "%" + keyword + "%");
                ResultSet searchRs = searchStmt.executeQuery();
                
                while (searchRs.next()) {
                    String question = searchRs.getString("question");
                    String answer = searchRs.getString("answer");
    %>
                    <div class="faq">
                        <p><strong>Question:</strong> <%= question %></p>
                        <p><strong>Answer:</strong> <%= answer %></p>
                    </div>
                    <hr> <!-- Divider between each FAQ -->
    <%
                }
                searchRs.close();
                searchStmt.close();
                con.close();
            } catch (Exception e) {
                out.println("Error: " + e.getMessage());
            }
        } else {
            out.println("<p>No keyword provided for search.</p>");
        }
    %>
</body>
</html>
