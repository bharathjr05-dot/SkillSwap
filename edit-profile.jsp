<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
if(session.getAttribute("userId") == null) { response.sendRedirect("login.jsp"); return; }
String userId = (String) session.getAttribute("userId");
if("POST".equals(request.getMethod())) {
    String name = request.getParameter("name");
    String bio = request.getParameter("bio");
    String department = request.getParameter("department");
    String year = request.getParameter("year");
    Connection conn = null;
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/skillswap?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC","root","root");
        PreparedStatement stmt = conn.prepareStatement(
            "UPDATE users SET name=?, bio=?, department=?, year=? WHERE id=?");
        stmt.setString(1, name);
        stmt.setString(2, bio);
        stmt.setString(3, department);
        stmt.setString(4, year);
        stmt.setString(5, userId);
        stmt.executeUpdate();
        session.setAttribute("userName", name);
    } catch(Exception e) {}
    finally { if(conn!=null) try{conn.close();}catch(Exception e){} }
}
response.sendRedirect("dashboard.jsp");
%>
