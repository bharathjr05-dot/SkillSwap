<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
if(session.getAttribute("userId") == null) {
    response.sendRedirect("login.jsp");
    return;
}
String userId = (String) session.getAttribute("userId");
String userName = (String) session.getAttribute("userName");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - Skill Swap</title>
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

    <main class="container">
        <section style="padding: 2rem 0;">
            <h1 style="font-size: 2.5rem; font-weight: 700; margin-bottom: 0.5rem;">
                Welcome back, <%= userName %>!
            </h1>
            <p style="color: #64748b; margin-bottom: 2rem;">Manage your skills and swap requests</p>

            <%
            // Handle phone update
            if("POST".equals(request.getMethod()) && request.getParameter("updatePhone") != null) {
                String newPhone = request.getParameter("phone");
                Connection connPhone = null;
                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    connPhone = DriverManager.getConnection(
                        "jdbc:mysql://localhost:3306/skillswap?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC", "root", "root");
                    PreparedStatement ps = connPhone.prepareStatement("UPDATE users SET phone = ? WHERE id = ?");
                    ps.setString(1, newPhone);
                    ps.setString(2, userId);
                    ps.executeUpdate();
                } catch(Exception e) {}
                finally { if(connPhone != null) try { connPhone.close(); } catch(Exception e) {} }
            }
            %>

            <%
            Connection conn = null;
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/skillswap?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC", "root", "root");

                // Stats
                String statsQuery = "SELECT " +
                    "(SELECT COUNT(*) FROM skills WHERE user_id = ? AND type = 'teach') as skills_teaching, " +
                    "(SELECT COUNT(*) FROM skills WHERE user_id = ? AND type = 'learn') as skills_learning, " +
                    "(SELECT COUNT(*) FROM swap_requests WHERE recipient_id = ? AND status = 'pending') as pending_requests, " +
                    "(SELECT AVG(rating) FROM reviews WHERE user_id = ?) as avg_rating, " +
                    "(SELECT phone FROM users WHERE id = ?) as my_phone";
                PreparedStatement statsStmt = conn.prepareStatement(statsQuery);
                statsStmt.setString(1, userId);
                statsStmt.setString(2, userId);
                statsStmt.setString(3, userId);
                statsStmt.setString(4, userId);
                statsStmt.setString(5, userId);
                ResultSet statsRs = statsStmt.executeQuery();
                int skillsTeaching = 0, skillsLearning = 0, pendingRequests = 0;
                double avgRating = 0;
                String myPhone = "";
                if(statsRs.next()) {
                    skillsTeaching = statsRs.getInt("skills_teaching");
                    skillsLearning = statsRs.getInt("skills_learning");
                    pendingRequests = statsRs.getInt("pending_requests");
                    avgRating = statsRs.getDouble("avg_rating");
                    myPhone = statsRs.getString("my_phone") != null ? statsRs.getString("my_phone") : "";
                }
                statsRs.close();
            %>

            <!-- Stats Cards -->
            <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 1.5rem; margin-bottom: 3rem;">
                <div class="card" style="text-align: center;">
                    <h3 style="font-size: 2rem; color: #2563eb; margin-bottom: 0.5rem;"><%= skillsTeaching %></h3>
                    <p style="color: #64748b;">Skills Teaching</p>
                </div>
                <div class="card" style="text-align: center;">
                    <h3 style="font-size: 2rem; color: #059669; margin-bottom: 0.5rem;"><%= skillsLearning %></h3>
                    <p style="color: #64748b;">Skills Learning</p>
                </div>
                <div class="card" style="text-align: center;">
                    <h3 style="font-size: 2rem; color: #dc2626; margin-bottom: 0.5rem;"><%= pendingRequests %></h3>
                    <p style="color: #64748b;">Pending Requests</p>
                </div>
                <div class="card" style="text-align: center;">
                    <h3 style="font-size: 2rem; color: #7c3aed; margin-bottom: 0.5rem;"><%= String.format("%.1f", avgRating) %></h3>
                    <p style="color: #64748b;">Average Rating</p>
                </div>
            </div>

            <!-- Phone Update Card -->
            <div class="card" style="margin-bottom: 2rem; background: #f0f9ff; border: 1px solid #bae6fd;">
                <h3 style="font-size: 1.1rem; font-weight: 600; margin-bottom: 0.75rem; color: #0c4a6e;">📞 Contact Number</h3>
                <p style="color: #64748b; font-size: 0.9rem; margin-bottom: 0.75rem;">
                    Your phone will be shared with users when you accept their swap requests.
                </p>
                <form method="post" style="display:flex; gap:0.5rem; align-items:end;">
                    <div style="flex:1;">
                        <input type="tel" name="phone" class="form-input" placeholder="Enter phone number"
                               value="<%= myPhone %>" style="margin:0;">
                    </div>
                    <button type="submit" name="updatePhone" value="true" class="btn" style="white-space:nowrap;">Update Phone</button>
                </form>
            </div>

            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 2rem;">
                <!-- My Skills -->
                <div class="card">
                    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 1.5rem;">
                        <h2 style="font-size: 1.5rem; font-weight: 600;">My Skills</h2>
                        <button onclick="showModal('addSkillModal')" class="btn">Add Skill</button>
                    </div>
                    <%
                    PreparedStatement skillsStmt = conn.prepareStatement("SELECT * FROM skills WHERE user_id = ? ORDER BY type, name");
                    skillsStmt.setString(1, userId);
                    ResultSet skillsRs = skillsStmt.executeQuery();
                    String currentType = "";
                    while(skillsRs.next()) {
                        String type = skillsRs.getString("type");
                        if(!type.equals(currentType)) {
                            if(!currentType.isEmpty()) out.println("</div>");
                            out.println("<h3 style='margin: 1rem 0 0.5rem 0; color: #374151; text-transform: capitalize;'>" + type + "ing:</h3>");
                            out.println("<div style='display: flex; flex-wrap: wrap; gap: 0.5rem;'>");
                            currentType = type;
                        }
                        String badgeStyle = type.equals("teach") ? "background: #dbeafe; color: #1e40af;" : "background: #dcfce7; color: #166534;";
                        out.println("<span class='skill-badge' style='" + badgeStyle + "'>" + skillsRs.getString("name") + " (" + skillsRs.getString("proficiency") + ")</span>");
                    }
                    if(!currentType.isEmpty()) out.println("</div>");
                    skillsRs.close();
                    %>
                </div>

                <!-- Incoming Swap Requests -->
                <div class="card">
                    <h2 style="font-size: 1.5rem; font-weight: 600; margin-bottom: 1.5rem;">Incoming Requests</h2>
                    <%
                    PreparedStatement requestsStmt = conn.prepareStatement(
                        "SELECT sr.*, s.name as requester_name, s.email as requester_email, " +
                        "sk1.name as requester_skill, sk2.name as recipient_skill " +
                        "FROM swap_requests sr " +
                        "JOIN users s ON sr.requester_id = s.id " +
                        "LEFT JOIN skills sk1 ON sr.requester_skill_id = sk1.id " +
                        "LEFT JOIN skills sk2 ON sr.recipient_skill_id = sk2.id " +
                        "WHERE sr.recipient_id = ? ORDER BY sr.created_at DESC LIMIT 10");
                    requestsStmt.setString(1, userId);
                    ResultSet requestsRs = requestsStmt.executeQuery();
                    boolean hasRequests = false;
                    while(requestsRs.next()) {
                        hasRequests = true;
                        String status = requestsRs.getString("status");
                        String statusColor = status.equals("pending") ? "#f59e0b" : status.equals("accepted") ? "#10b981" : "#ef4444";
                        String reqId = requestsRs.getString("id");
                    %>
                    <div style="border-left: 4px solid <%= statusColor %>; padding: 0.75rem 1rem; margin-bottom: 1rem; background: #f8fafc; border-radius: 8px;">
                        <div style="display: flex; justify-content: space-between; align-items: start; margin-bottom: 0.5rem;">
                            <div>
                                <h4 style="font-weight: 600; margin-bottom: 0.25rem;"><%= requestsRs.getString("requester_name") %></h4>
                                <p style="color: #64748b; font-size: 0.8rem;">Offers: <strong><%= requestsRs.getString("requester_skill") %></strong></p>
                                <p style="color: #64748b; font-size: 0.8rem;">Wants to learn: <strong><%= requestsRs.getString("recipient_skill") %></strong></p>
                                <% if(status.equals("accepted")) { %>
                                <p style="color: #059669; font-size: 0.8rem; margin-top: 0.25rem;">📧 Contact: <%= requestsRs.getString("requester_email") %></p>
                                <% } %>
                            </div>
                            <span style="background: <%= statusColor %>; color: white; padding: 0.25rem 0.5rem; border-radius: 4px; font-size: 0.75rem; text-transform: capitalize; white-space: nowrap;">
                                <%= status %>
                            </span>
                        </div>
                        <% if(status.equals("pending")) { %>
                        <div style="display: flex; gap: 0.5rem; margin-top: 0.5rem;">
                            <form action="swap-action.jsp" method="post" style="margin:0;">
                                <input type="hidden" name="requestId" value="<%= reqId %>">
                                <input type="hidden" name="action" value="accepted">
                                <button type="submit" style="background:#10b981; color:white; border:none; padding:0.4rem 1rem; border-radius:6px; cursor:pointer; font-size:0.85rem;">✓ Accept</button>
                            </form>
                            <form action="swap-action.jsp" method="post" style="margin:0;">
                                <input type="hidden" name="requestId" value="<%= reqId %>">
                                <input type="hidden" name="action" value="rejected">
                                <button type="submit" style="background:#ef4444; color:white; border:none; padding:0.4rem 1rem; border-radius:6px; cursor:pointer; font-size:0.85rem;">✗ Reject</button>
                            </form>
                        </div>
                        <% } %>
                    </div>
                    <%
                    }
                    if(!hasRequests) out.println("<p style='color:#94a3b8;'>No incoming requests yet.</p>");
                    requestsRs.close();
                    %>
                </div>
            </div>

            <!-- Exchange History -->
            <div class="card" style="margin-top: 2rem;">
                <h2 style="font-size: 1.5rem; font-weight: 600; margin-bottom: 1.5rem;">My Exchange History</h2>
                <%
                PreparedStatement historyStmt = conn.prepareStatement(
                    "SELECT sr.*, " +
                    "s1.name as requester_name, s1.email as requester_email, s1.phone as requester_phone, " +
                    "s2.name as recipient_name, s2.email as recipient_email, s2.phone as recipient_phone, " +
                    "sk1.name as requester_skill, sk2.name as recipient_skill " +
                    "FROM swap_requests sr " +
                    "JOIN users s1 ON sr.requester_id = s1.id " +
                    "JOIN users s2 ON sr.recipient_id = s2.id " +
                    "LEFT JOIN skills sk1 ON sr.requester_skill_id = sk1.id " +
                    "LEFT JOIN skills sk2 ON sr.recipient_skill_id = sk2.id " +
                    "WHERE sr.requester_id = ? OR sr.recipient_id = ? " +
                    "ORDER BY sr.created_at DESC LIMIT 10");
                historyStmt.setString(1, userId);
                historyStmt.setString(2, userId);
                ResultSet historyRs = historyStmt.executeQuery();
                while(historyRs.next()) {
                    String status = historyRs.getString("status");
                    String statusColor = status.equals("pending") ? "#f59e0b" :
                                       status.equals("accepted") ? "#10b981" :
                                       status.equals("completed") ? "#2563eb" : "#ef4444";
                    boolean isRequester = userId.equals(String.valueOf(historyRs.getInt("requester_id")));
                    String otherName  = isRequester ? historyRs.getString("recipient_name")  : historyRs.getString("requester_name");
                    String otherEmail = isRequester ? historyRs.getString("recipient_email") : historyRs.getString("requester_email");
                    String otherPhone = isRequester ? historyRs.getString("recipient_phone") : historyRs.getString("requester_phone");
                    String otherId    = isRequester ? String.valueOf(historyRs.getInt("recipient_id")) : String.valueOf(historyRs.getInt("requester_id"));
                    String swapId     = historyRs.getString("id");
                    // Check if current user already reviewed this swap
                    PreparedStatement reviewCheck = conn.prepareStatement(
                        "SELECT id FROM reviews WHERE swap_request_id = ? AND reviewer_id = ?");
                    reviewCheck.setString(1, swapId);
                    reviewCheck.setString(2, userId);
                    ResultSet reviewRs = reviewCheck.executeQuery();
                    boolean alreadyReviewed = reviewRs.next();
                    reviewRs.close(); reviewCheck.close();
                %>
                <div style="border-left: 4px solid <%= statusColor %>; padding: 1rem; margin-bottom: 1rem; background: #f8fafc; border-radius: 8px;">
                    <div style="display: flex; justify-content: space-between; align-items: start;">
                        <div style="flex:1;">
                            <h4 style="margin-bottom: 0.5rem;"><%= isRequester ? "To: " : "From: " %><%= otherName %></h4>
                            <p style="color: #64748b; font-size: 0.875rem; margin-bottom: 0.25rem;">Offered: <%= historyRs.getString("requester_skill") %></p>
                            <p style="color: #64748b; font-size: 0.875rem;">Wanted: <%= historyRs.getString("recipient_skill") %></p>
                            <% if(status.equals("accepted") || status.equals("completed")) { %>
                            <div style="margin-top: 0.75rem; padding: 0.75rem; background: #ecfdf5; border-radius: 8px; border: 1px solid #6ee7b7;">
                                <p style="font-weight: 600; color: #065f46; font-size: 0.85rem; margin-bottom: 0.4rem;">📬 Contact Details</p>
                                <p style="color: #047857; font-size: 0.85rem;">📧 <%= otherEmail %></p>
                                <% if(otherPhone != null && !otherPhone.isEmpty()) { %>
                                <p style="color: #047857; font-size: 0.85rem;">📞 <%= otherPhone %></p>
                                <% } %>
                            </div>
                            <% if(!alreadyReviewed) { %>
                            <button onclick="showReviewModal('<%= swapId %>','<%= otherId %>','<%= otherName %>')" 
                                style="margin-top:0.75rem; background:#2563eb; color:white; border:none; padding:0.4rem 1rem; border-radius:6px; cursor:pointer; font-size:0.85rem;">⭐ Leave Review</button>
                            <% } else { %>
                            <span style="display:inline-block; margin-top:0.75rem; color:#94a3b8; font-size:0.8rem;">✓ Review submitted</span>
                            <% } %>
                            <% } %>
                        </div>
                        <span style="background: <%= statusColor %>; color: white; padding: 0.25rem 0.75rem; border-radius: 20px; font-size: 0.75rem; text-transform: capitalize; white-space:nowrap; margin-left:1rem;">
                            <%= status %>
                        </span>
                    </div>
                </div>
                <%
                }
                historyRs.close();

            } catch(Exception e) {
                out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>");
            } finally {
                if(conn != null) try { conn.close(); } catch(Exception e) {}
            }
            %>
            </div>
        </section>
    </main>

    <!-- Add Skill Modal -->
    <div id="addSkillModal" class="modal">
        <div class="modal-content">
            <span class="close" onclick="hideModal('addSkillModal')">&times;</span>
            <h2>Add New Skill</h2>
            <form action="add-skill.jsp" method="post" onsubmit="return validateForm('skillForm')" id="skillForm">
                <div class="form-group">
                    <label class="form-label">Skill Name:</label>
                    <input type="text" name="name" class="form-input" required>
                </div>
                <div class="form-group">
                    <label class="form-label">Category:</label>
                    <select name="category" class="form-input" required>
                        <option value="">Select category...</option>
                        <option value="Programming">Programming</option>
                        <option value="Design">Design</option>
                        <option value="Music">Music</option>
                        <option value="Languages">Languages</option>
                        <option value="Sports">Sports</option>
                        <option value="Other">Other</option>
                    </select>
                </div>
                <div class="form-group">
                    <label class="form-label">Proficiency:</label>
                    <select name="proficiency" class="form-input" required>
                        <option value="">Select level...</option>
                        <option value="Beginner">Beginner</option>
                        <option value="Intermediate">Intermediate</option>
                        <option value="Expert">Expert</option>
                    </select>
                </div>
                <div class="form-group">
                    <label class="form-label">Type:</label>
                    <select name="type" class="form-input" required>
                        <option value="">Select type...</option>
                        <option value="teach">I can teach this</option>
                        <option value="learn">I want to learn this</option>
                    </select>
                </div>
                <div class="form-group">
                    <label class="form-label">Description:</label>
                    <textarea name="description" class="form-input" rows="3"></textarea>
                </div>
                <button type="submit" class="btn">Add Skill</button>
            </form>
        </div>
    </div>

    <!-- Review Modal -->
    <div id="reviewModal" class="modal">
        <div class="modal-content">
            <span class="close" onclick="hideModal('reviewModal')">&times;</span>
            <h2>Leave a Review</h2>
            <p style="color:#64748b; margin-bottom:1rem;">Reviewing: <strong><span id="reviewTargetName"></span></strong></p>
            <form action="submit-review.jsp" method="post">
                <input type="hidden" name="swapId" id="reviewSwapId">
                <input type="hidden" name="targetUserId" id="reviewTargetUserId">
                <div class="form-group">
                    <label class="form-label">Rating:</label>
                    <div style="display:flex; gap:0.5rem; font-size:2rem; cursor:pointer;" id="starRating">
                        <span onclick="setRating(1)" data-val="1">☆</span>
                        <span onclick="setRating(2)" data-val="2">☆</span>
                        <span onclick="setRating(3)" data-val="3">☆</span>
                        <span onclick="setRating(4)" data-val="4">☆</span>
                        <span onclick="setRating(5)" data-val="5">☆</span>
                    </div>
                    <input type="hidden" name="rating" id="ratingValue" required>
                </div>
                <div class="form-group">
                    <label class="form-label">Comment:</label>
                    <textarea name="comment" class="form-input" rows="3" placeholder="Share your experience..."></textarea>
                </div>
                <button type="submit" class="btn" onclick="return document.getElementById('ratingValue').value != ''">Submit Review</button>
            </form>
        </div>
    </div>

    <script src="js/main.js"></script>
    <script>
        function showReviewModal(swapId, targetUserId, targetName) {
            document.getElementById('reviewSwapId').value = swapId;
            document.getElementById('reviewTargetUserId').value = targetUserId;
            document.getElementById('reviewTargetName').textContent = targetName;
            document.getElementById('ratingValue').value = '';
            document.querySelectorAll('#starRating span').forEach(s => s.textContent = '☆');
            showModal('reviewModal');
        }
        function setRating(val) {
            document.getElementById('ratingValue').value = val;
            document.querySelectorAll('#starRating span').forEach(s => {
                s.textContent = parseInt(s.dataset.val) <= val ? '★' : '☆';
            });
        }
    </script>
</body>
</html>
