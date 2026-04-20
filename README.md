# SkillSwap Platform

A campus skill exchange web application built with JSP and MySQL.

## Features
- Register / Login / Logout
- Add skills to teach or learn
- Browse other students
- Send, Accept, Reject swap requests
- Contact sharing (email + phone) on accepted swaps
- Leave reviews after a swap
- Analytics dashboard
- Edit profile and manage skills

## Tech Stack
- Java JSP (Apache Tomcat 10.1)
- MySQL 8.0
- HTML / CSS / JavaScript

## Setup

### 1. Database
- Create a MySQL database named `skillswap`
- Run `skillswap.sql` to create tables and insert sample data
- Default credentials: `root` / `root`

### 2. MySQL Connector
- Place `mysql-connector-j-8.0.33.jar` in `Tomcat/lib/`

### 3. Deploy
- Copy this folder into `Tomcat/webapps/skillswap/`
- Start Tomcat
- Open `http://localhost:8080/skillswap/`

## Demo Accounts
| Email | Password |
|-------|----------|
| john@example.com | password123 |
| jane@example.com | password123 |
