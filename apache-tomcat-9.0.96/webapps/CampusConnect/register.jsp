<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register - CampusConnect</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="css/register.css">
</head>
<body class="register-page">
    <div class="register-wrapper">
        <!-- Left Panel - Branding -->
        <div class="register-panel left-panel">
            <div class="panel-content">
                <div class="logo-section">
                    <span class="logo-icon">🎓</span>
                    <h1>CampusConnect</h1>
                </div>
                
                <div class="brand-description">
                    <h2>New User Registration</h2>
                    <p>Find your college partner.</p>
                </div>
                
                <div class="features-list">
                    <div class="feature-item">
                        <span class="feature-icon">🔗</span>
                        <span>Connect with classmates</span>
                    </div>
                    <div class="feature-item">
                        <span class="feature-icon">🎯</span>
                        <span>Filter by location</span>
                    </div>
                    <div class="feature-item">
                        <span class="feature-icon">💬</span>
                        <span>Build relationships</span>
                    </div>
                </div>
                
                <div class="nav-links">
                    <a href="login.jsp" class="nav-link">Login</a>
                    <span class="nav-divider">|</span>
                    <span class="nav-link active">Sign Up</span>
                </div>
                
                <div class="panel-footer">
                    <p>Terms of Use and Conditions</p>
                </div>
            </div>
        </div>

        <!-- Right Panel - Registration Form -->
        <div class="register-panel right-panel">
            <div class="form-card">
                <div class="form-header">
                    <h2>Create Account</h2>
                    <p>Start connecting with your college community</p>
                </div>

                <!-- Error Message -->
                <c:if test="${not empty error}">
                    <div class="alert alert-error">
                        <span class="alert-icon">⚠️</span>
                        ${error}
                    </div>
                </c:if>
                
                <!-- Registration Form -->
                <form action="register" method="post" class="register-form" id="registerForm">
                    <!-- Row 1: First Name & Last Name -->
                    <div class="form-row">
                        <div class="form-group">
                            <label for="firstName">First Name *</label>
                            <div class="input-group">
                                <span class="input-icon">👤</span>
                                <input type="text" id="firstName" name="firstName" placeholder="John" required value="${firstName}">
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="lastName">Last Name *</label>
                            <div class="input-group">
                                <span class="input-icon">👤</span>
                                <input type="text" id="lastName" name="lastName" placeholder="Doe" required value="${lastName}">
                            </div>
                        </div>
                    </div>

                    <!-- Row 2: Email -->
                    <div class="form-row" style="grid-template-columns:1fr">
                        <div class="form-group">
                            <label for="email">Email Address *</label>
                            <div class="input-group">
                                <span class="input-icon">📧</span>
                                <input type="email" id="email" name="email" placeholder="john@example.com" required value="${email}">
                            </div>
                        </div>
                    </div>

                    <!-- Row 3: Password & Confirm Password -->
                    <div class="form-row">
                        <div class="form-group">
                            <label for="password">Password *</label>
                            <div class="input-group">
                                <span class="input-icon">🔐</span>
                                <input type="password" id="password" name="password" placeholder="Min 8 characters" required minlength="8" onkeyup="checkPasswordMatch()">
                                <button type="button" class="pwd-toggle" onclick="togglePassword('password')">👁️</button>
                            </div>
                            <div class="password-strength" id="passwordStrength">
                                <div class="strength-bar"><div class="strength-fill" id="strengthFill"></div></div>
                                <span class="strength-text" id="strengthText">Password strength</span>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="confirmPassword">Confirm Password *</label>
                            <div class="input-group">
                                <span class="input-icon">🔐</span>
                                <input type="password" id="confirmPassword" name="confirmPassword" placeholder="Confirm password" required minlength="8" onkeyup="checkPasswordMatch()">
                                <button type="button" class="pwd-toggle" onclick="togglePassword('confirmPassword')">👁️</button>
                            </div>
                            <span class="password-match-indicator" id="passwordMatch"></span>
                        </div>
                    </div>

                    <!-- Row 4: College -->
                    <div class="form-row">
                        <div class="form-group full-width">
                            <label for="college">College/University *</label>
                            <div class="input-group">
                                <span class="input-icon">🏫</span>
                                <input type="text" id="college" name="college" placeholder="Select your college" list="collegeList" required value="${college}">
                                <datalist id="collegeList">
                                    <option value="VIT University">
                                    <option value="IIT Madras">
                                    <option value="Anna University">
                                    <option value="SRM University">
                                    <option value="Amity University">
                                    <option value="Saveetha Institute">
                                    <option value="Vellore Institute of Technology">
                                </datalist>
                            </div>
                        </div>
                    </div>

                    <!-- Row 5: Pincode -->
                    <div class="form-row">
                        <div class="form-group full-width">
                            <label for="pincode">Pincode *</label>
                            <div class="input-group">
                                <span class="input-icon">📍</span>
                                <input type="text" id="pincode" name="pincode" placeholder="6-digit code" required pattern="[0-9]{6}" maxlength="6" value="${pincode}">
                            </div>
                        </div>
                    </div>

                    <!-- Row 6: Gender -->
                    <div class="form-group full-width">
                        <label>Gender *</label>
                        <div class="gender-options">
                            <label class="radio-option">
                                <input type="radio" name="gender" value="Male" ${gender == 'Male' ? 'checked' : ''} required>
                                <span class="radio-label">👨 Male</span>
                            </label>
                            <label class="radio-option">
                                <input type="radio" name="gender" value="Female" ${gender == 'Female' ? 'checked' : ''}>
                                <span class="radio-label">👩 Female</span>
                            </label>
                            <label class="radio-option">
                                <input type="radio" name="gender" value="Other" ${gender == 'Other' ? 'checked' : ''}>
                                <span class="radio-label">👤 Other</span>
                            </label>
                        </div>
                        <span class="error-message" id="gender-error"></span>
                    </div>
                    <div class="form-group full-width">
                        <label class="checkbox-option">
                            <input type="checkbox" id="agreeTerms" required>
                            <span>I agree to Terms of Use and Conditions</span>
                        </label>
                        <span class="error-message" id="terms-error"></span>
                    </div>

                    <button type="submit" class="btn-submit">Create Account</button>
                </form>

                <!-- Login Link -->
                <div class="form-footer">
                    <p>Already have an account? <a href="login.jsp">Sign In</a></p>
                </div>
            </div>
        </div>
    </div>

    <script src="js/validation.js"></script>
</body>
</html>
