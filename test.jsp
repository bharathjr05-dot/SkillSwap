<%@ page import="java.sql.*" %>
<%
try {
    Class.forName("com.mysql.cj.jdbc.Driver");
    out.println("Driver loaded successfully<br>");
    
    Connection conn = DriverManager.getConnection(
        "jdbc:mysql://localhost:3306/skillswap?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC", 
        "root", "");
    
    out.println("Connection successful!<br>");
    
    Statement stmt = conn.createStatement();
    ResultSet rs = stmt.executeQuery("SELECT COUNT(*) as count FROM students");
    
    if(rs.next()) {
        out.println("Students count: " + rs.getInt("count"));
    }
    
    conn.close();
} catch(Exception e) {
    out.println("Error: " + e.getMessage() + "<br>");
    e.printStackTrace(new java.io.PrintWriter(out));
}
%>