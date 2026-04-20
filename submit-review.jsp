<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
if(session.getAttribute("userId") == null) {
    response.sendRedirect("login.jsp");
    return;
}
String reviewerId = (String) session.getAttribute("userId");
String swapId      = request.getParameter("swapId");
String targetUserId = request.getParameter("targetUserId");
String ratingStr   = request.getParameter("rating");
String comment     = request.getParameter("comment");

if(swapId != null && targetUserId != null && ratingStr != null) {
    int rating = Integer.parseInt(ratingStr);
    if(rating >= 1 && rating <= 5) {
        Connection conn = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/skillswap?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC", "root", "root");

            // Verify the reviewer is part of this swap and it is accepted/completed
            PreparedStatement check = conn.prepareStatement(
                "SELECT id FROM swap_requests WHERE id = ? AND status IN ('accepted','completed') " +
                "AND (requester_id = ? OR recipient_id = ?)");
            check.setString(1, swapId);
            check.setString(2, reviewerId);
            check.setString(3, reviewerId);
            ResultSet checkRs = check.executeQuery();

            if(checkRs.next()) {
                // Prevent duplicate review
                PreparedStatement dup = conn.prepareStatement(
                    "SELECT id FROM reviews WHERE swap_request_id = ? AND reviewer_id = ?");
                dup.setString(1, swapId);
                dup.setString(2, reviewerId);
                ResultSet dupRs = dup.executeQuery();
                if(!dupRs.next()) {
                    PreparedStatement ins = conn.prepareStatement(
                        "INSERT INTO reviews (user_id, reviewer_id, swap_request_id, rating, comment) VALUES (?,?,?,?,?)");
                    ins.setString(1, targetUserId);
                    ins.setString(2, reviewerId);
                    ins.setString(3, swapId);
                    ins.setInt(4, rating);
                    ins.setString(5, comment);
                    ins.executeUpdate();

                    // Mark swap as completed once both sides reviewed
                    PreparedStatement bothReviewed = conn.prepareStatement(
                        "SELECT COUNT(*) as cnt FROM reviews WHERE swap_request_id = ?");
                    bothReviewed.setString(1, swapId);
                    ResultSet brRs = bothReviewed.executeQuery();
                    if(brRs.next() && brRs.getInt("cnt") >= 2) {
                        PreparedStatement complete = conn.prepareStatement(
                            "UPDATE swap_requests SET status='completed' WHERE id=?");
                        complete.setString(1, swapId);
                        complete.executeUpdate();
                    }
                }
                dupRs.close();
            }
            checkRs.close();
        } catch(Exception e) {
            // silently redirect
        } finally {
            if(conn != null) try { conn.close(); } catch(Exception e) {}
        }
    }
}
response.sendRedirect("dashboard.jsp");
%>
