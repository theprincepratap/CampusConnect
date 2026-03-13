-- ============================================
-- CampusConnect Database Setup Script
-- PostgreSQL
-- ============================================

-- NOTE: Run this script after connecting to the 'campusconnect' database.
-- Create the database first if it doesn't exist:
--   CREATE DATABASE campusconnect;
-- Then connect: \c campusconnect

-- Drop table if exists (for fresh setup)
DROP TABLE IF EXISTS users;

-- Create users table
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    college VARCHAR(150) NOT NULL,
    pincode VARCHAR(10) NOT NULL,
    gender VARCHAR(10),
    profile_picture VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create index on email for faster lookups
CREATE INDEX idx_users_email ON users(email);

-- Create index on college for filtering
CREATE INDEX idx_users_college ON users(college);

-- Create index on pincode for filtering
CREATE INDEX idx_users_pincode ON users(pincode);

-- Verify data
SELECT * FROM users;

SELECT 'Database setup completed successfully!' AS "Status";
