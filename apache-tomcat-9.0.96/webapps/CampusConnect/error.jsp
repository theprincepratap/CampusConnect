<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Error - CampusConnect</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="css/style.css">
</head>
<body class="error-page">
    <div class="container">
        <div class="error-card fade-in">
            <!-- Error Icon -->
            <div class="error-icon-large">
                <span>⚠️</span>
            </div>
            
            <!-- Error Message -->
            <h1>Oops! Something went wrong</h1>
            
            <c:choose>
                <c:when test="${not empty errorMessage}">
                    <p class="error-description">${errorMessage}</p>
                </c:when>
                <c:when test="${not empty pageContext.exception}">
                    <p class="error-description">${pageContext.exception.message}</p>
                </c:when>
                <c:otherwise>
                    <p class="error-description">
                        An unexpected error occurred. Please try again later.
                    </p>
                </c:otherwise>
            </c:choose>
            
            <!-- Error Code -->
            <c:if test="${not empty errorCode}">
                <div class="error-code">
                    <span>Error Code: ${errorCode}</span>
                </div>
            </c:if>
            
            <!-- Actions -->
            <div class="error-actions">
                <a href="dashboard" class="btn btn-primary">
                    <span>Go to Dashboard</span>
                    <span class="btn-icon">🏠</span>
                </a>
                <a href="login" class="btn btn-outline">
                    <span>Back to Login</span>
                </a>
            </div>
            
            <!-- Help Text -->
            <div class="error-help">
                <p>
                    If this problem persists, please contact support or try clearing your browser cache.
                </p>
            </div>
        </div>
        
        <!-- Decorative Elements -->
        <div class="decoration decoration-1"></div>
        <div class="decoration decoration-2"></div>
    </div>
    
    <script src="js/script.js"></script>
</body>
</html>
