<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
String userId = request.getParameter("userId");
String type = request.getParameter("type");

if(userId != null) {
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/skillswap?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC", "root", "root");
        
        String sql = "SELECT id, name FROM skills WHERE user_id = ?";
        if(type != null) {
            sql += " AND type = ?";
        }
        
        PreparedStatement stmt = conn.prepareStatement(sql);
        stmt.setString(1, userId);
        if(type != null) {
            stmt.setString(2, type);
        }
        
        ResultSet rs = stmt.executeQuery();
        
        while(rs.next()) {
            out.println("<option value=\"" + rs.getString("id") + "\">" + rs.getString("name") + "</option>");
        }
        
        conn.close();
    } catch(Exception e) {
        out.println("<!-- Error: " + e.getMessage() + " -->");
    }
}
%>