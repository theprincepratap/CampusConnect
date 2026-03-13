<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - CampusConnect</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="css/style.css">
</head>
<body class="login-page">
    <div class="login-wrapper">

        <!-- ═══════════════════════════════════
             LEFT: Branding / Illustration Panel
             ═══════════════════════════════════ -->
        <div class="login-left">
            <div class="login-branding">

                <!-- Logo -->
                <div class="login-logo">
                    <span>🎓</span>
                    <h1>CampusConnect</h1>
                </div>

                <!-- Illustration with floating cards -->
                <div class="login-illustration">
                    <div class="illus-central">
                        <div class="illus-circle">
                            <span class="illus-icon">🎓</span>
                        </div>
                    </div>

                    <!-- Floating stat cards -->
                    <div class="float-card float-card-1">
                        <span class="fc-icon">👥</span>
                        <div class="fc-text">
                            <span class="fc-num">2,400+</span>
                            <span class="fc-label">Students</span>
                        </div>
                    </div>

                    <div class="float-card float-card-2">
                        <span class="fc-icon">🏫</span>
                        <div class="fc-text">
                            <span class="fc-num">120+</span>
                            <span class="fc-label">Colleges</span>
                        </div>
                    </div>

                    <div class="float-card float-card-3">
                        <span class="fc-icon">🤝</span>
                        <div class="fc-text">
                            <span class="fc-num">98%</span>
                            <span class="fc-label">Match Rate</span>
                        </div>
                    </div>

                    <!-- Decorative ring -->
                    <div class="illus-ring illus-ring-1"></div>
                    <div class="illus-ring illus-ring-2"></div>
                </div>

                <!-- Hero text -->
                <div class="login-hero-text">
                    <h2>Find Your College Partner</h2>
                    <p>Connect with students from your campus.</p>
                </div>

                <!-- Feature pills -->
                <div class="login-features">
                    <span class="lf-pill">📍 Location-based matching</span>
                    <span class="lf-pill">🔒 Secure &amp; Private</span>
                    <span class="lf-pill">⚡ Instant Connect</span>
                </div>

            </div>
        </div>

        <!-- ═══════════════════════════════════
             RIGHT: Login Form Panel
             ═══════════════════════════════════ -->
        <div class="login-right">
            <div class="login-form-card fade-in">

                <div class="lfc-header">
                    <h2>Welcome to CampusConnect</h2>
                    <p>Enter your credentials to access your account</p>
                </div>

                <!-- Success Message -->
                <c:if test="${not empty sessionScope.successMessage}">
                    <div class="alert alert-success">
                        <span class="alert-icon">✓</span>
                        ${sessionScope.successMessage}
                    </div>
                    <c:remove var="successMessage" scope="session"/>
                </c:if>

                <!-- Error Message -->
                <c:if test="${not empty error}">
                    <div class="alert alert-error">
                        <span class="alert-icon">!</span>
                        ${error}
                    </div>
                </c:if>

                <!-- Login Form -->
                <form action="login" method="post" class="lfc-form" id="loginForm">

                    <!-- Email -->
                    <div class="lfc-field">
                        <label for="email">Email Address</label>
                        <div class="lfc-input-wrap">
                            <svg class="lfc-input-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z"/>
                                <polyline points="22,6 12,13 2,6"/>
                            </svg>
                            <input
                                type="email"
                                id="email"
                                name="email"
                                placeholder="Enter your email address"
                                value="${email}"
                                required
                                autocomplete="email"
                            >
                        </div>
                    </div>

                    <!-- Password -->
                    <div class="lfc-field">
                        <label for="password">Password</label>
                        <div class="lfc-input-wrap">
                            <svg class="lfc-input-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <rect x="3" y="11" width="18" height="11" rx="2" ry="2"/>
                                <path d="M7 11V7a5 5 0 0 1 10 0v4"/>
                            </svg>
                            <input
                                type="password"
                                id="password"
                                name="password"
                                placeholder="Enter your password"
                                required
                                autocomplete="current-password"
                            >
                            <button type="button" class="lfc-eye-btn" onclick="toggleLoginPassword()" aria-label="Toggle password visibility">
                                <svg id="lfc-eye-open" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/>
                                    <circle cx="12" cy="12" r="3"/>
                                </svg>
                                <svg id="lfc-eye-closed" style="display:none" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <path d="M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-11-8-11-8a18.45 18.45 0 0 1 5.06-5.94M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 11 8 11 8a18.5 18.5 0 0 1-2.16 3.19M1 1l22 22"/>
                                </svg>
                            </button>
                        </div>
                    </div>

                    <!-- Remember me + Forgot password -->
                    <div class="lfc-options">
                        <label class="lfc-remember">
                            <input type="checkbox" name="rememberMe" id="rememberMe">
                            <span class="lfc-checkmark"></span>
                            <span>Remember me</span>
                        </label>
                        <a href="#" class="lfc-forgot">Forgot password?</a>
                    </div>

                    <!-- Submit -->
                    <button type="submit" class="lfc-submit-btn">
                        Login
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                            <line x1="5" y1="12" x2="19" y2="12"/>
                            <polyline points="12 5 19 12 12 19"/>
                        </svg>
                    </button>

                </form>

                <!-- Register link -->
                <div class="lfc-footer">
                    <p>Not registered yet? <a href="register" class="lfc-link">Create an account</a></p>
                </div>

            </div>
        </div>

    </div>

    <script>
        function toggleLoginPassword() {
            var input     = document.getElementById('password');
            var eyeOpen   = document.getElementById('lfc-eye-open');
            var eyeClosed = document.getElementById('lfc-eye-closed');
            if (input.type === 'password') {
                input.type = 'text';
                eyeOpen.style.display   = 'none';
                eyeClosed.style.display = 'block';
            } else {
                input.type = 'password';
                eyeOpen.style.display   = 'block';
                eyeClosed.style.display = 'none';
            }
        }
    </script>
</body>
</html>
