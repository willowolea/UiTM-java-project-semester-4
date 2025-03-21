package rr.controller;

import rr.beans.Volunteer;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class volController extends HttpServlet {
    
    private String generateVolunteerID(Connection conn) throws SQLException {
        String lastID = null;
        String newID = "VL001"; // Default if no records exist
        
        String query = "SELECT VOLUNTEERID FROM (SELECT VOLUNTEERID FROM VOLUNTEER ORDER BY VOLUNTEERID DESC) WHERE ROWNUM = 1";
        try (PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                lastID = rs.getString("VOLUNTEERID");
                try {
                    int numericPart = Integer.parseInt(lastID.substring(2));
                    newID = "VL" + String.format("%03d", numericPart + 1);
                } catch (NumberFormatException e) {
                    Logger.getLogger(volController.class.getName()).log(Level.SEVERE, "Error parsing ID: " + lastID, e);
                }
            }
        }
        return newID;
    }

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        Connection con = null;
        
        try (PrintWriter out = response.getWriter()) {
            String action = request.getParameter("action");
            
            // Create Volunteer object and set its properties
            Volunteer volunteer = new Volunteer();
            
            volunteer.setFullname(request.getParameter("fullname"));
            volunteer.setAge(request.getParameter("age"));
            volunteer.setAddress(request.getParameter("address"));
            volunteer.setGender(request.getParameter("gender"));
            volunteer.setPassword(request.getParameter("password"));
            volunteer.setEmail(request.getParameter("email"));
            volunteer.setVolunteerNotel(request.getParameter("noTel"));
            
            System.out.println("Action received: " + action);
            
            try {
                con = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:XE", "MYCONNECTION", "system");
                
                if ("Add".equals(action)) {
                    String newID = generateVolunteerID(con);
                    volunteer.setVolunteerID(newID);
                    System.out.println("Generated ID: " + newID);
                    
                    String query = "INSERT INTO VOLUNTEER (volunteerID, fullname, age, address, gender, password, email, volunteerNotel) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
                    try (PreparedStatement stmt = con.prepareStatement(query)) {
                        stmt.setString(1, volunteer.getVolunteerID());
                        stmt.setString(2, volunteer.getFullname());
                        stmt.setString(3, volunteer.getAge());
                        stmt.setString(4, volunteer.getAddress());
                        stmt.setString(5, volunteer.getGender());
                        stmt.setString(6, volunteer.getPassword());
                        stmt.setString(7, volunteer.getEmail());
                        stmt.setString(8, volunteer.getVolunteerNotel());

                        int rowsInserted = stmt.executeUpdate();
                        if (rowsInserted > 0) {
                            response.sendRedirect("viewvolunteer.jsp");
                        } else {
                            request.getRequestDispatcher("addvolunteer.jsp").forward(request, response);
                        }
                    }
                } else if ("delete".equals(action)) {
                    String volunteerID = request.getParameter("id");
                    String query = "DELETE FROM Volunteer WHERE volunteerID = ?";
                    try (PreparedStatement stmt = con.prepareStatement(query)) {
                        stmt.setString(1, volunteerID);

                        int rowsDeleted = stmt.executeUpdate();
                        if (rowsDeleted > 0) {
                            request.setAttribute("popupMessage", "Data has been deleted");
                            request.getRequestDispatcher("viewvolunteer.jsp").forward(request, response);
                        } else {
                            request.setAttribute("popupMessage", "Data failed to be deleted");
                            request.getRequestDispatcher("viewvolunteer.jsp").forward(request, response);
                        }
                    }
                }
            } catch (SQLException e) {
                Logger.getLogger(volController.class.getName()).log(Level.SEVERE, "Database error", e);
                request.setAttribute("errorMessage", "Database error: " + e.getMessage());
                request.getRequestDispatcher("error.jsp").forward(request, response);
            } finally {
                try {
                    if (con != null && !con.isClosed()) {
                        con.close();
                    }
                } catch (SQLException e) {
                    Logger.getLogger(volController.class.getName()).log(Level.SEVERE, "Error closing connection", e);
                }
            }
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

    @Override
    public String getServletInfo() {
        return "Volunteer Controller Servlet";
    }
}