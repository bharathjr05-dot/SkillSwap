<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
// Handle login form submission
if("POST".equals(request.getMethod())) {
    String email = request.getParameter("email");
    String password = request.getParameter("password");
    
    if(email != null && password != null) {
        try {
            Connection conn = util.DBUtil.getConnection();
            
            String sql = "SELECT * FROM users WHERE email = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, email);
            
            ResultSet rs = stmt.executeQuery();
            
            if(rs.next() && util.PasswordUtil.verify(password, rs.getString("password"))) {
                if(!util.PasswordUtil.isHashed(rs.getString("password"))) {
                    PreparedStatement updatePassword = conn.prepareStatement("UPDATE users SET password = ? WHERE id = ?");
                    updatePassword.setString(1, util.PasswordUtil.hash(password));
                    updatePassword.setInt(2, rs.getInt("id"));
                    updatePassword.executeUpdate();
                    updatePassword.close();
                }
                session.setAttribute("userId", rs.getString("id"));
                session.setAttribute("userName", rs.getString("name"));
                response.sendRedirect("dashboard.jsp");
                return;
            } else {
                request.setAttribute("error", "Invalid email or password");
            }
            
            conn.close();
        } catch(Exception e) {
            request.setAttribute("error", "Database error: " + e.getMessage());
        }
    }
}
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Skill Swap</title>
    <link rel="stylesheet" href="css/style.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
</head>
<body>
    <header class="header">
        <nav class="nav container">
            <div class="logo">SkillSwap</div>
            <ul class="nav-links">
                <li><a href="index.jsp">Home</a></li>
                <li><a href="browse.jsp">Browse</a></li>
                <li><a href="dashboard.jsp">Dashboard</a></li>
                <li><a href="login.jsp">Login</a></li>
            </ul>
        </nav>
    </header>

    <main class="container" style="display: flex; justify-content: center; align-items: center; min-height: 80vh;">
        <div class="card" style="width: 100%; max-width: 400px;">
            <h1 style="text-align: center; margin-bottom: 2rem; font-size: 2rem; font-weight: 700;">Login</h1>
            
            <% if(request.getAttribute("error") != null) { %>
            <div style="background: #fef2f2; color: #dc2626; padding: 1rem; border-radius: 8px; margin-bottom: 1rem; text-align: center;">
                <%= request.getAttribute("error") %>
            </div>
            <% } %>
            
            <form method="post" onsubmit="return validateForm('loginForm')" id="loginForm">
                <div class="form-group">
                    <label class="form-label">Email:</label>
                    <input type="email" name="email" class="form-input" required 
                           value="<%= request.getParameter("email") != null ? request.getParameter("email") : "" %>">
                </div>
                
                <div class="form-group">
                    <label class="form-label">Password:</label>
                    <input type="password" name="password" class="form-input" required>
                </div>
                
                <button type="submit" class="btn" style="width: 100%; margin-bottom: 1rem;">Login</button>
            </form>
            
            <div style="text-align: center;">
                <p style="color: #64748b;">Don't have an account? <a href="register.jsp" style="color: #2563eb;">Register here</a></p>
            </div>
            
        </div>
    </main>

    <script src="js/main.js"></script>
</body>
</html>
