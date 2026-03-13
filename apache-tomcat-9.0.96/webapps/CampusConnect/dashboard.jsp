<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - CampusConnect</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="css/chat.css">
</head>
<body class="dashboard-page">
    <!-- Navigation Header -->
    <header class="navbar">
        <div class="nav-container">
            <div class="nav-brand">
                <span class="logo-icon">🎓</span>
                <h1>CampusConnect</h1>
            </div>
            <nav class="nav-menu">
                <a href="dashboard" class="nav-link active">
                    <span class="nav-icon">🏠</span>
                    <span>Dashboard</span>
                </a>
                <a href="chat" class="nav-link">
                    <span class="nav-icon">💬</span>
                    <span>Messages</span>
                    <span class="badge-count" id="navUnreadBadge" style="display:none">0</span>
                </a>
                <a href="profile" class="nav-link">
                    <span class="nav-icon">👤</span>
                    <span>Profile</span>
                </a>
                <a href="logout" class="nav-link nav-link-logout">
                    <span class="nav-icon">🚪</span>
                    <span>Logout</span>
                </a>
            </nav>
            <button class="mobile-menu-btn" onclick="toggleMobileMenu()">
                <span></span>
                <span></span>
                <span></span>
            </button>
        </div>
    </header>
    
    <!-- Mobile Menu -->
    <div class="mobile-menu" id="mobileMenu">
        <a href="dashboard" class="mobile-link active">🏠 Dashboard</a>
        <a href="chat" class="mobile-link">💬 Messages</a>
        <a href="profile" class="mobile-link">👤 Profile</a>
        <a href="logout" class="mobile-link">🚪 Logout</a>
    </div>
    
    <!-- Main Content -->
    <main class="main-content">
        <div class="dashboard-container fade-in">
            <!-- Welcome Section -->
            <section class="welcome-section">
                <div class="welcome-card">
                    <div class="welcome-avatar">
                        <c:choose>
                            <c:when test="${not empty currentUser.profilePicture}">
                                <img src="${currentUser.profilePicture}" alt="Your avatar" class="profile-pic-img"/>
                            </c:when>
                            <c:otherwise>
                                <span>${currentUser.fullName.substring(0, 1).toUpperCase()}</span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <div class="welcome-info">
                        <h2>Welcome, ${currentUser.fullName}!</h2>
                        <p class="college-badge">
                            <span class="badge-icon">🏫</span>
                            ${currentUser.college}
                        </p>
                        <p class="user-meta">
                            <span>📧 ${currentUser.email}</span>
                            <span>📍 ${currentUser.pincode}</span>
                        </p>
                    </div>
                </div>
            </section>
            
            <!-- Filter Section -->
            <section class="filter-section">
                <div class="filter-card">
                    <h3>
                        <span class="filter-icon">🔍</span>
                        Find Classmates
                    </h3>
                    <form action="dashboard" method="get" class="filter-form">
                        <div class="filter-row">
                            <!-- Name Search -->
                            <div class="filter-field">
                                <label class="filter-label">👤 Name</label>
                                <input
                                    type="text"
                                    name="name"
                                    placeholder="Search by name..."
                                    value="${selectedName}"
                                    maxlength="100"
                                    class="filter-input"
                                >
                            </div>
                            <!-- Gender -->
                            <div class="filter-field">
                                <label class="filter-label">⚧ Gender</label>
                                <select name="gender" class="filter-input filter-select">
                                    <option value="">All Genders</option>
                                    <option value="Male"   ${selectedGender == 'Male'   ? 'selected' : ''}>Male</option>
                                    <option value="Female" ${selectedGender == 'Female' ? 'selected' : ''}>Female</option>
                                    <option value="Other"  ${selectedGender == 'Other'  ? 'selected' : ''}>Other</option>
                                </select>
                            </div>
                            <!-- Pincode / Location -->
                            <div class="filter-field">
                                <label class="filter-label">📍 Pincode</label>
                                <input
                                    type="text"
                                    name="pincode"
                                    placeholder="6-digit pincode..."
                                    value="${selectedPincode}"
                                    pattern="[0-9]{0,6}"
                                    maxlength="6"
                                    class="filter-input"
                                >
                            </div>
                            <!-- Buttons -->
                            <div class="filter-actions">
                                <button type="submit" class="btn btn-secondary">Apply Filters</button>
                                <a href="dashboard" class="btn btn-outline">Clear</a>
                            </div>
                        </div>
                    </form>
                    <!-- Active filter tags -->
                    <c:if test="${not empty selectedName or not empty selectedGender or not empty selectedPincode}">
                        <div class="active-filters">
                            <span class="active-filters-label">Active:</span>
                            <c:if test="${not empty selectedName}">
                                <span class="filter-tag">👤 ${selectedName}</span>
                            </c:if>
                            <c:if test="${not empty selectedGender}">
                                <span class="filter-tag">
                                    <c:choose>
                                        <c:when test="${selectedGender == 'Male'}">👨</c:when>
                                        <c:when test="${selectedGender == 'Female'}">👩</c:when>
                                        <c:otherwise>👤</c:otherwise>
                                    </c:choose>
                                    ${selectedGender}
                                </span>
                            </c:if>
                            <c:if test="${not empty selectedPincode}">
                                <span class="filter-tag">📍 ${selectedPincode}</span>
                            </c:if>
                        </div>
                    </c:if>
                </div>
            </section>
            
            <!-- Users Grid Section -->
            <section class="users-section">
                <div class="section-header">
                    <h3>
                        <span class="section-icon">👥</span>
                        People from ${currentUser.college}
                    </h3>
                    <span class="user-count">${userCount} found</span>
                </div>
                
                <c:choose>
                    <c:when test="${empty collegeUsers}">
                        <div class="empty-state">
                            <div class="empty-icon">🔍</div>
                            <h4>No classmates found</h4>
                            <p>
                                <c:choose>
                                    <c:when test="${not empty selectedName or not empty selectedGender or not empty selectedPincode}">
                                        No users match your filters. Try changing or clearing them.
                                    </c:when>
                                    <c:otherwise>
                                        Be the first from your college! Invite your friends to join.
                                    </c:otherwise>
                                </c:choose>
                            </p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="users-grid">
                            <c:forEach var="user" items="${collegeUsers}">
                                <div class="user-card">
                                    <div class="user-avatar">
                                        <c:choose>
                                            <c:when test="${not empty user.profilePicture}">
                                                <img src="${user.profilePicture}" alt="${user.fullName}" class="profile-pic-img"/>
                                            </c:when>
                                            <c:otherwise>
                                                <span>${user.fullName.substring(0, 1).toUpperCase()}</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                    <div class="user-details">
                                        <h4 class="user-name">${user.fullName}</h4>
                                        <p class="user-email">
                                            <span class="detail-icon">📧</span>
                                            ${user.email}
                                        </p>
                                        <div class="user-tags">
                                            <span class="tag tag-pincode">
                                                <span class="tag-icon">📍</span>
                                                ${user.pincode}
                                            </span>
                                            <c:if test="${not empty user.gender}">
                                                <span class="tag tag-gender">
                                                    <c:choose>
                                                        <c:when test="${user.gender == 'Male'}">👨</c:when>
                                                        <c:when test="${user.gender == 'Female'}">👩</c:when>
                                                        <c:otherwise>👤</c:otherwise>
                                                    </c:choose>
                                                    ${user.gender}
                                                </span>
                                            </c:if>
                                        </div>
                                        <p class="user-joined">
                                            Joined <fmt:formatDate value="${user.createdAt}" pattern="MMM dd, yyyy"/>
                                        </p>
                                        <div class="user-card-actions">
                                            <a href="chat?with=${user.id}" class="btn btn-primary user-card-btn">Chat</a>
                                            <a href="view-profile?id=${user.id}" class="btn btn-outline user-card-btn">View Profile</a>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </c:otherwise>
                </c:choose>
            </section>
        </div>
    </main>
    
    <!-- Footer -->
    <footer class="footer">
        <p>&copy; 2026 CampusConnect. Connect with your college community.</p>
    </footer>
    
    <script src="js/script.js"></script>
    <script>
    (function pollUnreadCount() {
        fetch('unread-count')
            .then(function(response) { return response.json(); })
            .then(function(data) {
                var badge = document.getElementById('navUnreadBadge');
                if (!badge) {
                    return;
                }
                if (data.count > 0) {
                    badge.textContent = data.count > 99 ? '99+' : data.count;
                    badge.style.display = 'inline-flex';
                } else {
                    badge.style.display = 'none';
                }
            })
            .catch(function() {});
        setTimeout(pollUnreadCount, 5000);
    })();
    </script>
</body>
</html>
