<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Analytics - Skill Swap</title>
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
        <section style="padding: 2rem 0;">
            <h1 style="font-size: 2.5rem; font-weight: 700; margin-bottom: 2rem;">Community Analytics</h1>

            <!-- Community Stats -->
            <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 1.5rem; margin-bottom: 3rem;">
                <%
                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    Connection conn = DriverManager.getConnection(
                        "jdbc:mysql://localhost:3306/skillswap?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC", "root", "root");
                    
                    // Get community stats
                    String statsQuery = "SELECT " +
                        "(SELECT COUNT(*) FROM users) as total_users, " +
                        "(SELECT COUNT(*) FROM skills WHERE type = 'teach') as skills_offered, " +
                        "(SELECT COUNT(*) FROM skills WHERE type = 'learn') as skills_wanted, " +
                        "(SELECT COUNT(*) FROM swap_requests) as total_requests, " +
                        "(SELECT COUNT(*) FROM swap_requests WHERE status = 'completed') as completed_swaps, " +
                        "(SELECT AVG(rating) FROM reviews) as avg_rating";
                    
                    PreparedStatement statsStmt = conn.prepareStatement(statsQuery);
                    ResultSet statsRs = statsStmt.executeQuery();
                    
                    if(statsRs.next()) {
                %>
                <div class="card" style="text-align: center;">
                    <h3 style="font-size: 2rem; color: #2563eb; margin-bottom: 0.5rem;">
                        <%= statsRs.getInt("total_users") %>
                    </h3>
                    <p style="color: #64748b;">Total Users</p>
                </div>
                <div class="card" style="text-align: center;">
                    <h3 style="font-size: 2rem; color: #059669; margin-bottom: 0.5rem;">
                        <%= statsRs.getInt("skills_offered") %>
                    </h3>
                    <p style="color: #64748b;">Skills Offered</p>
                </div>
                <div class="card" style="text-align: center;">
                    <h3 style="font-size: 2rem; color: #dc2626; margin-bottom: 0.5rem;">
                        <%= statsRs.getInt("skills_wanted") %>
                    </h3>
                    <p style="color: #64748b;">Skills Wanted</p>
                </div>
                <div class="card" style="text-align: center;">
                    <h3 style="font-size: 2rem; color: #7c3aed; margin-bottom: 0.5rem;">
                        <%= statsRs.getInt("completed_swaps") %>
                    </h3>
                    <p style="color: #64748b;">Completed Swaps</p>
                </div>
                <div class="card" style="text-align: center;">
                    <h3 style="font-size: 2rem; color: #f59e0b; margin-bottom: 0.5rem;">
                        <%= String.format("%.1f", statsRs.getDouble("avg_rating")) %>
                    </h3>
                    <p style="color: #64748b;">Avg Rating</p>
                </div>
                <%
                    }
                %>
            </div>

            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 2rem;">
                <!-- Popular Skills -->
                <div class="card">
                    <h2 style="font-size: 1.5rem; font-weight: 600; margin-bottom: 1.5rem;">Most Popular Skills</h2>
                    <%
                    String popularQuery = "SELECT name, category, COUNT(*) as demand FROM skills WHERE type = 'learn' GROUP BY name, category ORDER BY demand DESC LIMIT 5";
                    PreparedStatement popularStmt = conn.prepareStatement(popularQuery);
                    ResultSet popularRs = popularStmt.executeQuery();
                    
                    while(popularRs.next()) {
                    %>
                    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 1rem; padding: 0.75rem; background: #f8fafc; border-radius: 8px;">
                        <div>
                            <h4 style="margin-bottom: 0.25rem;"><%= popularRs.getString("name") %></h4>
                            <p style="color: #64748b; font-size: 0.875rem;"><%= popularRs.getString("category") %></p>
                        </div>
                        <span style="background: #2563eb; color: white; padding: 0.25rem 0.75rem; border-radius: 20px; font-size: 0.875rem;">
                            <%= popularRs.getInt("demand") %> requests
                        </span>
                    </div>
                    <%
                    }
                    %>
                </div>

                <!-- Department Distribution -->
                <div class="card">
                    <h2 style="font-size: 1.5rem; font-weight: 600; margin-bottom: 1.5rem;">Users by Department</h2>
                    <%
                    String deptQuery = "SELECT department, COUNT(*) as count FROM users WHERE department IS NOT NULL GROUP BY department ORDER BY count DESC";
                    PreparedStatement deptStmt = conn.prepareStatement(deptQuery);
                    ResultSet deptRs = deptStmt.executeQuery();
                    
                    while(deptRs.next()) {
                        int count = deptRs.getInt("count");
                        int percentage = (int)((count * 100.0) / statsRs.getInt("total_users"));
                    %>
                    <div style="margin-bottom: 1rem;">
                        <div style="display: flex; justify-content: space-between; margin-bottom: 0.25rem;">
                            <span><%= deptRs.getString("department") %></span>
                            <span><%= count %> users</span>
                        </div>
                        <div style="background: #e2e8f0; height: 8px; border-radius: 4px;">
                            <div style="background: #2563eb; height: 100%; width: <%= percentage %>%; border-radius: 4px;"></div>
                        </div>
                    </div>
                    <%
                    }
                    conn.close();
                } catch(Exception e) {
                    out.println("Error: " + e.getMessage());
                }
                %>
                </div>
            </div>
        </section>
    </main>

    <script src="js/main.js"></script>
</body>
</html>