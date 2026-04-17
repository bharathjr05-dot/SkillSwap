<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
String studentId = request.getParameter("id");
if(studentId == null) {
    response.sendRedirect("browse.jsp");
    return;
}
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Profile - Skill Swap</title>
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
        <%
        Connection conn = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/skillswap?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC", "root", "root");

            PreparedStatement stmt = conn.prepareStatement("SELECT * FROM users WHERE id = ?");
            stmt.setString(1, studentId);
            ResultSet rs = stmt.executeQuery();

            if(rs.next()) {
        %>
        <section style="padding: 2rem 0;">
            <div class="card" style="max-width: 800px; margin: 0 auto;">

                <!-- Profile Header -->
                <div style="text-align: center; margin-bottom: 2rem;">
                    <div class="avatar" style="width: 120px; height: 120px; font-size: 3rem; margin: 0 auto 1rem;">
                        <%= rs.getString("name").substring(0,1).toUpperCase() %>
                    </div>
                    <h1 style="font-size: 2.5rem; margin-bottom: 0.5rem;"><%= rs.getString("name") %></h1>
                    <p style="color: #64748b; font-size: 1.125rem;">
                        <%= rs.getString("department") %> &bull; <%= rs.getString("year") %>
                    </p>
                    <p style="margin-top: 1rem; font-size: 1.125rem;">
                        <%= rs.getString("bio") != null ? rs.getString("bio") : "" %>
                    </p>
                    <% if(session.getAttribute("userId") != null && !session.getAttribute("userId").equals(studentId)) { %>
                    <button onclick="showSwapModal('<%= rs.getString("id") %>', '<%= rs.getString("name") %>')"
                            class="btn" style="margin-top: 1rem;">Request Skill Swap</button>
                    <% } %>
                </div>

                <!-- Skills Grid -->
                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 2rem;">
                    <div>
                        <h3 style="color: #2563eb; margin-bottom: 1rem;">Skills I Teach</h3>
                        <%
                        PreparedStatement skillsStmt = conn.prepareStatement(
                            "SELECT * FROM skills WHERE user_id = ? AND type = 'teach'");
                        skillsStmt.setString(1, studentId);
                        ResultSet skillsRs = skillsStmt.executeQuery();
                        while(skillsRs.next()) {
                        %>
                        <div style="margin-bottom: 1rem; padding: 1rem; background: #f8fafc; border-radius: 8px;">
                            <h4 style="margin-bottom: 0.5rem;"><%= skillsRs.getString("name") %></h4>
                            <p style="color: #64748b; font-size: 0.875rem;">
                                <%= skillsRs.getString("category") %> &bull; <%= skillsRs.getString("proficiency") %>
                            </p>
                            <% if(skillsRs.getString("description") != null && !skillsRs.getString("description").isEmpty()) { %>
                            <p style="margin-top: 0.5rem; font-size: 0.875rem;"><%= skillsRs.getString("description") %></p>
                            <% } %>
                        </div>
                        <% } skillsRs.close(); %>
                    </div>

                    <div>
                        <h3 style="color: #059669; margin-bottom: 1rem;">Skills I Want to Learn</h3>
                        <%
                        skillsStmt = conn.prepareStatement(
                            "SELECT * FROM skills WHERE user_id = ? AND type = 'learn'");
                        skillsStmt.setString(1, studentId);
                        skillsRs = skillsStmt.executeQuery();
                        while(skillsRs.next()) {
                        %>
                        <div style="margin-bottom: 1rem; padding: 1rem; background: #f0fdf4; border-radius: 8px;">
                            <h4 style="margin-bottom: 0.5rem;"><%= skillsRs.getString("name") %></h4>
                            <p style="color: #64748b; font-size: 0.875rem;">
                                <%= skillsRs.getString("category") %> &bull; <%= skillsRs.getString("proficiency") %>
                            </p>
                            <% if(skillsRs.getString("description") != null && !skillsRs.getString("description").isEmpty()) { %>
                            <p style="margin-top: 0.5rem; font-size: 0.875rem;"><%= skillsRs.getString("description") %></p>
                            <% } %>
                        </div>
                        <% } skillsRs.close(); %>
                    </div>
                </div>

                <!-- Reviews -->
                <div style="margin-top: 2rem; border-top: 1px solid #e2e8f0; padding-top: 1.5rem;">
                    <h3 style="font-size: 1.25rem; font-weight: 600; margin-bottom: 1rem;">Reviews</h3>
                    <%
                    PreparedStatement reviewStmt = conn.prepareStatement(
                        "SELECT r.*, u.name as reviewer_name FROM reviews r " +
                        "JOIN users u ON r.reviewer_id = u.id " +
                        "WHERE r.user_id = ? ORDER BY r.created_at DESC");
                    reviewStmt.setString(1, studentId);
                    ResultSet reviewRs = reviewStmt.executeQuery();
                    boolean hasReviews = false;
                    while(reviewRs.next()) {
                        hasReviews = true;
                        int stars = reviewRs.getInt("rating");
                    %>
                    <div style="padding: 1rem; background: #f8fafc; border-radius: 8px; margin-bottom: 0.75rem; border: 1px solid #e2e8f0;">
                        <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:0.4rem;">
                            <strong><%= reviewRs.getString("reviewer_name") %></strong>
                            <span style="color:#f59e0b; font-size:1.1rem;">
                                <% for(int i=1;i<=5;i++) out.print(i<=stars ? "&#9733;" : "&#9734;"); %>
                            </span>
                        </div>
                        <% if(reviewRs.getString("comment") != null && !reviewRs.getString("comment").isEmpty()) { %>
                        <p style="color:#475569; font-size:0.875rem;"><%= reviewRs.getString("comment") %></p>
                        <% } %>
                    </div>
                    <%
                    }
                    if(!hasReviews) out.println("<p style='color:#94a3b8;'>No reviews yet.</p>");
                    reviewRs.close();
                    %>
                </div>

            </div>
        </section>
        <%
            } else {
                out.println("<p>User not found.</p>");
            }
        } catch(Exception e) {
            out.println("Error: " + e.getMessage());
        } finally {
            if(conn != null) try { conn.close(); } catch(Exception ex) {}
        }
        %>
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
                .then(r => r.text())
                .then(data => {
                    document.querySelector('select[name="requesterSkillId"]').innerHTML =
                        '<option value="">NIL</option>' + data;
                });
            fetch('get-skills.jsp?userId=' + recipientId + '&type=teach')
                .then(r => r.text())
                .then(data => {
                    document.querySelector('select[name="recipientSkillId"]').innerHTML =
                        '<option value="">Select a skill...</option>' + data;
                });
            showModal('swapModal');
        }
    </script>
</body>
</html>
