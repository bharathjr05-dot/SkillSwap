-- SkillSwap Database Setup
-- Run this in MySQL: mysql -u root -p < skillswap.sql

CREATE DATABASE IF NOT EXISTS skillswap;
USE skillswap;

-- Users table
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    bio TEXT,
    department VARCHAR(100),
    year VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Skills table
CREATE TABLE IF NOT EXISTS skills (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    name VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL,
    proficiency VARCHAR(20) NOT NULL,
    type ENUM('teach', 'learn') NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Swap requests table
CREATE TABLE IF NOT EXISTS swap_requests (
    id INT AUTO_INCREMENT PRIMARY KEY,
    requester_id INT NOT NULL,
    recipient_id INT NOT NULL,
    requester_skill_id INT,
    recipient_skill_id INT,
    message TEXT,
    status ENUM('pending', 'accepted', 'rejected', 'completed') DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (requester_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (recipient_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (requester_skill_id) REFERENCES skills(id) ON DELETE SET NULL,
    FOREIGN KEY (recipient_skill_id) REFERENCES skills(id) ON DELETE SET NULL
);

-- Reviews table
CREATE TABLE IF NOT EXISTS reviews (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    reviewer_id INT NOT NULL,
    swap_request_id INT,
    rating INT NOT NULL CHECK (rating BETWEEN 1 AND 5),
    comment TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (reviewer_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (swap_request_id) REFERENCES swap_requests(id) ON DELETE SET NULL
);

-- Sample users (password is stored as plain text to match existing login logic)
INSERT INTO users (name, email, password, bio, department, year) VALUES
('John Doe',    'john@example.com', 'password123', 'Passionate about programming and music. Love sharing knowledge!', 'Computer Science', 'Junior'),
('Jane Smith',  'jane@example.com', 'password123', 'Designer and language enthusiast. Always eager to learn new things.', 'Design', 'Senior'),
('Alex Johnson','alex@example.com', 'password123', 'Engineering student who loves sports and photography.', 'Engineering', 'Sophomore'),
('Maria Garcia','maria@example.com','password123', 'Business student with a passion for languages and writing.', 'Business', 'Freshman'),
('Chris Lee',   'chris@example.com','password123', 'Full-stack developer interested in music and design.', 'Computer Science', 'Senior'),
('Sara Wilson', 'sara@example.com', 'password123', 'Graphic designer who wants to learn programming.', 'Design', 'Junior');

-- Sample skills
INSERT INTO skills (user_id, name, category, proficiency, type, description) VALUES
-- John Doe
(1, 'JavaScript', 'Programming', 'Expert',       'teach', 'Full-stack JS including React and Node.js'),
(1, 'Python',     'Programming', 'Intermediate', 'teach', 'Data analysis and scripting'),
(1, 'Guitar',     'Music',       'Beginner',     'learn', 'Want to learn acoustic guitar basics'),
(1, 'Spanish',    'Languages',   'Beginner',     'learn', 'Looking to improve conversational Spanish'),

-- Jane Smith
(2, 'UI/UX Design','Design',     'Expert',       'teach', 'Figma, Adobe XD, user research'),
(2, 'Spanish',    'Languages',   'Expert',       'teach', 'Native speaker, can teach all levels'),
(2, 'Python',     'Programming', 'Beginner',     'learn', 'Want to learn Python for data viz'),
(2, 'Photography','Photography', 'Intermediate', 'learn', 'Interested in portrait photography'),

-- Alex Johnson
(3, 'Photography','Photography', 'Expert',       'teach', 'DSLR, lighting, post-processing in Lightroom'),
(3, 'Soccer',     'Sports',      'Expert',       'teach', 'Played competitively for 10 years'),
(3, 'JavaScript', 'Programming', 'Beginner',     'learn', 'Want to build web apps'),
(3, 'UI/UX Design','Design',     'Beginner',     'learn', 'Interested in product design'),

-- Maria Garcia
(4, 'French',     'Languages',   'Expert',       'teach', 'Fluent French speaker, lived in Paris'),
(4, 'Writing',    'Writing',     'Intermediate', 'teach', 'Creative writing and academic essays'),
(4, 'Guitar',     'Music',       'Intermediate', 'learn', 'Want to advance beyond basics'),
(4, 'Photography','Photography', 'Beginner',     'learn', 'Complete beginner, want to learn fundamentals'),

-- Chris Lee
(5, 'React',      'Programming', 'Expert',       'teach', 'React, Redux, hooks, and testing'),
(5, 'Node.js',    'Programming', 'Expert',       'teach', 'REST APIs, Express, MongoDB'),
(5, 'Piano',      'Music',       'Intermediate', 'teach', 'Classical and jazz piano'),
(5, 'French',     'Languages',   'Beginner',     'learn', 'Want to learn French for travel'),

-- Sara Wilson
(6, 'Graphic Design','Design',   'Expert',       'teach', 'Illustrator, Photoshop, brand identity'),
(6, 'Illustration','Design',     'Intermediate', 'teach', 'Digital illustration and character design'),
(6, 'React',      'Programming', 'Beginner',     'learn', 'Want to build my own portfolio site'),
(6, 'Node.js',    'Programming', 'Beginner',     'learn', 'Interested in backend development');

-- Sample swap requests
INSERT INTO swap_requests (requester_id, recipient_id, requester_skill_id, recipient_skill_id, message, status) VALUES
(1, 2, 1, 6, 'Hi Jane! I can teach you JavaScript if you teach me Spanish. Interested?', 'accepted'),
(2, 3, 5, 9, 'Hey Alex! Would love to swap UI/UX design lessons for photography tips!', 'pending'),
(3, 1, 9, 1, 'Hi John! I can teach photography in exchange for JavaScript lessons.', 'completed'),
(4, 5, 13, 19, 'Hi Chris! French lessons for piano lessons sounds like a great deal!', 'pending'),
(5, 6, 17, 21, 'Sara, I can help with React if you help me with graphic design basics.', 'accepted');

-- Sample reviews
INSERT INTO reviews (user_id, reviewer_id, swap_request_id, rating, comment) VALUES
(1, 3, 3, 5, 'John is an amazing JavaScript teacher! Very patient and knowledgeable.'),
(3, 1, 3, 4, 'Alex taught me great photography fundamentals. Highly recommend!'),
(2, 1, 1, 5, 'Jane is a fantastic Spanish teacher. Very engaging lessons!'),
(1, 2, 1, 4, 'John explains JavaScript concepts really clearly. Great experience.');
