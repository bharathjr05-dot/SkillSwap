# SkillSwap Platform

A campus peer-to-peer skill exchange web application that connects students to teach and learn from each other. Built with Java JSP and MySQL.

Overview
SkillSwap enables students to:

Discover skills – Browse talents from peers across campus
Exchange skills – Request and manage skill swap partnerships
Build community – Leave reviews and build reputation
Track progress – View analytics on your teaching/learning activities

## Features
Core Functionality

User Management – Secure register, login, and profile management
Skill Management – Add/edit skills you teach or want to learn with proficiency levels
Skill Discovery – Browse other students' profiles and available skills by category
Swap Requests – Send, accept, reject, or mark skill swap requests
Contact Sharing – Securely share email and phone on accepted swaps
Reviews & Ratings – Leave 5-star reviews after completing swaps
Analytics Dashboard – View stats on skills offered, requests, and ratings

Additional Features

Profile customization (bio, department, year)
Skill categorization (Programming, Languages, Design, Music, Sports, etc.)
Multi-status tracking (pending, accepted, rejected, completed)
Session management with 30-minute timeout

## Tech Stack
- Java JSP (Apache Tomcat 10.1)
- MySQL 8.0
- HTML / CSS / JavaScript

## Setup

Installation
1. Database Setup
bash# Create the database and tables
mysql -u root -p < skillswap.sql
This will:

Create the skillswap database
Set up all tables (users, skills, swap_requests, reviews)
Populate with 6 sample user accounts and demo data

Note: The included SQL file stores passwords in plaintext for demo purposes. For production, implement hashing (bcrypt/SHA-256).

2. Tomcat Configuration
bash# Copy MySQL connector to Tomcat lib directory
cp mysql-connector-j-8.0.33.jar $TOMCAT_HOME/lib/

3. Deploy Application
bash# Copy project folder to Tomcat webapps
cp -r skillswap $TOMCAT_HOME/webapps/

4. Start Tomcat
bash$TOMCAT_HOME/bin/startup.sh

5. Access Application
Open your browser and navigate to:
http://localhost:8080/skillswap/

Database Schema:

Users Table
Stores user profiles with basic information and credentials.
Skills Table
Maps skills to users with proficiency levels and teaching/learning type.
Swap Requests Table
Tracks all skill exchange requests between users with status tracking.
Reviews Table
Stores ratings and feedback after completed swaps.

📁 Project Structure
skillswap/
├── index.jsp                    # Home page & landing
├── register.jsp                 # User registration
├── login.jsp                    # Login page
├── dashboard.jsp                # Main user dashboard
├── profile.jsp                  # User profile view
├── edit-profile.jsp             # Edit profile & bio
├── add-skill.jsp                # Add new skill
├── get-skills.jsp               # View all skills
├── delete-skill.jsp             # Remove skill
├── browse.jsp                   # Browse other students
├── swap-request.jsp             # Send swap request
├── swap-action.jsp              # Accept/reject requests
├── submit-review.jsp            # Leave review after swap
├── analytics.jsp                # Dashboard analytics
├── logout.jsp                   # Session termination
├── WEB-INF/
│   └── web.xml                  # Tomcat configuration
├── css/
│   └── style.css                # Application styling
├── js/
│   └── main.js                  # Client-side functionality
├── skillswap.sql                # Database schema & seed data
└── README.md                    # This file

## Demo Accounts
|      Email       |   Password  |
|------------------|-------------|
| john@example.com | password123 |
| jane@example.com | password123 |
