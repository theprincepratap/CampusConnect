<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Messages - CampusConnect</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="css/chat.css">
</head>
<body class="dashboard-page ${activeUser != null ? 'chat-has-active' : ''}">

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
            <a href="chat" class="nav-link active">
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
        <button class="mobile-menu-btn" onclick="toggleMobileMenu()">
            <span></span><span></span><span></span>
        </button>
    </div>
</header>
<div class="mobile-menu" id="mobileMenu">
    <a href="dashboard" class="mobile-link">🏠 Dashboard</a>
    <a href="chat" class="mobile-link active">💬 Messages</a>
    <a href="profile" class="mobile-link">👤 Profile</a>
    <a href="logout" class="mobile-link">🚪 Logout</a>
</div>

<!-- Chat Layout -->
<div class="chat-layout">

    <!-- LEFT: Conversation List -->
    <aside class="chat-sidebar" id="chatSidebar">
        <div class="chat-sidebar-header">
            <h2 class="chat-sidebar-title">
                <span>💬</span> Messages
            </h2>
        </div>
        <div class="chat-sidebar-body" id="conversationList">
            <c:choose>
                <c:when test="${empty conversations}">
                    <div class="chat-empty-conv">
                        <div style="font-size:48px;margin-bottom:12px">💬</div>
                        <p>No conversations yet.</p>
                        <a href="dashboard" class="btn btn-primary btn-sm mt-2">Find People</a>
                    </div>
                </c:when>
                <c:otherwise>
                    <c:forEach var="conv" items="${conversations}">
                        <a href="chat?with=${conv.otherUserId}"
                           class="conv-item ${activeUserId == conv.otherUserId ? 'conv-item--active' : ''}">
                            <div class="conv-avatar">
                                <c:choose>
                                    <c:when test="${not empty conv.otherUserProfilePic}">
                                        <img src="${conv.otherUserProfilePic}" alt="${conv.otherUserName}"/>
                                    </c:when>
                                    <c:otherwise>
                                        <span>${conv.otherUserName.substring(0,1).toUpperCase()}</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <div class="conv-info">
                                <div class="conv-name-row">
                                    <span class="conv-name">${conv.otherUserName}</span>
                                    <span class="conv-time">
                                        <c:if test="${conv.lastMessageTime != null}">
                                            <fmt:formatDate value="${conv.lastMessageTime}" pattern="HH:mm"/>
                                        </c:if>
                                    </span>
                                </div>
                                <div class="conv-preview-row">
                                    <span class="conv-preview">${conv.lastMessage}</span>
                                    <c:if test="${conv.unreadCount > 0}">
                                        <span class="conv-badge">${conv.unreadCount}</span>
                                    </c:if>
                                </div>
                            </div>
                        </a>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </div>
    </aside>

    <!-- RIGHT: Chat Window -->
    <main class="chat-main" id="chatMain">
        <c:choose>
            <c:when test="${activeUser != null}">

                <!-- Chat Header -->
                <div class="chat-header">
                    <button class="chat-back-btn d-lg-none" onclick="showSidebar()">←</button>
                    <div class="chat-header-avatar">
                        <c:choose>
                            <c:when test="${not empty activeUser.profilePicture}">
                                <img src="${activeUser.profilePicture}" alt="${activeUser.fullName}"/>
                            </c:when>
                            <c:otherwise>
                                <span>${activeUser.fullName.substring(0,1).toUpperCase()}</span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <div class="chat-header-info">
                        <h3 class="chat-header-name">${activeUser.fullName}</h3>
                        <span class="chat-header-college">${activeUser.college}</span>
                    </div>
                    <a href="view-profile?id=${activeUser.id}" class="btn btn-outline btn-sm chat-view-profile-btn">
                        View Profile
                    </a>
                </div>

                <!-- Messages Area -->
                <div class="chat-messages" id="chatMessages">
                    <c:forEach var="msg" items="${messages}">
                        <div class="msg-wrapper ${msg.senderId == currentUser.id ? 'msg-wrapper--out' : 'msg-wrapper--in'}">
                            <div class="msg-bubble ${msg.senderId == currentUser.id ? 'msg-bubble--out' : 'msg-bubble--in'}">
                                <span class="msg-text">${msg.message}</span>
                                <span class="msg-time">
                                    <fmt:formatDate value="${msg.createdAt}" pattern="HH:mm"/>
                                    <c:if test="${msg.senderId == currentUser.id}">
                                        <span class="msg-read-tick">${msg.read ? '✓✓' : '✓'}</span>
                                    </c:if>
                                </span>
                            </div>
                        </div>
                    </c:forEach>
                </div>

                <!-- Message Input -->
                <div class="chat-input-area">
                    <form class="chat-input-form" id="chatInputForm" onsubmit="sendMessage(event)">
                        <input type="hidden" id="receiverId" value="${activeUser.id}"/>
                        <input type="text" id="msgInput" class="chat-input"
                               placeholder="Type a message…" autocomplete="off" maxlength="2000"/>
                        <button type="submit" class="chat-send-btn" title="Send">
                            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" width="20" height="20">
                                <path d="M2.01 21L23 12 2.01 3 2 10l15 2-15 2z"/>
                            </svg>
                        </button>
                    </form>
                </div>

            </c:when>
            <c:otherwise>
                <!-- No active conversation selected -->
                <div class="chat-placeholder">
                    <div class="chat-placeholder-icon">💬</div>
                    <h3>Your Messages</h3>
                    <p>Select a conversation or go to the dashboard to start chatting with your classmates.</p>
                    <a href="dashboard" class="btn btn-primary mt-3">Find People</a>
                </div>
            </c:otherwise>
        </c:choose>
    </main>

