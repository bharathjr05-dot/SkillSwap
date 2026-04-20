<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Skill Swap Platform</title>
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
                <li><a href="analytics.jsp">Analytics</a></li>
                <% if(session.getAttribute("userId") != null) { %>
                <li><a href="logout.jsp">Logout (<%= session.getAttribute("userName") %>)</a></li>
                <% } else { %>
                <li><a href="login.jsp">Login</a></li>
                <% } %>
            </ul>
        </nav>
    </header>

    <main class="container">
        <section style="text-align: center; padding: 4rem 0;">
            <h1 style="font-size: 3rem; font-weight: 700; margin-bottom: 1rem; color: #1e293b;">
                Learn From Your Peers, Share Your Skills
            </h1>
            <p style="font-size: 1.25rem; color: #64748b; margin-bottom: 2rem; max-width: 600px; margin-left: auto; margin-right: auto;">
                Connect with fellow students to exchange knowledge and build new skills together.
            </p>
            <a href="browse.jsp" class="btn" style="font-size: 1.125rem; padding: 1rem 2rem;">
                Start Learning
            </a>
        </section>

        <section style="margin-top: 4rem;">
            <h2 style="font-size: 2rem; font-weight: 600; text-align: center; margin-bottom: 2rem;">
                Featured Students
            </h2>
            
            <div class="student-grid">
                <%
                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    Connection conn = DriverManager.getConnection(
                        "jdbc:mysql://localhost:3306/skillswap?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC", "root", "root");
                    
                    String sql = "SELECT s.*, GROUP_CONCAT(sk.name) as skills " +
                                "FROM users s " +
                                "LEFT JOIN skills sk ON s.id = sk.user_id AND sk.type = 'teach' " +
                                "GROUP BY s.id LIMIT 6";
                    
                    PreparedStatement stmt = conn.prepareStatement(sql);
                    ResultSet rs = stmt.executeQuery();
                    
                    while(rs.next()) {
                        String skills = rs.getString("skills");
                        if(skills == null) skills = "";
                %>
                <div class="card student-card">
                    <div class="avatar">
                        <%= rs.getString("name").substring(0,1).toUpperCase() %>
                    </div>
                    <h3 class="student-name"><%= rs.getString("name") %></h3>
                    <p class="student-bio"><%= rs.getString("bio") != null ? rs.getString("bio") : "" %></p>
                    <div class="skills-list">
                        <% 
                        if(!skills.isEmpty()) {
                            String[] skillArray = skills.split(",");
                            for(String skill : skillArray) {
                        %>
                        <span class="skill-badge"><%= skill.trim() %></span>
                        <% 
                            }
                        }
                        %>
                    </div>
                    <div class="stars">
                        <span class="star">★</span>
                        <span class="star">★</span>
                        <span class="star">★</span>
                        <span class="star">★</span>
                        <span class="star empty">★</span>
                    </div>
                    <a href="profile.jsp?id=<%= rs.getString("id") %>" class="btn">View Profile</a>
                </div>
                <%
                    }
                    conn.close();
                } catch(Exception e) {
                    out.println("Error: " + e.getMessage());
                }
                %>
            </div>
        </section>

        <section style="margin: 4rem 0; text-align: center; background: white; padding: 3rem; border-radius: 12px;">
            <h2 style="font-size: 2rem; font-weight: 600; margin-bottom: 2rem;">How It Works</h2>
            <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 2rem;">
                <div>
                    <div style="font-size: 3rem; margin-bottom: 1rem;">🔍</div>
                    <h3 style="font-weight: 600; margin-bottom: 0.5rem;">Browse Skills</h3>
                    <p style="color: #64748b;">Find students offering skills you want to learn</p>
                </div>
                <div>
                    <div style="font-size: 3rem; margin-bottom: 1rem;">🤝</div>
                    <h3 style="font-weight: 600; margin-bottom: 0.5rem;">Connect</h3>
                    <p style="color: #64748b;">Send swap requests to exchange knowledge</p>
                </div>
                <div>
                    <div style="font-size: 3rem; margin-bottom: 1rem;">📚</div>
                    <h3 style="font-weight: 600; margin-bottom: 0.5rem;">Learn</h3>
                    <p style="color: #64748b;">Meet up and share your expertise</p>
                </div>
            </div>
        </section>
    </main>

    <script src="js/main.js"></script>
</body>
</html>