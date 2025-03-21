package rr.controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class deleteServlet extends HttpServlet {

    // Database connection settings (adjust to your own configuration)
    private static final String DB_URL = "jdbc:oracle:thin:@localhost:1521:XE";
    private static final String DB_USER = "MYCONNECTION";
    private static final String DB_PASSWORD = "system";

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, ClassNotFoundException {
        
        response.setContentType("text/html;charset=UTF-8");
        
        // Retrieving parameters from the request
        String table = request.getParameter("table");
        String primaryKey = request.getParameter("primarykey");
        String exprimKey = request.getParameter("exprimkey");

        Class.forName("oracle.jdbc.OracleDriver");

        // PrintWriter to write response
        try (PrintWriter out = response.getWriter()) {
            // Validate parameters
            if (table == null || primaryKey == null || exprimKey == null) {
                out.println("<script>alert('Invalid parameters');</script>");
                out.println("<script>window.history.back();</script>");
                return;
            }
            
            // Database connection and deletion logic
            Connection conn = null;
            PreparedStatement stmt = null;
            try {
                // Establish database connection
                conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);

                // Prepare the delete SQL statement
                String sql = "DELETE FROM " + table + " WHERE " + primaryKey + " = ?";
                stmt = conn.prepareStatement(sql);
                stmt.setString(1, exprimKey); // Set the value of the primary key to delete

                // Execute the delete operation
                int rowsAffected = stmt.executeUpdate();

                if (rowsAffected > 0) {
                    out.println("<script>alert('Data has been deleted');</script>");
                    out.println("<script>window.location.href = document.referrer;</script>");
                } else {
                    out.println("<script>alert('Data failed to be deleted');</script>");
                    out.println("<script>window.history.back();</script>");
                }
            } catch (SQLException e) {
                out.println("<script>alert('Error occurred: " + e.getMessage() + "');</script>");
                out.println("<script>window.history.back();</script>");
            } finally {
                try {
                    if (stmt != null) stmt.close();
                    if (conn != null) conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            processRequest(request, response);
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(deleteServlet.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            processRequest(request, response);
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(deleteServlet.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    @Override
    public String getServletInfo() {
        return "Short description of the delete servlet";
    }
}
