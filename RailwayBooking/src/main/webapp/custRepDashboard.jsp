<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="com.trains.pkg.ApplicationDB" %>
<!DOCTYPE html>
<html>
<head>
    <title>Customer Representative Dashboard</title>
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
        Welcome, <%= request.getParameter("firstName") %> <%= request.getParameter("lastName") %>!
    </h2>

    <h3>Assist Customers</h3>
    <!-- Customer representative can search and manage reservations for customers -->
    <a href="searchCustomerReservations.jsp" class="assist-button">Search Customer Reservations</a>

    <h3>View Customer Feedback</h3>
    <!-- Customer representative can view feedback -->
    <a href="viewCustomerFeedback.jsp" class="assist-button">View Customer Feedback</a>

    <h3>Reservation Cancellation</h3>
    <!-- Customer representative can cancel customer reservations -->
    <a href="cancelCustomerReservation.jsp" class="assist-button">Cancel Reservation</a>
    
    <h3>Frequently Asked Questions</h3>
    <form action="custRepDashboard.jsp" method="GET">
        <label for="keyword">Search Questions:</label>
        <input type="text" id="keyword" name="keyword">
        <button type="submit">Search</button>
    </form>

    <%
    String keyword = request.getParameter("keyword");
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = new ApplicationDB().getConnection();

        String query = (keyword != null && !keyword.isEmpty())
                       ? "SELECT Question, Answer FROM FAQs WHERE Question LIKE ?"
                       : "SELECT Question, Answer FROM FAQs";

        ps = conn.prepareStatement(query);
        if (keyword != null && !keyword.isEmpty()) {
            ps.setString(1, "%" + keyword + "%");
        }
        rs = ps.executeQuery();

        while (rs.next()) {
            out.println("<div class='faq-item'>");
            out.println("<h3>" + rs.getString("Question") + "</h3>");
            out.println("<p>" + rs.getString("Answer") + "</p>");
            out.println("</div>");
        }
    } catch (Exception e) {
        e.printStackTrace();
        out.println("<p>Error loading FAQs: " + e.getMessage() + "</p>");
    } finally {
        if (rs != null) try { rs.close(); } catch (SQLException ignore) {}
        if (ps != null) try { ps.close(); } catch (SQLException ignore) {}
        if (conn != null) try { conn.close(); } catch (SQLException ignore) {}
    }
    %>

    <h3>Respond to Customer Questions</h3>
    <%
    try {
        conn = new ApplicationDB().getConnection();

        String pendingQuery = "SELECT QueryID, CustomerID, Question FROM CustomerQueries WHERE Status = 'Pending'";
        ps = conn.prepareStatement(pendingQuery);
        rs = ps.executeQuery();

        while (rs.next()) {
            out.println("<div class='query-item'>");
            out.println("<p>Customer ID: " + rs.getString("CustomerID") + "</p>");
            out.println("<p>Question: " + rs.getString("Question") + "</p>");
            out.println("<form action='processReply.jsp' method='POST'>");
            out.println("<input type='hidden' name='queryId' value='" + rs.getString("QueryID") + "'>");
            out.println("<textarea name='reply' required></textarea>");
            out.println("<button type='submit'>Reply</button>");
            out.println("</form>");
            out.println("</div><hr>");
        }
    } catch (Exception e) {
        e.printStackTrace();
        out.println("<p>Error loading customer questions: " + e.getMessage() + "</p>");
    } finally {
        if (rs != null) try { rs.close(); } catch (SQLException ignore) {}
        if (ps != null) try { ps.close(); } catch (SQLException ignore) {}
        if (conn != null) try { conn.close(); } catch (SQLException ignore) {}
    }
    %>
</body>
</html>
