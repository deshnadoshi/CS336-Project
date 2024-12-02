<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.trains.pkg.ApplicationDB" %>
<%
    HttpSession currentsession = request.getSession(false);
    if (currentsession == null || currentsession.getAttribute("username") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String firstName = (String) currentsession.getAttribute("firstName");
    String lastName = (String) currentsession.getAttribute("lastName");

    String resNumber = request.getParameter("resNumber");

    try {
        ApplicationDB db = new ApplicationDB();
        Connection con = db.getConnection();
        String updateQuery = "UPDATE reservations SET status = 'CANCELLED' WHERE res_number = ?";
        PreparedStatement ps = con.prepareStatement(updateQuery);
        ps.setInt(1, Integer.parseInt(resNumber));
        int result = ps.executeUpdate();
        ps.close();
        con.close();
    } catch (Exception e) {
        out.println("Error: " + e.getMessage());
    }

    response.sendRedirect("welcome.jsp?firstName=" + firstName + "&lastName=" + lastName);
%>
