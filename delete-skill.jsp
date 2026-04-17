<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
if(session.getAttribute("userId") == null) { response.sendRedirect("login.jsp"); return; }
String userId = (String) session.getAttribute("userId");
String skillId = request.getParameter("skillId");
if(skillId != null) {
    Connection conn = null;
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/skillswap?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC","root","root");
        PreparedStatement stmt = conn.prepareStatement(
            "DELETE FROM skills WHERE id = ? AND user_id = ?");
        stmt.setString(1, skillId);
        stmt.setString(2, userId);
        stmt.executeUpdate();
    } catch(Exception e) {}
    finally { if(conn!=null) try{conn.close();}catch(Exception e){} }
}
response.sendRedirect("dashboard.jsp");
%>
