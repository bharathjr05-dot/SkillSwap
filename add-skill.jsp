<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
// Check if user is logged in
if(session.getAttribute("userId") == null) {
    response.sendRedirect("login.jsp");
    return;
}

String userId = (String) session.getAttribute("userId");

// Handle form submission
if("POST".equals(request.getMethod())) {
    String name = request.getParameter("name");
    String category = request.getParameter("category");
    String proficiency = request.getParameter("proficiency");
    String type = request.getParameter("type");
    String description = request.getParameter("description");
    
    if(name != null && category != null && proficiency != null && type != null) {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/skillswap?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC", "root", "root");
            
            String sql = "INSERT INTO skills (user_id, name, category, proficiency, type, description) VALUES (?, ?, ?, ?, ?, ?)";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, userId);
            stmt.setString(2, name);
            stmt.setString(3, category);
            stmt.setString(4, proficiency);
            stmt.setString(5, type);
            stmt.setString(6, description);
            
            int result = stmt.executeUpdate();
            
            if(result > 0) {
                response.sendRedirect("dashboard.jsp?success=skill_added");
                return;
            } else {
                request.setAttribute("error", "Failed to add skill");
            }
            
            conn.close();
        } catch(Exception e) {
            request.setAttribute("error", "Database error: " + e.getMessage());
        }
    } else {
        request.setAttribute("error", "All fields are required");
    }
}
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Skill - Skill Swap</title>
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
                <li><a href="logout.jsp">Logout</a></li>
            </ul>
        </nav>
    </header>

    <main class="container" style="display: flex; justify-content: center; align-items: center; min-height: 80vh;">
        <div class="card" style="width: 100%; max-width: 500px;">
            <h1 style="text-align: center; margin-bottom: 2rem; font-size: 2rem; font-weight: 700;">Add New Skill</h1>
            
            <% if(request.getAttribute("error") != null) { %>
            <div style="background: #fef2f2; color: #dc2626; padding: 1rem; border-radius: 8px; margin-bottom: 1rem; text-align: center;">
                <%= request.getAttribute("error") %>
            </div>
            <% } %>
            
            <form method="post" onsubmit="return validateForm('skillForm')" id="skillForm">
                <div class="form-group">
                    <label class="form-label">Skill Name:</label>
                    <input type="text" name="name" class="form-input" required 
                           placeholder="e.g., JavaScript, Guitar, Spanish"
                           value="<%= request.getParameter("name") != null ? request.getParameter("name") : "" %>">
                </div>
                
                <div class="form-group">
                    <label class="form-label">Category:</label>
                    <select name="category" class="form-input" required>
                        <option value="">Select category...</option>
                        <option value="Programming" <%= "Programming".equals(request.getParameter("category")) ? "selected" : "" %>>Programming</option>
                        <option value="Design" <%= "Design".equals(request.getParameter("category")) ? "selected" : "" %>>Design</option>
                        <option value="Music" <%= "Music".equals(request.getParameter("category")) ? "selected" : "" %>>Music</option>
                        <option value="Languages" <%= "Languages".equals(request.getParameter("category")) ? "selected" : "" %>>Languages</option>
                        <option value="Sports" <%= "Sports".equals(request.getParameter("category")) ? "selected" : "" %>>Sports</option>
                        <option value="Photography" <%= "Photography".equals(request.getParameter("category")) ? "selected" : "" %>>Photography</option>
                        <option value="Writing" <%= "Writing".equals(request.getParameter("category")) ? "selected" : "" %>>Writing</option>
                        <option value="Other" <%= "Other".equals(request.getParameter("category")) ? "selected" : "" %>>Other</option>
                    </select>
                </div>
                
                <div class="form-group">
                    <label class="form-label">Proficiency Level:</label>
                    <select name="proficiency" class="form-input" required>
                        <option value="">Select level...</option>
                        <option value="Beginner" <%= "Beginner".equals(request.getParameter("proficiency")) ? "selected" : "" %>>Beginner</option>
                        <option value="Intermediate" <%= "Intermediate".equals(request.getParameter("proficiency")) ? "selected" : "" %>>Intermediate</option>
                        <option value="Expert" <%= "Expert".equals(request.getParameter("proficiency")) ? "selected" : "" %>>Expert</option>
                    </select>
                </div>
                
                <div class="form-group">
                    <label class="form-label">Type:</label>
                    <select name="type" class="form-input" required>
                        <option value="">Select type...</option>
                        <option value="teach" <%= "teach".equals(request.getParameter("type")) ? "selected" : "" %>>I can teach this skill</option>
                        <option value="learn" <%= "learn".equals(request.getParameter("type")) ? "selected" : "" %>>I want to learn this skill</option>
                    </select>
                </div>
                
                <div class="form-group">
                    <label class="form-label">Description (optional):</label>
                    <textarea name="description" class="form-input" rows="4" 
                              placeholder="Describe your experience or what you hope to learn..."><%= request.getParameter("description") != null ? request.getParameter("description") : "" %></textarea>
                </div>
                
                <div style="display: flex; gap: 1rem;">
                    <button type="submit" class="btn" style="flex: 1;">Add Skill</button>
                    <a href="dashboard.jsp" class="btn btn-secondary" style="flex: 1; text-align: center;">Cancel</a>
                </div>
            </form>
        </div>
    </main>

    <script src="js/main.js"></script>
</body>
</html>