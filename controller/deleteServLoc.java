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

@WebServlet("/DeleteServiceLocationServlet")
public class deleteServLoc extends HttpServlet {

    private static final String DB_URL = "jdbc:oracle:thin:@localhost:1521:XE";
    private static final String DB_USER = "MYCONNECTION";
    private static final String DB_PASSWORD = "system";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        PrintWriter out = response.getWriter();

        String serviceID = request.getParameter("serviceID");

        if (serviceID == null || serviceID.isEmpty()) {
            response.sendRedirect("ServiceLocation.jsp?error=Invalid+Service+ID");
            return;
        }

        try {
            // Connect to the database
            Class.forName("oracle.jdbc.OracleDriver");
            try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD)) {
                String sql = "DELETE FROM Service_Location WHERE serviceID = ?";
                try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                    stmt.setString(1, serviceID);
                    int rowsAffected = stmt.executeUpdate();

                    if (rowsAffected > 0) {
                        // Alert the user and then redirect to ServiceLocation.jsp
                        out.println("<script>");
                        out.println("alert('Service Location has been deleted successfully!');");
                        out.println("window.location.href = 'ServiceLocation.jsp';");
                        out.println("</script>");
                    } else {
                        // Show an error alert and redirect back
                        out.println("<script>");
                        out.println("alert('Failed to delete Service Location. Please try again.');");
                        out.println("window.location.href = 'ServiceLocation.jsp';");
                        out.println("</script>");
                    }

                }
            }
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
            response.sendRedirect("ServiceLocation.jsp?error=" + e.getMessage());
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
