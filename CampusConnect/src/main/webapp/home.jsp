<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CampusConnect - Connect with Your College Community</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
            background: #ffffff;
            color: #1a1a2e;
            line-height: 1.6;
            overflow-x: hidden;
        }

        /* Navbar */
        .navbar {
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            z-index: 1000;
            padding: 16px 40px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            border-bottom: 1px solid rgba(0, 0, 0, 0.05);
        }

        .nav-logo {
            display: flex;
            align-items: center;
            gap: 10px;
            text-decoration: none;
            font-weight: 700;
            font-size: 1.25rem;
            color: #1a1a2e;
        }

        .nav-logo svg {
            width: 28px;
            height: 28px;
        }

        .nav-menu {
            display: flex;
            gap: 32px;
            list-style: none;
        }

        .nav-menu a {
            text-decoration: none;
            color: #64748b;
            font-weight: 500;
            font-size: 0.95rem;
            transition: color 0.2s;
        }

        .nav-menu a:hover {
            color: #1a1a2e;
        }

        .nav-actions {
            display: flex;
            align-items: center;
            gap: 16px;
        }

        .nav-icon {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #64748b;
            cursor: pointer;
            transition: all 0.2s;
        }

        .nav-icon:hover {
            background: #f1f5f9;
            color: #1a1a2e;
        }

        .btn-upload {
            background: #7c3aed;
            color: white;
            padding: 10px 20px;
            border-radius: 8px;
            font-weight: 600;
            font-size: 0.9rem;
            text-decoration: none;
            transition: all 0.2s;
        }

        .btn-upload:hover {
            background: #6d28d9;
            transform: translateY(-1px);
        }

        .nav-avatar {
            width: 36px;
            height: 36px;
            border-radius: 50%;
            background: linear-gradient(135deg, #667eea, #764ba2);
            cursor: pointer;
        }

        /* Hero Section with Gradient Wave */
        .hero-section {
            position: relative;
            padding-top: 80px;
        }

        .gradient-wave {
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 320px;
            background: linear-gradient(135deg, #c7d2fe 0%, #a5b4fc 25%, #818cf8 50%, #7c3aed 75%, #a78bfa 100%);
            overflow: hidden;
        }

        .gradient-wave::before {
            content: '';
            position: absolute;
            bottom: 0;
            left: 0;
            right: 0;
            height: 80px;
            background: white;
            border-radius: 50% 50% 0 0 / 100% 100% 0 0;
            transform: scaleX(1.5);
        }

        /* Profile Section */
        .profile-section {
            position: relative;
            max-width: 1200px;
            margin: 0 auto;
            padding: 180px 40px 60px;
            display: flex;
            align-items: flex-end;
            gap: 40px;
        }

        .profile-avatar {
            width: 180px;
            height: 180px;
            border-radius: 24px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 4rem;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.15);
            border: 6px solid white;
            flex-shrink: 0;
        }

        .profile-info {
            flex: 1;
            padding-bottom: 10px;
        }

        .profile-name {
            display: flex;
            align-items: center;
            gap: 12px;
            margin-bottom: 8px;
        }

        .profile-name h1 {
            font-size: 2rem;
            font-weight: 700;
            color: #1a1a2e;
        }

        .pro-badge {
            background: linear-gradient(135deg, #7c3aed, #a78bfa);
            color: white;
            padding: 4px 12px;
            border-radius: 6px;
            font-size: 0.75rem;
            font-weight: 700;
            display: flex;
            align-items: center;
            gap: 4px;
        }

        .profile-tagline {
            color: #64748b;
            font-size: 1.1rem;
            margin-bottom: 20px;
        }

        .profile-actions {
            display: flex;
            gap: 12px;
        }

        .btn-primary {
            background: #1a1a2e;
            color: white;
            padding: 12px 28px;
            border-radius: 10px;
            font-weight: 600;
            font-size: 0.95rem;
            text-decoration: none;
            transition: all 0.2s;
            border: none;
            cursor: pointer;
        }

        .btn-primary:hover {
            background: #2d2d44;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(26, 26, 46, 0.3);
        }

        .btn-outline {
            background: white;
            color: #1a1a2e;
            padding: 12px 28px;
            border-radius: 10px;
            font-weight: 600;
            font-size: 0.95rem;
            text-decoration: none;
            transition: all 0.2s;
            border: 2px solid #e2e8f0;
            cursor: pointer;
        }

        .btn-outline:hover {
            border-color: #1a1a2e;
            transform: translateY(-2px);
        }

        /* Stats Section */
        .profile-stats {
            display: flex;
            gap: 48px;
            padding-bottom: 10px;
        }

        .stat-item {
            text-align: center;
        }

        .stat-label {
            display: block;
            color: #64748b;
            font-size: 0.9rem;
            font-weight: 500;
            margin-bottom: 4px;
        }

        .stat-value {
            font-size: 1.75rem;
            font-weight: 700;
            color: #1a1a2e;
        }

        /* Achievement Badges */
        .badges-container {
            display: flex;
            gap: 8px;
            margin-left: auto;
            padding-bottom: 10px;
        }

        .badge {
            width: 36px;
            height: 36px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 0.85rem;
            font-weight: 700;
            color: white;
        }

        .badge-orange { background: #f97316; }
        .badge-purple { background: #8b5cf6; }
        .badge-dark { background: #1e293b; }

        /* Tabs Navigation */
        .tabs-section {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 40px;
            border-bottom: 1px solid #e2e8f0;
        }

        .tabs {
            display: flex;
            gap: 32px;
        }

        .tab {
            padding: 16px 0;
            color: #64748b;
            font-weight: 500;
            text-decoration: none;
            position: relative;
            display: flex;
            align-items: center;
            gap: 6px;
            transition: color 0.2s;
        }

        .tab:hover {
            color: #1a1a2e;
        }

        .tab.active {
            color: #1a1a2e;
        }

        .tab.active::after {
            content: '';
            position: absolute;
            bottom: -1px;
            left: 0;
            right: 0;
            height: 2px;
            background: #1a1a2e;
        }

        .tab-count {
            font-size: 0.8rem;
            color: #94a3b8;
            font-weight: 400;
            vertical-align: super;
        }

        /* Cards Grid */
        .cards-section {
            max-width: 1200px;
            margin: 0 auto;
            padding: 40px;
        }

        .cards-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 24px;
        }

        .card {
            background: #f8fafc;
            border-radius: 20px;
            overflow: hidden;
            transition: all 0.3s;
            cursor: pointer;
        }

        .card:hover {
            transform: translateY(-8px);
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
        }

        .card-image {
            height: 220px;
            background: linear-gradient(135deg, #e0e7ff 0%, #c7d2fe 50%, #a5b4fc 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            position: relative;
            overflow: hidden;
        }

        .card-image.gradient-1 {
            background: linear-gradient(135deg, #bfdbfe 0%, #93c5fd 50%, #60a5fa 100%);
        }

        .card-image.gradient-2 {
            background: linear-gradient(135deg, #fecaca 0%, #fca5a5 50%, #f87171 100%);
        }

        .card-image.gradient-3 {
            background: linear-gradient(135deg, #bbf7d0 0%, #86efac 50%, #4ade80 100%);
        }

        .card-image.gradient-4 {
            background: linear-gradient(135deg, #fef08a 0%, #fde047 50%, #facc15 100%);
        }

        .card-image.gradient-5 {
            background: linear-gradient(135deg, #fbcfe8 0%, #f9a8d4 50%, #f472b6 100%);
        }

        .card-icon {
            font-size: 4rem;
            filter: drop-shadow(0 4px 8px rgba(0,0,0,0.1));
        }

        .card-badge {
            position: absolute;
            top: 12px;
            right: 12px;
            padding: 4px 10px;
            border-radius: 6px;
            font-size: 0.75rem;
            font-weight: 700;
            color: white;
        }

        .card-badge.ui { background: #f97316; }
        .card-badge.ux { background: #8b5cf6; }

        .card-content {
            padding: 20px;
        }

        .card-title {
            font-size: 1.1rem;
            font-weight: 600;
            color: #1a1a2e;
            margin-bottom: 8px;
        }

        .card-category {
            color: #64748b;
            font-size: 0.9rem;
        }

        .card-stats {
            display: flex;
            gap: 16px;
            margin-top: 12px;
        }

        .card-stat {
            display: flex;
            align-items: center;
            gap: 6px;
            color: #64748b;
            font-size: 0.85rem;
        }

        .card-stat svg {
            width: 16px;
            height: 16px;
        }

        /* CTA Section */
        .cta-section {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            padding: 80px 40px;
            margin-top: 60px;
        }

        .cta-content {
            max-width: 700px;
            margin: 0 auto;
            text-align: center;
            color: white;
        }

        .cta-title {
            font-size: 2.5rem;
            font-weight: 700;
            margin-bottom: 16px;
        }

        .cta-description {
            font-size: 1.1rem;
            opacity: 0.9;
            margin-bottom: 32px;
        }

        .cta-buttons {
            display: flex;
            gap: 16px;
            justify-content: center;
        }

        .btn-white {
            background: white;
            color: #7c3aed;
            padding: 14px 32px;
            border-radius: 10px;
            font-weight: 600;
            font-size: 1rem;
            text-decoration: none;
            transition: all 0.2s;
        }

        .btn-white:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.2);
        }

        .btn-ghost {
            background: transparent;
            color: white;
            padding: 14px 32px;
            border-radius: 10px;
            font-weight: 600;
            font-size: 1rem;
            text-decoration: none;
            border: 2px solid rgba(255, 255, 255, 0.4);
            transition: all 0.2s;
        }

        .btn-ghost:hover {
            background: rgba(255, 255, 255, 0.1);
            border-color: white;
            transform: translateY(-2px);
        }

        /* Footer */
        .footer {
            background: #0f172a;
            padding: 48px 40px 24px;
            color: white;
        }

        .footer-content {
            max-width: 1200px;
            margin: 0 auto;
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding-bottom: 24px;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
        }

        .footer-logo {
            display: flex;
            align-items: center;
            gap: 10px;
            font-weight: 700;
            font-size: 1.25rem;
        }

        .footer-links {
            display: flex;
            gap: 32px;
        }

        .footer-links a {
            color: rgba(255, 255, 255, 0.7);
            text-decoration: none;
            font-size: 0.9rem;
            transition: color 0.2s;
        }

        .footer-links a:hover {
            color: white;
        }

        .footer-bottom {
            max-width: 1200px;
            margin: 0 auto;
            padding-top: 24px;
            text-align: center;
            color: rgba(255, 255, 255, 0.5);
            font-size: 0.9rem;
        }

        /* Responsive */
        @media (max-width: 1024px) {
            .cards-grid {
                grid-template-columns: repeat(2, 1fr);
            }

            .profile-section {
                flex-wrap: wrap;
            }

            .badges-container {
                margin-left: 0;
                width: 100%;
                justify-content: flex-start;
            }
        }

        @media (max-width: 768px) {
            .navbar {
                padding: 12px 20px;
            }

            .nav-menu {
                display: none;
            }

            .profile-section {
                padding: 160px 20px 40px;
                flex-direction: column;
                align-items: center;
                text-align: center;
            }

            .profile-avatar {
                width: 140px;
                height: 140px;
                font-size: 3rem;
            }

            .profile-info {
                display: flex;
                flex-direction: column;
                align-items: center;
            }

            .profile-name {
                flex-direction: column;
            }

            .profile-stats {
                justify-content: center;
            }

            .badges-container {
                justify-content: center;
            }

            .tabs-section {
                padding: 0 20px;
                overflow-x: auto;
            }

            .tabs {
                gap: 24px;
            }

            .cards-section {
                padding: 24px 20px;
            }

            .cards-grid {
                grid-template-columns: 1fr;
            }

            .cta-section {
                padding: 60px 20px;
            }

            .cta-title {
                font-size: 1.8rem;
            }

            .cta-buttons {
                flex-direction: column;
            }

            .footer-content {
                flex-direction: column;
                gap: 24px;
            }

            .footer-links {
                flex-wrap: wrap;
                justify-content: center;
                gap: 16px;
            }
        }
    </style>
</head>
<body>
    <!-- Navigation -->
    <nav class="navbar">
        <a href="home.jsp" class="nav-logo">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <path d="M22 10v6M2 10l10-5 10 5-10 5z"/>
                <path d="M6 12v5c0 2 2 3 6 3s6-1 6-3v-5"/>
            </svg>
            CampusConnect
        </a>
        
        <ul class="nav-menu">
            <li><a href="#">Students</a></li>
            <li><a href="#">Explore</a></li>
            <li><a href="#">Colleges</a></li>
            <li><a href="#">Community</a></li>
            <li><a href="#">Go Pro ✨</a></li>
        </ul>
        
        <div class="nav-actions">
            <span class="nav-icon">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z"/>
                    <polyline points="22,6 12,13 2,6"/>
                </svg>
            </span>
            <span class="nav-icon">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9"/>
                    <path d="M13.73 21a2 2 0 0 1-3.46 0"/>
                </svg>
            </span>
            <a href="register.jsp" class="btn-upload">Join Now</a>
        </div>
    </nav>

    <!-- Hero Section -->
    <section class="hero-section">
        <div class="gradient-wave"></div>
        
        <!-- Profile Section -->
        <div class="profile-section">
            <div class="profile-avatar">🎓</div>
            
            <div class="profile-info">
                <div class="profile-name">
                    <h1>CampusConnect</h1>
                    <span class="pro-badge">COMMUNITY ✨</span>
                </div>
                <p class="profile-tagline">Connect with students from your college and neighborhood</p>
                <div class="profile-actions">
                    <a href="register.jsp" class="btn-primary">Join Community</a>
                    <a href="login.jsp" class="btn-outline">Sign In</a>
                </div>
            </div>
            
            <div class="profile-stats">
                <div class="stat-item">
                    <span class="stat-label">Students</span>
                    <span class="stat-value">2,985</span>
                </div>
                <div class="stat-item">
                    <span class="stat-label">Colleges</span>
                    <span class="stat-value">132</span>
                </div>
                <div class="stat-item">
                    <span class="stat-label">Connections</span>
                    <span class="stat-value">548</span>
                </div>
            </div>
            
            <div class="badges-container">
                <span class="badge badge-orange">26</span>
                <span class="badge badge-purple">6</span>
                <span class="badge badge-dark">12</span>
            </div>
        </div>
    </section>

    <!-- Tabs Navigation -->
    <div class="tabs-section">
        <div class="tabs">
            <a href="#" class="tab active">Features<span class="tab-count">6</span></a>
            <a href="#" class="tab">Students</a>
            <a href="#" class="tab">Colleges</a>
            <a href="#" class="tab">About</a>
        </div>
    </div>

    <!-- Cards Grid -->
    <section class="cards-section">
        <div class="cards-grid">
            <div class="card">
                <div class="card-image gradient-1">
                    <span class="card-icon">🔍</span>
                    <span class="card-badge ui">NEW</span>
                </div>
                <div class="card-content">
                    <h3 class="card-title">Smart Discovery</h3>
                    <p class="card-category">Find students by pincode</p>
                    <div class="card-stats">
                        <span class="card-stat">
                            <svg viewBox="0 0 24 24" fill="currentColor"><path d="M12 21.35l-1.45-1.32C5.4 15.36 2 12.28 2 8.5 2 5.42 4.42 3 7.5 3c1.74 0 3.41.81 4.5 2.09C13.09 3.81 14.76 3 16.5 3 19.58 3 22 5.42 22 8.5c0 3.78-3.4 6.86-8.55 11.54L12 21.35z"/></svg>
                            517
                        </span>
                        <span class="card-stat">
                            <svg viewBox="0 0 24 24" fill="currentColor"><path d="M12 4.5C7 4.5 2.73 7.61 1 12c1.73 4.39 6 7.5 11 7.5s9.27-3.11 11-7.5c-1.73-4.39-6-7.5-11-7.5zM12 17c-2.76 0-5-2.24-5-5s2.24-5 5-5 5 2.24 5 5-2.24 5-5 5zm0-8c-1.66 0-3 1.34-3 3s1.34 3 3 3 3-1.34 3-3-1.34-3-3-3z"/></svg>
                            9.3k
                        </span>
                    </div>
                </div>
            </div>
            
            <div class="card">
                <div class="card-image">
                    <span class="card-icon">🤝</span>
                    <span class="card-badge ux">HOT</span>
                </div>
                <div class="card-content">
                    <h3 class="card-title">Easy Connections</h3>
                    <p class="card-category">Connect with classmates</p>
                    <div class="card-stats">
                        <span class="card-stat">
                            <svg viewBox="0 0 24 24" fill="currentColor"><path d="M12 21.35l-1.45-1.32C5.4 15.36 2 12.28 2 8.5 2 5.42 4.42 3 7.5 3c1.74 0 3.41.81 4.5 2.09C13.09 3.81 14.76 3 16.5 3 19.58 3 22 5.42 22 8.5c0 3.78-3.4 6.86-8.55 11.54L12 21.35z"/></svg>
                            983
                        </span>
                        <span class="card-stat">
                            <svg viewBox="0 0 24 24" fill="currentColor"><path d="M12 4.5C7 4.5 2.73 7.61 1 12c1.73 4.39 6 7.5 11 7.5s9.27-3.11 11-7.5c-1.73-4.39-6-7.5-11-7.5zM12 17c-2.76 0-5-2.24-5-5s2.24-5 5-5 5 2.24 5 5-2.24 5-5 5zm0-8c-1.66 0-3 1.34-3 3s1.34 3 3 3 3-1.34 3-3-1.34-3-3-3z"/></svg>
                            14k
                        </span>
                    </div>
                </div>
            </div>
            
            <div class="card">
                <div class="card-image gradient-5">
                    <span class="card-icon">🔒</span>
                    <span class="card-badge ui">SECURE</span>
                </div>
                <div class="card-content">
                    <h3 class="card-title">Secure & Private</h3>
                    <p class="card-category">SHA-256 encryption</p>
                    <div class="card-stats">
                        <span class="card-stat">
                            <svg viewBox="0 0 24 24" fill="currentColor"><path d="M12 21.35l-1.45-1.32C5.4 15.36 2 12.28 2 8.5 2 5.42 4.42 3 7.5 3c1.74 0 3.41.81 4.5 2.09C13.09 3.81 14.76 3 16.5 3 19.58 3 22 5.42 22 8.5c0 3.78-3.4 6.86-8.55 11.54L12 21.35z"/></svg>
                            875
                        </span>
                        <span class="card-stat">
                            <svg viewBox="0 0 24 24" fill="currentColor"><path d="M12 4.5C7 4.5 2.73 7.61 1 12c1.73 4.39 6 7.5 11 7.5s9.27-3.11 11-7.5c-1.73-4.39-6-7.5-11-7.5zM12 17c-2.76 0-5-2.24-5-5s2.24-5 5-5 5 2.24 5 5-2.24 5-5 5zm0-8c-1.66 0-3 1.34-3 3s1.34 3 3 3 3-1.34 3-3-1.34-3-3-3z"/></svg>
                            13.5k
                        </span>
                    </div>
                </div>
            </div>
            
            <div class="card">
                <div class="card-image gradient-3">
                    <span class="card-icon">📱</span>
                </div>
                <div class="card-content">
                    <h3 class="card-title">Responsive Design</h3>
                    <p class="card-category">Works on all devices</p>
                    <div class="card-stats">
                        <span class="card-stat">
                            <svg viewBox="0 0 24 24" fill="currentColor"><path d="M12 21.35l-1.45-1.32C5.4 15.36 2 12.28 2 8.5 2 5.42 4.42 3 7.5 3c1.74 0 3.41.81 4.5 2.09C13.09 3.81 14.76 3 16.5 3 19.58 3 22 5.42 22 8.5c0 3.78-3.4 6.86-8.55 11.54L12 21.35z"/></svg>
                            642
                        </span>
                        <span class="card-stat">
                            <svg viewBox="0 0 24 24" fill="currentColor"><path d="M12 4.5C7 4.5 2.73 7.61 1 12c1.73 4.39 6 7.5 11 7.5s9.27-3.11 11-7.5c-1.73-4.39-6-7.5-11-7.5zM12 17c-2.76 0-5-2.24-5-5s2.24-5 5-5 5 2.24 5 5-2.24 5-5 5zm0-8c-1.66 0-3 1.34-3 3s1.34 3 3 3 3-1.34 3-3-1.34-3-3-3z"/></svg>
                            8.7k
                        </span>
                    </div>
                </div>
            </div>
            
            <div class="card">
                <div class="card-image gradient-4">
                    <span class="card-icon">⚡</span>
                    <span class="card-badge ux">FAST</span>
                </div>
                <div class="card-content">
                    <h3 class="card-title">Real-time Updates</h3>
                    <p class="card-category">Instant notifications</p>
                    <div class="card-stats">
                        <span class="card-stat">
                            <svg viewBox="0 0 24 24" fill="currentColor"><path d="M12 21.35l-1.45-1.32C5.4 15.36 2 12.28 2 8.5 2 5.42 4.42 3 7.5 3c1.74 0 3.41.81 4.5 2.09C13.09 3.81 14.76 3 16.5 3 19.58 3 22 5.42 22 8.5c0 3.78-3.4 6.86-8.55 11.54L12 21.35z"/></svg>
                            756
                        </span>
                        <span class="card-stat">
                            <svg viewBox="0 0 24 24" fill="currentColor"><path d="M12 4.5C7 4.5 2.73 7.61 1 12c1.73 4.39 6 7.5 11 7.5s9.27-3.11 11-7.5c-1.73-4.39-6-7.5-11-7.5zM12 17c-2.76 0-5-2.24-5-5s2.24-5 5-5 5 2.24 5 5-2.24 5-5 5zm0-8c-1.66 0-3 1.34-3 3s1.34 3 3 3 3-1.34 3-3-1.34-3-3-3z"/></svg>
                            11.2k
                        </span>
                    </div>
                </div>
            </div>
            
            <div class="card">
                <div class="card-image gradient-2">
                    <span class="card-icon">👥</span>
                </div>
                <div class="card-content">
                    <h3 class="card-title">Profile Management</h3>
                    <p class="card-category">Customize your profile</p>
                    <div class="card-stats">
                        <span class="card-stat">
                            <svg viewBox="0 0 24 24" fill="currentColor"><path d="M12 21.35l-1.45-1.32C5.4 15.36 2 12.28 2 8.5 2 5.42 4.42 3 7.5 3c1.74 0 3.41.81 4.5 2.09C13.09 3.81 14.76 3 16.5 3 19.58 3 22 5.42 22 8.5c0 3.78-3.4 6.86-8.55 11.54L12 21.35z"/></svg>
                            534
                        </span>
                        <span class="card-stat">
                            <svg viewBox="0 0 24 24" fill="currentColor"><path d="M12 4.5C7 4.5 2.73 7.61 1 12c1.73 4.39 6 7.5 11 7.5s9.27-3.11 11-7.5c-1.73-4.39-6-7.5-11-7.5zM12 17c-2.76 0-5-2.24-5-5s2.24-5 5-5 5 2.24 5 5-2.24 5-5 5zm0-8c-1.66 0-3 1.34-3 3s1.34 3 3 3 3-1.34 3-3-1.34-3-3-3z"/></svg>
                            7.8k
                        </span>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- CTA Section -->
    <section class="cta-section">
        <div class="cta-content">
            <h2 class="cta-title">Ready to Connect?</h2>
            <p class="cta-description">
                Join thousands of students from your college. Create your profile and start building meaningful connections today.
            </p>
            <div class="cta-buttons">
                <a href="register.jsp" class="btn-white">Create Free Account</a>
                <a href="login.jsp" class="btn-ghost">Sign In</a>
            </div>
        </div>
    </section>

    <!-- Footer -->
    <footer class="footer">
        <div class="footer-content">
            <div class="footer-logo">
                <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <path d="M22 10v6M2 10l10-5 10 5-10 5z"/>
                    <path d="M6 12v5c0 2 2 3 6 3s6-1 6-3v-5"/>
                </svg>
                CampusConnect
            </div>
            <div class="footer-links">
                <a href="#">About</a>
                <a href="#">Features</a>
                <a href="#">Privacy</a>
                <a href="#">Terms</a>
                <a href="#">Contact</a>
            </div>
        </div>
        <div class="footer-bottom">
            <p>© 2026 CampusConnect. All rights reserved.</p>
        </div>
    </footer>
</body>
</html>
