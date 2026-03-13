<div align="center">

# 🎓 CampusConnect

### A modern college community platform built with Java Servlets, JSP, JDBC, and PostgreSQL

[![Java](https://img.shields.io/badge/Java-Servlets-orange?style=for-the-badge)](https://www.oracle.com/java/)
[![Tomcat](https://img.shields.io/badge/Apache-Tomcat%209-red?style=for-the-badge)](https://tomcat.apache.org/)
[![PostgreSQL](https://img.shields.io/badge/Database-PostgreSQL-blue?style=for-the-badge)](https://www.postgresql.org/)
[![JSP](https://img.shields.io/badge/View-JSP%20%2B%20JSTL-green?style=for-the-badge)](https://jakarta.ee/specifications/tags/)

</div>

---

## 📌 Overview

CampusConnect is a full-stack web application that helps students connect with peers from the same college, discover users by filters, manage profiles, and chat in near real-time.

It follows an MVC-style architecture:
- **Model**: Plain Java model classes (`User`, `Message`, `Conversation`, etc.)
- **View**: JSP + JSTL + CSS/JS
- **Controller**: Java Servlets
- **Data Layer**: JDBC DAO classes with PostgreSQL

---

## ✨ Features

- 🔐 Secure authentication (register/login/logout)
- 👤 Profile management + profile photo support
- 🏠 Dashboard with user discovery and filtering
- 💬 Chat system with conversations list and unread counts
- ⚡ Near real-time message updates via AJAX polling
- 📱 Responsive UI for desktop and mobile
- 🛡️ Input validation + prepared statements for query safety

---

## 🧱 Tech Stack

- **Backend**: Java (Servlet API)
- **Frontend**: JSP, JSTL, HTML5, CSS3, JavaScript
- **Database**: PostgreSQL
- **Server**: Apache Tomcat 9
- **Build/Deploy**: Windows batch scripts (`build.bat`, `deploy-java.bat`, `deploy-static.bat`)

---

## 📂 Project Structure

```text
CampusConnect/
├── src/main/java/
│   ├── controller/
│   │   ├── LoginServlet.java
│   │   ├── RegisterServlet.java
│   │   ├── DashboardServlet.java
│   │   ├── ProfileServlet.java
│   │   ├── LogoutServlet.java
│   │   ├── ConversationsServlet.java
│   │   ├── SendMessageServlet.java
│   │   ├── GetMessagesServlet.java
│   │   ├── UnreadCountServlet.java
│   │   ├── ViewProfileServlet.java
│   │   └── UploadPhotoServlet.java
│   ├── dao/
│   │   ├── DBConnection.java
│   │   ├── UserDAO.java
│   │   ├── MessageDAO.java
│   │   ├── ProfileDAO.java
│   │   └── PhotoDAO.java
│   └── model/
│       ├── User.java
│       ├── Message.java
│       ├── Conversation.java
│       ├── UserProfile.java
│       └── UserPhoto.java
├── src/main/webapp/
│   ├── *.jsp
│   ├── css/
│   ├── js/
│   └── WEB-INF/web.xml
├── database/
│   ├── setup.sql
│   └── messages_system.sql
├── lib/
├── build.bat
├── deploy-java.bat
└── deploy-static.bat
```

---

## ⚙️ Prerequisites

Before running the app, make sure you have:

1. **JDK** (Java 17+ recommended)
2. **Apache Tomcat 9.x**
3. **PostgreSQL** (local or remote)
4. Required JARs inside `CampusConnect/lib/`:
   - PostgreSQL JDBC driver (`postgresql-*.jar`)
   - JSTL (`jstl-*.jar`)
   - Servlet API if needed by your IDE setup

---

## 🗄️ Database Setup (PostgreSQL)

1. Create/open your PostgreSQL database.
2. Run scripts in this order:
   - `database/setup.sql`
   - `database/messages_system.sql`
3. Update DB credentials in:
   - `src/main/java/dao/DBConnection.java`

Example currently configured in project:

```java
private static final String JDBC_URL = "jdbc:postgresql://localhost:5432/campusconnect";
private static final String JDBC_USER = "postgres";
private static final String JDBC_PASSWORD = "admin";
```

> Change username/password according to your local PostgreSQL setup.

---

## 🚀 Run the Project

### Option A: Recommended (Windows)

```bat
cd CampusConnect
build.bat
```

This compiles Java classes and deploys files directly to Tomcat webapps folder.

Then start Tomcat:

```bat
cd ..\apache-tomcat-9.0.96\bin
startup.bat
```

Open in browser:

```text
http://localhost:8081/CampusConnect/
```

### Option B: Incremental Deploy

- After Java changes:
  ```bat
  deploy-java.bat
  ```
- After JSP/CSS/JS changes:
  ```bat
  deploy-static.bat
  ```

---

## 💬 Chat Connection Architecture (Technical)

- Chat uses **HTTP + AJAX polling** (not WebSocket).
- Client polls `/get-messages?with={id}&since={timestamp}` every 2 seconds.
- Send uses POST `/send-message`.
- Navbar unread badge polls `/unread-count` every 5 seconds.
- All endpoints validate authenticated user via `HttpSession`.
- Messages are persisted in PostgreSQL `messages` table and read status is updated (`is_read`).

---

## 🔒 Security Notes

- Password hashing implemented in DAO layer
- Prepared statements used to reduce SQL injection risk
- Session-based access control for protected routes
- Basic server-side validation for message and form inputs

---

## 🤝 Connect

<div align="center">

| Platform | Link |
|---|---|
| 📸 Instagram | [@itsprincepratap](https://www.instagram.com/itsprincepratap) |
| 🐙 GitHub | [@theprincepratap](https://github.com/theprincepratap) |
| 💼 LinkedIn | [thprincepratap](https://www.linkedin.com/in/thprincepratap/) |

</div>

---

## 💛 Support

If this project helped you, consider buying me a coffee:

**[💰 PayPal — paypal.me/theprincepratap](https://www.paypal.com/paypalme/theprincepratap)**

---

## 📄 License

This project is provided for educational and learning purposes.

---

<div align="center">

Made with ❤️ by Prince Pratap

</div>
