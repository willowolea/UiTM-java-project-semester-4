package rr.controller;

import rr.beans.CategoryBean;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class categoryController extends HttpServlet {
    // Database credentials
    private static final String URL = "jdbc:oracle:thin:@localhost:1521:XE";
    private static final String USERNAME = "MYCONNECTION";
    private static final String PASSWORD = "system";

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        
        // Create and populate CategoryBean with request parameters
        CategoryBean category = new CategoryBean();
        category.setCategoryId(request.getParameter("categoryID"));
        category.setCategoryName(request.getParameter("categoryName"));
        
        String action = request.getParameter("action");

        // Validate input parameters using the bean
        if (category.getCategoryId() == null || category.getCategoryName() == null || action == null) {
            request.setAttribute("message", "Error: Missing required parameters.");
            request.getRequestDispatcher("/addCategory.jsp").forward(request, response);
            return;
        }

        try {
            // Load the Oracle JDBC Driver
            Class.forName("oracle.jdbc.OracleDriver");

            // Establish database connection
            try (Connection conn = DriverManager.getConnection(URL, USERNAME, PASSWORD)) {
                if ("Add".equalsIgnoreCase(action)) {
                    if (addCategory(conn, category)) {
                        request.getSession().setAttribute("popupMessage2", "Category added successfully.");
                        response.sendRedirect("category.jsp");
                    } else {
                        request.setAttribute("message", "Failed to add category.");
                        request.getRequestDispatcher("/addCategory.jsp").forward(request, response);
                    }
                } else if ("Update".equalsIgnoreCase(action)) {
                    if (updateCategory(conn, category)) {
                        request.getSession().setAttribute("popupMessage2", "Category updated successfully.");
                        response.sendRedirect("category.jsp");
                    } else {
                        request.setAttribute("message", "Failed to update category.");
                        request.getRequestDispatcher("/updateCategory.jsp").forward(request, response);
                    }
                } else {
                    request.setAttribute("message", "Error: Invalid action parameter.");
                    request.getRequestDispatcher("/addCategory.jsp").forward(request, response);
                }
            }
        } catch (ClassNotFoundException ex) {
            request.setAttribute("message", "Error: Unable to load database driver.");
            request.getRequestDispatcher("/addCategory.jsp").forward(request, response);
        } catch (SQLException ex) {
            request.setAttribute("message", "Error: Database operation failed. " + ex.getMessage());
            request.getRequestDispatcher("/addCategory.jsp").forward(request, response);
        }
    }

    // Helper method to add a category
    private boolean addCategory(Connection conn, CategoryBean category) throws SQLException {
        String insertSQL = "INSERT INTO Category (categoryID, categoryName) VALUES (?, ?)";
        try (PreparedStatement stmt = conn.prepareStatement(insertSQL)) {
            stmt.setString(1, category.getCategoryId());
            stmt.setString(2, category.getCategoryName());
            return stmt.executeUpdate() > 0;
        }
    }

    // Helper method to update a category
    private boolean updateCategory(Connection conn, CategoryBean category) throws SQLException {
        String updateSQL = "UPDATE Category SET categoryName = ? WHERE categoryID = ?";
        try (PreparedStatement stmt = conn.prepareStatement(updateSQL)) {
            stmt.setString(1, category.getCategoryName());
            stmt.setString(2, category.getCategoryId());
            return stmt.executeUpdate() > 0;
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }
}