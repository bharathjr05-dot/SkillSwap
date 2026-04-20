<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
// Handle registration form submission
if("POST".equals(request.getMethod())) {
    String name = request.getParameter("name");
    String email = request.getParameter("email");
    String password = request.getParameter("password");
    String bio = request.getParameter("bio");
    String department = request.getParameter("department");
    String year = request.getParameter("year");
    String phone = request.getParameter("phone");
    
    if(name != null && email != null && password != null) {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/skillswap?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC", "root", "root");
            
            String sql = "INSERT INTO users (name, email, password, bio, department, year, phone) VALUES (?, ?, ?, ?, ?, ?, ?)";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, name);
            stmt.setString(2, email);
            stmt.setString(3, password);
            stmt.setString(4, bio);
            stmt.setString(5, department);
            stmt.setString(6, year);
            stmt.setString(7, phone);
            
            int result = stmt.executeUpdate();
            
            if(result > 0) {
                response.sendRedirect("login.jsp?success=registered");
                return;
            } else {
                request.setAttribute("error", "Failed to register");
            }
            
            conn.close();
        } catch(Exception e) {
            if(e.getMessage().contains("Duplicate entry")) {
                request.setAttribute("error", "Email already exists");
            } else {
                request.setAttribute("error", "Database error: " + e.getMessage());
            }
        }
    } else {
        request.setAttribute("error", "Name, email and password are required");
    }
}
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register - Skill Swap</title>
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
        <div class="card" style="width: 100%; max-width: 500px;">
            <h1 style="text-align: center; margin-bottom: 2rem; font-size: 2rem; font-weight: 700;">Register</h1>
            
            <% if(request.getAttribute("error") != null) { %>
            <div style="background: #fef2f2; color: #dc2626; padding: 1rem; border-radius: 8px; margin-bottom: 1rem; text-align: center;">
                <%= request.getAttribute("error") %>
            </div>
            <% } %>
            
            <form method="post" onsubmit="return validateForm('registerForm')" id="registerForm">
                <div class="form-group">
                    <label class="form-label">Name:</label>
                    <input type="text" name="name" class="form-input" required 
                           value="<%= request.getParameter("name") != null ? request.getParameter("name") : "" %>">
                </div>
                
                <div class="form-group">
                    <label class="form-label">Email:</label>
                    <input type="email" name="email" class="form-input" required 
                           value="<%= request.getParameter("email") != null ? request.getParameter("email") : "" %>">
                </div>
                
                <div class="form-group">
                    <label class="form-label">Password:</label>
                    <input type="password" name="password" class="form-input" required>
                </div>
                
                <div class="form-group">
                    <label class="form-label">Department:</label>
                    <input type="text" name="department" class="form-input" 
                           value="<%= request.getParameter("department") != null ? request.getParameter("department") : "" %>">
                </div>
                
                <div class="form-group">
                    <label class="form-label">Year:</label>
                    <select name="year" class="form-input">
                        <option value="">Select year...</option>
                        <option value="Freshman" <%= "Freshman".equals(request.getParameter("year")) ? "selected" : "" %>>Freshman</option>
                        <option value="Sophomore" <%= "Sophomore".equals(request.getParameter("year")) ? "selected" : "" %>>Sophomore</option>
                        <option value="Junior" <%= "Junior".equals(request.getParameter("year")) ? "selected" : "" %>>Junior</option>
                        <option value="Senior" <%= "Senior".equals(request.getParameter("year")) ? "selected" : "" %>>Senior</option>
                    </select>
                </div>
                
                <div class="form-group">
                    <label class="form-label">Phone Number:</label>
                    <input type="tel" name="phone" class="form-input"
                           placeholder="e.g. 9876543210"
                           value="<%= request.getParameter("phone") != null ? request.getParameter("phone") : "" %>">
                </div>
                
                <div class="form-group">
                    <label class="form-label">Bio:</label>
                    <textarea name="bio" class="form-input" rows="3" 
                              placeholder="Tell us about yourself..."><%= request.getParameter("bio") != null ? request.getParameter("bio") : "" %></textarea>
                </div>
                
                <button type="submit" class="btn" style="width: 100%; margin-bottom: 1rem;">Register</button>
            </form>
            
            <div style="text-align: center;">
                <p style="color: #64748b;">Already have an account? <a href="login.jsp" style="color: #2563eb;">Login here</a></p>
            </div>
        </div>
    </main>

    <script src="js/main.js"></script>
</body>
</html>