<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
if(session.getAttribute("userId") == null) {
    response.sendRedirect("login.jsp");
    return;
}

String userId           = (String) session.getAttribute("userId");
String recipientId      = request.getParameter("recipientId");
String requesterSkillId = request.getParameter("requesterSkillId");
String recipientSkillId = request.getParameter("recipientSkillId");
String message          = request.getParameter("message");

if(recipientId != null && recipientSkillId != null && !recipientSkillId.isEmpty()) {
    Connection conn = null;
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/skillswap?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC", "root", "root");

        PreparedStatement stmt = conn.prepareStatement(
            "INSERT INTO swap_requests (requester_id, recipient_id, requester_skill_id, recipient_skill_id, message) VALUES (?, ?, ?, ?, ?)");
        stmt.setString(1, userId);
        stmt.setString(2, recipientId);
        // NULL if NIL selected
        if(requesterSkillId == null || requesterSkillId.isEmpty()) {
            stmt.setNull(3, java.sql.Types.INTEGER);
        } else {
            stmt.setString(3, requesterSkillId);
        }
        stmt.setString(4, recipientSkillId);
        stmt.setString(5, message);
        stmt.executeUpdate();

    } catch(Exception e) {
        // silently redirect
    } finally {
        if(conn != null) try { conn.close(); } catch(Exception e) {}
    }
}

response.sendRedirect("dashboard.jsp");
%>
