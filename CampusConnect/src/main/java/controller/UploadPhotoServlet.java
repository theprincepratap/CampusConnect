package controller;

import dao.PhotoDAO;
import model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.UUID;

/**
 * UploadPhotoServlet – POST /upload-photo
 * Accepts a multipart file, saves it to /uploads/, stores path in DB.
 * Returns JSON: {"success": true, "url": "uploads/filename.jpg"} or {"success": false, "error": "..."}
 */
@MultipartConfig(maxFileSize = 5 * 1024 * 1024, maxRequestSize = 5 * 1024 * 1024)
public class UploadPhotoServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private PhotoDAO photoDAO;

    private static final long MAX_FILE_SIZE = 5 * 1024 * 1024; // 5 MB

    @Override
    public void init() throws ServletException {
        photoDAO = new PhotoDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            out.print("{\"success\":false,\"error\":\"Not authenticated\"}");
            return;
        }

        User user = (User) session.getAttribute("user");

        Part filePart;
        try {
            filePart = request.getPart("photo");
        } catch (Exception e) {
            out.print("{\"success\":false,\"error\":\"No file part\"}");
            return;
        }

        if (filePart == null || filePart.getSize() == 0) {
            out.print("{\"success\":false,\"error\":\"No file selected\"}");
            return;
        }

        if (filePart.getSize() > MAX_FILE_SIZE) {
            out.print("{\"success\":false,\"error\":\"File too large (max 5 MB)\"}");
            return;
        }

        // Validate MIME type (accept only images)
        String contentType = filePart.getContentType();
        if (contentType == null || !contentType.startsWith("image/")) {
            out.print("{\"success\":false,\"error\":\"Only image files are allowed\"}");
            return;
        }

        // Derive safe extension from content type
        String ext = ".jpg";
        if (contentType.contains("png"))  ext = ".png";
        else if (contentType.contains("gif")) ext = ".gif";
        else if (contentType.contains("webp")) ext = ".webp";

        String fileName = "photo_" + user.getId() + "_" + UUID.randomUUID().toString().replace("-", "") + ext;

        // Resolve uploads directory on the filesystem
        String uploadsDir = getServletContext().getRealPath("/uploads");
        File dir = new File(uploadsDir);
        if (!dir.exists()) {
            dir.mkdirs();
        }

        String filePath = uploadsDir + File.separator + fileName;
        try (InputStream inputStream = filePart.getInputStream()) {
            Files.copy(inputStream, Paths.get(filePath), StandardCopyOption.REPLACE_EXISTING);
        }

        String photoUrl = "uploads/" + fileName;
        boolean saved = photoDAO.addPhoto(user.getId(), photoUrl);

        if (saved) {
            out.print("{\"success\":true,\"url\":\"" + escapeJson(photoUrl) + "\"}");
        } else {
            // Clean up orphaned file
            new File(filePath).delete();
            out.print("{\"success\":false,\"error\":\"Database error\"}");
        }
    }

    private String escapeJson(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\").replace("\"", "\\\"");
    }
}
