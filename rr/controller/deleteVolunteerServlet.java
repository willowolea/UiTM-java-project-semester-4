package rr.controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class deleteVolunteerServlet extends HttpServlet {

    private static final String DB_URL = "jdbc:oracle:thin:@localhost:1521:XE";
    private static final String DB_USER = "MYCONNECTION";
    private static final String DB_PASSWORD = "system";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        PrintWriter out = response.getWriter();

        String volunteerID = request.getParameter("volunteerID");

        if (volunteerID == null || volunteerID.isEmpty()) {
            response.sendRedirect("viewvolunteer.jsp?error=Invalid+Volunteer+ID");
            return;
        }

        try {
            // Connect to the database
            Class.forName("oracle.jdbc.OracleDriver");
            try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD)) {
                conn.setAutoCommit(false); // Enable transaction management

                // Check if there are child records in the PRODUCT table
                String checkProductQuery = "SELECT COUNT(*) AS productCount FROM PRODUCT WHERE volunteerID = ?";
                try (PreparedStatement checkProductStmt = conn.prepareStatement(checkProductQuery)) {
                    checkProductStmt.setString(1, volunteerID);
                    try (ResultSet rsProduct = checkProductStmt.executeQuery()) {
                        if (rsProduct.next() && rsProduct.getInt("productCount") > 0) {
                            out.println("<script>");
                            out.println("alert('Cannot delete volunteer. Related products exist.');");
                            out.println("window.location.href = 'viewvolunteer.jsp';");
                            out.println("</script>");
                            return;
                        }
                    }
                }

                // Check if there are child records in the volunteer_form table
                String checkFormQuery = "SELECT COUNT(*) AS formCount FROM Volunteer_Form WHERE volunteerID = ?";
                try (PreparedStatement checkFormStmt = conn.prepareStatement(checkFormQuery)) {
                    checkFormStmt.setString(1, volunteerID);
                    try (ResultSet rsForm = checkFormStmt.executeQuery()) {
                        if (rsForm.next() && rsForm.getInt("formCount") > 0) {
                            out.println("<script>");
                            out.println("alert('Cannot delete volunteer. Related forms exist.');");
                            out.println("window.location.href = 'viewvolunteer.jsp';");
                            out.println("</script>");
                            return;
                        }
                    }
                }

                // Proceed to delete the volunteer
                String deleteQuery = "DELETE FROM Volunteer WHERE volunteerID = ?";
                try (PreparedStatement deleteStmt = conn.prepareStatement(deleteQuery)) {
                    deleteStmt.setString(1, volunteerID);
                    int rowsAffected = deleteStmt.executeUpdate();

                    if (rowsAffected > 0) {
                        conn.commit(); // Commit transaction
                        out.println("<script>");
                        out.println("alert('Volunteer has been deleted successfully!');");
                        out.println("window.location.href = 'viewvolunteer.jsp';");
                        out.println("</script>");
                    } else {
                        conn.rollback(); // Rollback transaction
                        out.println("<script>");
                        out.println("alert('Failed to delete Volunteer. Please try again.');");
                        out.println("window.location.href = 'viewvolunteer.jsp';");
                        out.println("</script>");
                    }
                }
            }
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
            response.sendRedirect("viewvolunteer.jsp?error=" + e.getMessage());
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
