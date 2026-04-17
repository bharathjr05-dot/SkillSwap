<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Browse Students - Skill Swap</title>
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
            <h1 style="font-size: 2.5rem; font-weight: 700; margin-bottom: 2rem;">Browse Students</h1>
            
            <div style="display: flex; gap: 1rem; margin-bottom: 2rem; flex-wrap: wrap;">
                <input type="text" id="searchInput" placeholder="Search by name or skill..." 
                       class="form-input" style="flex: 1; min-width: 250px;" onkeyup="searchStudents()">
                <select onchange="filterByCategory(this.value)" class="form-input" style="width: 200px;">
                    <option value="all">All Categories</option>
                    <option value="programming">Programming</option>
                    <option value="design">Design</option>
                    <option value="music">Music</option>
                    <option value="languages">Languages</option>
                    <option value="sports">Sports</option>
                </select>
                <select onchange="filterByDepartment(this.value)" class="form-input" style="width: 200px;">
                    <option value="all">All Departments</option>
                    <option value="computer science">Computer Science</option>
                    <option value="design">Design</option>
                    <option value="engineering">Engineering</option>
                    <option value="business">Business</option>
                </select>
                <select onchange="filterByYear(this.value)" class="form-input" style="width: 150px;">
                    <option value="all">All Years</option>
                    <option value="freshman">Freshman</option>
                    <option value="sophomore">Sophomore</option>
                    <option value="junior">Junior</option>
                    <option value="senior">Senior</option>
                </select>
            </div>

            <div class="student-grid">
                <%
                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    Connection conn = DriverManager.getConnection(
                        "jdbc:mysql://localhost:3306/skillswap?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC", "root", "root");
                    
                    String sql = "SELECT s.*, GROUP_CONCAT(sk.name) as skills, " +
                                "AVG(r.rating) as avg_rating, COUNT(r.id) as review_count " +
                                "FROM users s " +
                                "LEFT JOIN skills sk ON s.id = sk.user_id AND sk.type = 'teach' " +
                                "LEFT JOIN reviews r ON s.id = r.user_id " +
                                "GROUP BY s.id " +
                                "ORDER BY avg_rating DESC, review_count DESC";
                    
                    PreparedStatement stmt = conn.prepareStatement(sql);
                    ResultSet rs = stmt.executeQuery();
                    
                    while(rs.next()) {
                        String skills = rs.getString("skills");
                        if(skills == null) skills = "";
                        double avgRating = rs.getDouble("avg_rating");
                        int reviewCount = rs.getInt("review_count");
                %>
                <div class="card student-card">
                    <div class="avatar">
                        <%= rs.getString("name").substring(0,1).toUpperCase() %>
                    </div>
                    <h3 class="student-name"><%= rs.getString("name") %></h3>
                    <p style="color: #64748b; font-size: 0.875rem; margin-bottom: 0.5rem;">
                        <%= rs.getString("department") %> • <%= rs.getString("year") %>
                    </p>
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
                        <%
                        int fullStars = (int) Math.round(avgRating);
                        for(int i = 1; i <= 5; i++) {
                            if(i <= fullStars) {
                        %>
                        <span class="star">★</span>
                        <%
                            } else {
                        %>
                        <span class="star empty">★</span>
                        <%
                            }
                        }
                        %>
                        <span style="margin-left: 0.5rem; color: #64748b; font-size: 0.875rem;">
                            (<%= reviewCount %> reviews)
                        </span>
                    </div>
                    
                    <div style="display: flex; gap: 0.5rem; margin-top: 1rem;">
                        <a href="profile.jsp?id=<%= rs.getString("id") %>" class="btn" style="flex: 1; text-align: center;">
                            View Profile
                        </a>
                        <button onclick="showSwapModal('<%= rs.getString("id") %>', '<%= rs.getString("name") %>')" 
                                class="btn btn-secondary">Request Swap</button>
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
        </section>
    </main>

    <!-- Swap Request Modal -->
    <div id="swapModal" class="modal">
        <div class="modal-content">
            <span class="close" onclick="hideModal('swapModal')">&times;</span>
            <h2>Request Skill Swap</h2>
            <form action="swap-request.jsp" method="post" id="swapForm">
                <input type="hidden" id="recipientId" name="recipientId">
                <div class="form-group">
                    <label class="form-label">Requesting swap with: <span id="recipientName"></span></label>
                </div>
                <div class="form-group">
                    <label class="form-label">Your skill to offer:</label>
                    <select name="requesterSkillId" class="form-input">
                        <option value="">NIL</option>
                    </select>
                </div>
                <div class="form-group">
                    <label class="form-label">Skill you want to learn:</label>
                    <select name="recipientSkillId" class="form-input" required>
                        <option value="">Select a skill...</option>
                    </select>
                </div>
                <div class="form-group">
                    <label class="form-label">Message:</label>
                    <textarea name="message" class="form-input" rows="4"
                              placeholder="Tell them why you'd like to swap skills..."></textarea>
                </div>
                <button type="submit" class="btn">Send Request</button>
            </form>
        </div>
    </div>

    <script src="js/main.js"></script>
    <script>
        function showSwapModal(recipientId, recipientName) {
            document.getElementById('recipientId').value = recipientId;
            document.getElementById('recipientName').textContent = recipientName;
            fetch('get-skills.jsp?userId=<%= session.getAttribute("userId") %>&type=teach')
                .then(response => response.text())
                .then(data => {
                    document.querySelector('select[name="requesterSkillId"]').innerHTML =
                        '<option value="">NIL</option>' + data;
                });
            fetch('get-skills.jsp?userId=' + recipientId + '&type=teach')
                .then(response => response.text())
                .then(data => {
                    document.querySelector('select[name="recipientSkillId"]').innerHTML =
                        '<option value="">Select a skill...</option>' + data;
                });
            showModal('swapModal');
        }
    </script>
</body>
</html>