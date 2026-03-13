<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Profile - CampusConnect</title>
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
                <a href="dashboard" class="nav-link">
                    <span class="nav-icon">🏠</span>
                    <span>Dashboard</span>
                </a>
                <a href="chat" class="nav-link">
                    <span class="nav-icon">💬</span>
                    <span>Messages</span>
                    <span class="badge-count" id="navUnreadBadge" style="display:none">0</span>
                </a>
                <a href="profile" class="nav-link active">
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
        <a href="dashboard" class="mobile-link">🏠 Dashboard</a>
        <a href="chat" class="mobile-link">💬 Messages</a>
        <a href="profile" class="mobile-link active">👤 Profile</a>
        <a href="logout" class="mobile-link">🚪 Logout</a>
    </div>
    
    <!-- Main Content -->
    <main class="main-content">
        <div class="profile-container fade-in">
            <!-- Profile Header -->
            <section class="profile-header">
                <div class="profile-avatar-large">
                    <c:choose>
                        <c:when test="${not empty currentUser.profilePicture}">
                            <img src="${currentUser.profilePicture}" alt="Profile Picture" class="profile-pic-img"/>
                        </c:when>
                        <c:otherwise>
                            <span>${currentUser.fullName.substring(0, 1).toUpperCase()}</span>
                        </c:otherwise>
                    </c:choose>
                </div>
                <h2>${currentUser.fullName}</h2>
                <p class="profile-email">${currentUser.email}</p>
                <p class="profile-joined">
                    <span>📅</span>
                    Member since <fmt:formatDate value="${currentUser.createdAt}" pattern="MMMM dd, yyyy"/>
                </p>
            </section>

            <!-- Picture Upload Section -->
            <section class="profile-form-section">
                <div class="form-card">
                    <h3><span class="form-icon">🖼️</span> Profile Picture</h3>

                    <c:if test="${not empty picError}">
                        <div class="alert alert-error"><span class="alert-icon">!</span>${picError}</div>
                    </c:if>

                    <!-- Upload your own -->
                    <form action="profile" method="post" enctype="multipart/form-data" class="profile-form">
                        <input type="hidden" name="action" value="uploadPicture"/>
                        <div class="form-group">
                            <label for="profilePicture">Upload Your Photo <span class="hint">(JPG, PNG, GIF — max 5 MB)</span></label>
                            <div class="upload-row">
                                <input type="file" id="profilePicture" name="profilePicture" accept="image/*" class="file-input"/>
                                <button type="submit" class="btn btn-primary">Upload</button>
                            </div>
                        </div>
                    </form>

                    <!-- Sample avatars -->
                    <div class="sample-avatars">
                        <p class="sample-label">Or choose a sample avatar:</p>
                        <div class="sample-grid">
                            <form action="profile" method="post">
                                <input type="hidden" name="action" value="selectSample"/>
                                <input type="hidden" name="sample" value="images/samples/avatar1.svg"/>
                                <button type="submit" class="sample-btn ${currentUser.profilePicture == 'images/samples/avatar1.svg' ? 'sample-active' : ''}">
                                    <img src="images/samples/avatar1.svg" alt="Avatar 1"/>
                                    <span>Blue</span>
                                </button>
                            </form>
                            <form action="profile" method="post">
                                <input type="hidden" name="action" value="selectSample"/>
                                <input type="hidden" name="sample" value="images/samples/avatar2.svg"/>
                                <button type="submit" class="sample-btn ${currentUser.profilePicture == 'images/samples/avatar2.svg' ? 'sample-active' : ''}">
                                    <img src="images/samples/avatar2.svg" alt="Avatar 2"/>
                                    <span>Green</span>
                                </button>
                            </form>
                            <form action="profile" method="post">
                                <input type="hidden" name="action" value="selectSample"/>
                                <input type="hidden" name="sample" value="images/samples/avatar3.svg"/>
                                <button type="submit" class="sample-btn ${currentUser.profilePicture == 'images/samples/avatar3.svg' ? 'sample-active' : ''}">
                                    <img src="images/samples/avatar3.svg" alt="Avatar 3"/>
                                    <span>Yellow</span>
                                </button>
                            </form>
                        </div>
                    </div>
                </div>
            </section>
            
            <!-- Messages -->
            <c:if test="${not empty success}">
                <div class="alert alert-success">
                    <span class="alert-icon">✓</span>
                    ${success}
                </div>
            </c:if>
            
            <c:if test="${not empty error}">
                <div class="alert alert-error">
                    <span class="alert-icon">!</span>
                    ${error}
                </div>
            </c:if>
            
            <!-- Edit Profile Form -->
            <section class="profile-form-section">
                <div class="form-card">
                    <h3>
                        <span class="form-icon">✏️</span>
                        Edit Profile
                    </h3>
                    
                    <form action="profile" method="post" class="profile-form" id="profileForm">
                        <!-- Full Name -->
                        <div class="form-group">
                            <label for="fullName">Full Name <span class="required">*</span></label>
                            <div class="input-wrapper">
                                <span class="input-icon">👤</span>
                                <input 
                                    type="text" 
                                    id="fullName" 
                                    name="fullName" 
                                    placeholder="Enter your full name"
                                    value="${not empty fullName ? fullName : currentUser.fullName}"
                                    required
                                    minlength="2"
                                    maxlength="100"
                                >
                            </div>
                        </div>
                        
                        <!-- Email (Read-only) -->
                        <div class="form-group">
                            <label for="email">Email Address</label>
                            <div class="input-wrapper input-disabled">
                                <span class="input-icon">📧</span>
                                <input 
                                    type="email" 
                                    id="email" 
                                    value="${currentUser.email}"
                                    disabled
                                >
                                <span class="input-hint">Email cannot be changed</span>
                            </div>
                        </div>
                        
                        <!-- College -->
                        <div class="form-group">
                            <label for="college">College/University <span class="required">*</span></label>
                            <div class="input-wrapper">
                                <span class="input-icon">🏫</span>
                                <input 
                                    type="text" 
                                    id="college" 
                                    name="college" 
                                    placeholder="Enter your college name"
                                    value="${not empty college ? college : currentUser.college}"
                                    required
                                    maxlength="150"
                                >
                            </div>
                        </div>
                        
                        <!-- Pincode -->
                        <div class="form-group">
                            <label for="pincode">Pincode <span class="required">*</span></label>
                            <div class="input-wrapper">
                                <span class="input-icon">📍</span>
                                <input 
                                    type="text" 
                                    id="pincode" 
                                    name="pincode" 
                                    placeholder="Enter 6-digit pincode"
                                    value="${not empty pincode ? pincode : currentUser.pincode}"
                                    required
                                    pattern="[0-9]{6}"
                                    maxlength="6"
                                >
                            </div>
                        </div>
                        
                        <!-- Gender -->
                        <div class="form-group">
                            <label>Gender</label>
                            <div class="gender-options">
                                <label class="radio-label">
                                    <input type="radio" name="gender" value="Male" 
                                        ${(not empty gender ? gender : currentUser.gender) == 'Male' ? 'checked' : ''}>
                                    <span class="radio-custom"></span>
                                    <span class="radio-text">Male</span>
                                </label>
                                <label class="radio-label">
                                    <input type="radio" name="gender" value="Female"
                                        ${(not empty gender ? gender : currentUser.gender) == 'Female' ? 'checked' : ''}>
                                    <span class="radio-custom"></span>
                                    <span class="radio-text">Female</span>
                                </label>
                                <label class="radio-label">
                                    <input type="radio" name="gender" value="Other"
                                        ${(not empty gender ? gender : currentUser.gender) == 'Other' ? 'checked' : ''}>
                                    <span class="radio-custom"></span>
                                    <span class="radio-text">Other</span>
                                </label>
                            </div>
                        </div>
                        
                        <div class="form-actions">
                            <button type="submit" class="btn btn-primary">
                                <span>Save Changes</span>
                                <span class="btn-icon">💾</span>
                            </button>
                            <a href="dashboard" class="btn btn-outline">Cancel</a>
                        </div>
                    </form>
                </div>
            </section>

            <section class="profile-form-section">
                <div class="profile-ext-section">
                    <h3>✨ Public Profile</h3>
                    <form action="profile" method="post">
                        <input type="hidden" name="action" value="updateExtProfile">
                        <div class="form-group">
                            <label for="bio">Bio</label>
                            <textarea id="bio" name="bio" placeholder="Tell others a little about yourself...">${userProfile.bio}</textarea>
                        </div>
                        <div class="form-group">
                            <label for="interests">Interests</label>
                            <input type="text" id="interests" name="interests" value="${userProfile.interests}" placeholder="Coding, Music, Football, Design">
                        </div>
                        <div class="form-group">
                            <label for="instagram">Instagram Username</label>
                            <input type="text" id="instagram" name="instagram" value="${userProfile.instagram}" placeholder="yourhandle">
                        </div>
                        <div class="form-actions">
                            <button type="submit" class="btn btn-primary">Save Public Profile</button>
                        </div>
                    </form>
                </div>
            </section>

            <section class="profile-form-section">
                <div class="photo-gallery-section">
                    <h3>📷 Photo Gallery</h3>
                    <c:choose>
                        <c:when test="${not empty photos}">
                            <div class="photo-gallery-grid" id="photoGalleryGrid">
                                <c:forEach var="photo" items="${photos}">
                                    <a href="${photo.photoUrl}" target="_blank" class="photo-gallery-item">
                                        <img src="${photo.photoUrl}" alt="Gallery photo" loading="lazy">
                                    </a>
                                </c:forEach>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <p class="vp-empty-text" id="photoGalleryEmpty">No photos uploaded yet.</p>
                            <div class="photo-gallery-grid" id="photoGalleryGrid" style="display:none"></div>
                        </c:otherwise>
                    </c:choose>

                    <div class="photo-upload-area">
                        <label class="photo-upload-label" for="galleryPhotoInput">
                            <span>➕</span>
                            <span>Upload Photo</span>
                            <input type="file" id="galleryPhotoInput" accept="image/*">
                        </label>
                        <span class="photo-upload-status" id="photoUploadStatus">JPG, PNG, GIF, WEBP up to 5 MB</span>
                    </div>
                </div>
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

    document.getElementById('galleryPhotoInput').addEventListener('change', function(event) {
        var file = event.target.files[0];
        if (!file) {
            return;
        }

        var status = document.getElementById('photoUploadStatus');
        status.textContent = 'Uploading...';

        var formData = new FormData();
        formData.append('photo', file);

        fetch('upload-photo', {
            method: 'POST',
            body: formData
        })
        .then(function(response) { return response.json(); })
        .then(function(data) {
            if (!data.success) {
                status.textContent = data.error || 'Upload failed';
                return;
            }

            var grid = document.getElementById('photoGalleryGrid');
            var empty = document.getElementById('photoGalleryEmpty');
            if (empty) {
                empty.style.display = 'none';
            }
            grid.style.display = 'grid';

            var anchor = document.createElement('a');
            anchor.href = data.url;
            anchor.target = '_blank';
            anchor.className = 'photo-gallery-item';

            var img = document.createElement('img');
            img.src = data.url;
            img.alt = 'Gallery photo';
            img.loading = 'lazy';
            anchor.appendChild(img);
            grid.insertBefore(anchor, grid.firstChild);

            status.textContent = 'Photo uploaded successfully.';
            event.target.value = '';
        })
        .catch(function() {
            status.textContent = 'Upload failed';
        });
    });
    </script>
</body>
</html>
