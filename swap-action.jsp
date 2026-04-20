<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
if(session.getAttribute("userId") == null) {
    response.sendRedirect("login.jsp");
    return;
}

String userId = (String) session.getAttribute("userId");
String requestId = request.getParameter("requestId");
String action = request.getParameter("action");

if(requestId != null && (action.equals("accepted") || action.equals("rejected"))) {
    Connection conn = null;
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/skillswap?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC", "root", "root");

        // Only allow the recipient to accept/reject
        PreparedStatement stmt = conn.prepareStatement(
            "UPDATE swap_requests SET status = ? WHERE id = ? AND recipient_id = ? AND status = 'pending'");
        stmt.setString(1, action);
        stmt.setString(2, requestId);
        stmt.setString(3, userId);
        stmt.executeUpdate();
    } catch(Exception e) {
        // silently fail, redirect back anyway
    } finally {
        if(conn != null) try { conn.close(); } catch(Exception e) {}
    }
}

response.sendRedirect("dashboard.jsp");
%>
