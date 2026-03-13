<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${profileUser.fullName} - CampusConnect</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="css/chat.css">
</head>
<body class="dashboard-page">

<!-- Navbar -->
<header class="navbar">
    <div class="nav-container">
        <div class="nav-brand">
            <span class="logo-icon">🎓</span>
            <h1>CampusConnect</h1>
        </div>
        <nav class="nav-menu">
            <a href="dashboard" class="nav-link">
                <span class="nav-icon">🏠</span><span>Dashboard</span>
            </a>
            <a href="chat" class="nav-link">
                <span class="nav-icon">💬</span><span>Messages</span>
                <span class="badge-count" id="navUnreadBadge" style="display:none">0</span>
            </a>
            <a href="profile" class="nav-link">
                <span class="nav-icon">👤</span><span>Profile</span>
            </a>
            <a href="logout" class="nav-link nav-link-logout">
                <span class="nav-icon">🚪</span><span>Logout</span>
            </a>
        </nav>
        <button class="mobile-menu-btn" onclick="document.getElementById('mobileMenu').classList.toggle('active')">
            <span></span><span></span><span></span>
        </button>
    </div>
</header>
<div class="mobile-menu" id="mobileMenu">
    <a href="dashboard" class="mobile-link">🏠 Dashboard</a>
    <a href="chat" class="mobile-link">💬 Messages</a>
    <a href="profile" class="mobile-link">👤 Profile</a>
    <a href="logout" class="mobile-link">🚪 Logout</a>
</div>

<!-- Main Content -->
<main class="main-content">
    <div class="vp-container fade-in">

        <!-- Profile Header Card -->
        <div class="vp-header-card">
            <div class="vp-cover"></div>
            <div class="vp-header-body">
                <div class="vp-avatar-wrap">
                    <c:choose>
                        <c:when test="${not empty profileUser.profilePicture}">
                            <img src="${profileUser.profilePicture}" alt="${profileUser.fullName}" class="vp-avatar-img"/>
                        </c:when>
                        <c:otherwise>
                            <div class="vp-avatar-fallback">
                                ${profileUser.fullName.substring(0,1).toUpperCase()}
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
                <div class="vp-header-info">
                    <h1 class="vp-name">${profileUser.fullName}</h1>
                    <span class="vp-college-badge">🏫 ${profileUser.college}</span>
                    <div class="vp-meta">
                        <span>📍 ${profileUser.pincode}</span>
                        <c:if test="${not empty profileUser.gender}">
                            <span>
                                <c:choose>
                                    <c:when test="${profileUser.gender == 'Male'}">👨</c:when>
                                    <c:when test="${profileUser.gender == 'Female'}">👩</c:when>
                                    <c:otherwise>👤</c:otherwise>
                                </c:choose>
                                ${profileUser.gender}
                            </span>
                        </c:if>
                        <span>🗓 Joined <fmt:formatDate value="${profileUser.createdAt}" pattern="MMM yyyy"/></span>
                    </div>
                    <c:if test="${not empty userProfile.instagram}">
                        <a href="https://instagram.com/${userProfile.instagram}" target="_blank" rel="noopener noreferrer" class="vp-instagram">
                            📸 @${userProfile.instagram}
                        </a>
                    </c:if>
                </div>
                <!-- Action buttons -->
                <div class="vp-actions">
                    <a href="chat?with=${profileUser.id}" class="btn vp-btn-chat">
                        💬 Send Message
                    </a>
                </div>
            </div>
        </div>

        <div class="vp-body-grid">

            <!-- Left column: bio & interests -->
            <div class="vp-left-col">
                <div class="vp-section-card">
                    <h2 class="vp-section-title">👋 About</h2>
                    <c:choose>
                        <c:when test="${not empty userProfile.bio}">
                            <p class="vp-bio">${userProfile.bio}</p>
                        </c:when>
                        <c:otherwise>
                            <p class="vp-empty-text">No bio yet.</p>
                        </c:otherwise>
                    </c:choose>
                </div>

                <c:if test="${not empty userProfile.interests}">
                    <div class="vp-section-card">
                        <h2 class="vp-section-title">🎯 Interests</h2>
                        <div class="vp-interests">
                            <c:forTokens var="interest" items="${userProfile.interests}" delims=",">
                                <span class="vp-interest-tag">${fn:trim(interest)}</span>
                            </c:forTokens>
                        </div>
                    </div>
                </c:if>
            </div>

            <!-- Right column: photo gallery -->
            <div class="vp-right-col">
                <div class="vp-section-card">
                    <h2 class="vp-section-title">📷 Photos</h2>
                    <c:choose>
                        <c:when test="${not empty photos}">
                            <div class="vp-photo-grid">
                                <c:forEach var="photo" items="${photos}">
                                    <a href="${photo.photoUrl}" target="_blank" class="vp-photo-item">
                                        <img src="${photo.photoUrl}" alt="Photo" loading="lazy"/>
                                    </a>
                                </c:forEach>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <p class="vp-empty-text">No photos uploaded yet.</p>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

        </div><!-- /vp-body-grid -->

    </div><!-- /vp-container -->
</main>

<footer class="footer">
    <p>&copy; 2026 CampusConnect. Connect with your college community.</p>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
// Navbar badge
(function poll() {
    fetch('unread-count')
        .then(r => r.json())
        .then(d => {
            const b = document.getElementById('navUnreadBadge');
            if (!b) return;
            if (d.count > 0) { b.textContent = d.count > 99 ? '99+' : d.count; b.style.display = 'inline-flex'; }
            else b.style.display = 'none';
        }).catch(() => {});
    setTimeout(poll, 5000);
})();
</script>
</body>
</html>
