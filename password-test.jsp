<%@ page import="java.sql.*" %>
<%
String[] passwords = {"", "root", "password", "admin", "mysql"};
String baseUrl = "jdbc:mysql://localhost:3306/skillswap?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";

for(String pwd : passwords) {
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn = DriverManager.getConnection(baseUrl, "root", pwd);
        out.println("SUCCESS: Password is '" + pwd + "'<br>");
        conn.close();
        break;
    } catch(Exception e) {
        out.println("FAILED: Password '" + pwd + "' - " + e.getMessage() + "<br>");
    }
}
%>