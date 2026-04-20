<%@ page import="java.sql.*" %>
<%
try {
    Class.forName("com.mysql.cj.jdbc.Driver");
    out.println("Driver loaded successfully<br>");
    
    // Method 1: URL with user parameter
    try {
        Connection conn = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/skillswap?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC&user=root");
        out.println("Method 1 SUCCESS: URL with user parameter<br>");
        conn.close();
    } catch(Exception e1) {
        out.println("Method 1 FAILED: " + e1.getMessage() + "<br>");
    }
    
    // Method 2: No password parameter
    try {
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/skillswap", "root", "");
        out.println("Method 2 SUCCESS: Empty string password<br>");
        conn.close();
    } catch(Exception e2) {
        out.println("Method 2 FAILED: " + e2.getMessage() + "<br>");
    }
    
    // Method 3: Null password
    try {
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/skillswap", "root", null);
        out.println("Method 3 SUCCESS: Null password<br>");
        conn.close();
    } catch(Exception e3) {
        out.println("Method 3 FAILED: " + e3.getMessage() + "<br>");
    }
    
    // Method 4: Properties
    try {
        java.util.Properties props = new java.util.Properties();
        props.setProperty("user", "root");
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/skillswap?useSSL=false", props);
        out.println("Method 4 SUCCESS: Properties without password<br>");
        conn.close();
    } catch(Exception e4) {
        out.println("Method 4 FAILED: " + e4.getMessage() + "<br>");
    }
    
} catch(Exception e) {
    out.println("Driver Error: " + e.getMessage() + "<br>");
}
%>