</div><!-- /chat-layout -->

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
// ──────────────────────────────────────────────────────────
//  State
// ──────────────────────────────────────────────────────────
const CURRENT_USER_ID = ${currentUser.id};
const ACTIVE_USER_ID  = ${not empty activeUser ? activeUser.id : 'null'};
let lastMessageTs     = Date.now() - (5 * 60 * 1000); // start slightly in the past

// ──────────────────────────────────────────────────────────
//  On page load
// ──────────────────────────────────────────────────────────
document.addEventListener('DOMContentLoaded', function () {
    scrollToBottom();

    // Update lastMessageTs from last rendered message
    const msgs = document.querySelectorAll('.msg-bubble');
    if (msgs.length > 0) {
        // We use server-rendered messages on initial load; polling picks up new ones
        lastMessageTs = Date.now();
    }

    if (ACTIVE_USER_ID) {
        startPolling();
    }
    startUnreadBadgePolling();
});

// ──────────────────────────────────────────────────────────
//  Send message
// ──────────────────────────────────────────────────────────
function sendMessage(e) {
    e.preventDefault();
    const input = document.getElementById('msgInput');
    const msg   = input.value.trim();
    if (!msg) return;

    const receiverId = document.getElementById('receiverId').value;

    fetch('send-message', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: 'receiverId=' + encodeURIComponent(receiverId) + '&message=' + encodeURIComponent(msg)
    })
    .then(r => r.json())
    .then(data => {
        if (data.success) {
            input.value = '';
            // Immediately show outgoing message and poll
            appendMessage({
                senderId: CURRENT_USER_ID,
                message:  msg,
                createdAtStr: currentTime(),
                isRead: false
            });
            scrollToBottom();
            lastMessageTs = Date.now() - 500;
        }
    })
    .catch(err => console.error('Send error:', err));
}

// ──────────────────────────────────────────────────────────
//  AJAX Polling (every 2 s)
// ──────────────────────────────────────────────────────────
function startPolling() {
    setInterval(fetchNewMessages, 2000);
}

function fetchNewMessages() {
    if (!ACTIVE_USER_ID) return;
    fetch('get-messages?with=' + ACTIVE_USER_ID + '&since=' + lastMessageTs)
        .then(r => r.json())
        .then(messages => {
            if (messages.length > 0) {
                messages.forEach(m => {
                    // Skip messages we just sent (already appended optimistically)
                    if (m.senderId !== CURRENT_USER_ID) {
                        appendMessage(m);
                    }
                    if (m.createdAt > lastMessageTs) {
                        lastMessageTs = m.createdAt + 1;
                    }
                });
                scrollToBottom();
            }
        })
        .catch(err => console.error('Poll error:', err));
}

// ──────────────────────────────────────────────────────────
//  Append a message bubble to the DOM
// ──────────────────────────────────────────────────────────
function appendMessage(m) {
    const container = document.getElementById('chatMessages');
    const isOut = (m.senderId === CURRENT_USER_ID);
    const tick  = isOut ? (m.isRead ? ' <span class="msg-read-tick">✓✓</span>' : ' <span class="msg-read-tick">✓</span>') : '';

    const div = document.createElement('div');
    div.className = 'msg-wrapper ' + (isOut ? 'msg-wrapper--out' : 'msg-wrapper--in');
    div.innerHTML =
        '<div class="msg-bubble ' + (isOut ? 'msg-bubble--out' : 'msg-bubble--in') + '">' +
            '<span class="msg-text">' + escapeHtml(m.message) + '</span>' +
            '<span class="msg-time">' + (m.createdAtStr || currentTime()) + tick + '</span>' +
        '</div>';
    container.appendChild(div);
}

function escapeHtml(str) {
    return String(str)
        .replace(/&/g, '&amp;')
        .replace(/</g, '&lt;')
        .replace(/>/g, '&gt;')
        .replace(/"/g, '&quot;');
}

function scrollToBottom() {
    const c = document.getElementById('chatMessages');
    if (c) c.scrollTop = c.scrollHeight;
}

function currentTime() {
    const d = new Date();
    return d.getHours().toString().padStart(2,'0') + ':' + d.getMinutes().toString().padStart(2,'0');
}

// ──────────────────────────────────────────────────────────
//  Navbar unread badge (every 5 s)
// ──────────────────────────────────────────────────────────
function startUnreadBadgePolling() {
    updateUnreadBadge();
    setInterval(updateUnreadBadge, 5000);
}

function updateUnreadBadge() {
    fetch('unread-count')
        .then(r => r.json())
        .then(data => {
            const badge = document.getElementById('navUnreadBadge');
            if (!badge) return;
            if (data.count > 0) {
                badge.textContent = data.count > 99 ? '99+' : data.count;
                badge.style.display = 'inline-flex';
            } else {
                badge.style.display = 'none';
            }
        })
        .catch(() => {});
}

// ──────────────────────────────────────────────────────────
//  Mobile responsive helpers
// ──────────────────────────────────────────────────────────
function showSidebar() {
    document.getElementById('chatSidebar').classList.add('chat-sidebar--visible');
    document.getElementById('chatMain').classList.add('chat-main--hidden');
}
function toggleMobileMenu() {
    document.getElementById('mobileMenu').classList.toggle('active');
}
</script>
</body>
</html>
