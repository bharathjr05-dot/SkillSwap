<%@ page import="java.sql.*" %>
<%
try {
    Class.forName("com.mysql.cj.jdbc.Driver");
    out.println("Driver loaded successfully<br>");
    
    // Try connection without password parameter
    Connection conn = DriverManager.getConnection(
        "jdbc:mysql://localhost:3306/skillswap?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC&user=root");
    
    out.println("Connection successful!<br>");
    
    Statement stmt = conn.createStatement();
    ResultSet rs = stmt.executeQuery("SELECT COUNT(*) as count FROM students");
    
    if(rs.next()) {
        out.println("Students count: " + rs.getInt("count"));
    }
    
    conn.close();
} catch(Exception e) {
    out.println("Error: " + e.getMessage() + "<br>");
    
    // Try alternative connection
    try {
        Connection conn2 = DriverManager.getConnection("jdbc:mysql://localhost:3306/skillswap", "root", null);
        out.println("Alternative connection successful!<br>");
        conn2.close();
    } catch(Exception e2) {
        out.println("Alternative failed: " + e2.getMessage() + "<br>");
    }
}
%>