package rr.controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

//@WebServlet(name = "volunteerAppController", urlPatterns = {"/volunteerAppController"})
public class volunteerAppController extends HttpServlet {

    // Database connection details
    private static final String DB_URL = "jdbc:oracle:thin:@localhost:1521:XE";
    private static final String DB_USER = "MYCONNECTION";
    private static final String DB_PASSWORD = "system";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get form parameters
        String formID = request.getParameter("formID");
        String approvalStatus = request.getParameter("approvalStatus");
        String coordinatorID = request.getParameter("coordinatorName"); // Contains coordinator ID

        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            // Establish database connection
            Class.forName("oracle.jdbc.driver.OracleDriver"); // Load Oracle JDBC driver
            conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);

            // Update query to process the form data
            String updateQuery = "UPDATE Volunteer_Form SET formStatus = ?, coordinatorID = ? WHERE formID = ?";
            stmt = conn.prepareStatement(updateQuery);

            // Set parameters for the query
            stmt.setString(1, approvalStatus); // Approval status
            stmt.setString(2, coordinatorID);  // Coordinator ID
            stmt.setString(3, formID);         // Form ID

            // Execute the update query
            int rowsUpdated = stmt.executeUpdate();

            // Check if the update was successful
            if (rowsUpdated > 0) {
                request.getSession().setAttribute("popupMessage", "Application approved successfully!");
                response.sendRedirect("applicationApproval.jsp");
            } else {
                request.getSession().setAttribute("popupMessage", "Failed to approve the application.");
                response.sendRedirect("applicationApproval.jsp");
            }

        } catch (ClassNotFoundException | SQLException e) {
            // Handle exceptions and log them
            e.printStackTrace();
            response.sendRedirect("applicationApproval.jsp?status=error");
        } finally {
            try {
                // Close database resources
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    @Override
    public String getServletInfo() {
        return "Servlet to handle volunteer application approval process";
    }
}
