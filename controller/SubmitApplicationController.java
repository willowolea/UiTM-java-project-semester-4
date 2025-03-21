package rr.controller;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import rr.beans.Application;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.text.DecimalFormat;
import rr.beans.Volunteer;
import util.DBConnection;

//@WebServlet("/SubmitApplicationController")
public class SubmitApplicationController extends HttpServlet {

    static {
        try {
            Class.forName("oracle.jdbc.driver.OracleDriver");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
    }

    private static final String DB_URL = "jdbc:oracle:thin:@localhost:1521:xe";
    private static final String DB_USER = "MYCONNECTION";
    private static final String DB_PASSWORD = "system";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        String volunteerId = (String) session.getAttribute("volunteerId");

        if (volunteerId == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "User not logged in.");
            response.sendRedirect("LoginPage.jsp");
            return;
        }
        fetchApplications(request, response);
        //String volunteerId = "V001"; //hardcoded
//        fetchVolunteerData(volunteerId, request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String userID = (String) session.getAttribute("volunteerId");

        if (userID == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "User not logged in.");
            return;
        }

        String date = request.getParameter("date");
        String status = request.getParameter("status-name");
        String formID = generateFormID();
        String applicationId = request.getParameter("applicationId");

        java.sql.Date dateReceived;
        try {
            java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd");
            java.util.Date utilDate = sdf.parse(date);
            dateReceived = new java.sql.Date(utilDate.getTime());
        } catch (java.text.ParseException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid date format");
            return;
        }

        String sql = "INSERT INTO VOLUNTEER_FORM (formID, applicationID, volunteerID, coordinatorID, formStatus, formDate) "
                + "VALUES (?, ?, ?, '', ?, ?)";

        try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, formID);
            stmt.setString(2, applicationId);
            stmt.setString(3, userID);
            stmt.setString(4, status);
            stmt.setDate(5, dateReceived);

            int rowsAffected = stmt.executeUpdate();

            if (rowsAffected > 0) {
                // Redirect to userDashboard if the insert is successful
                response.sendRedirect("userDashboard?message=Form+submitted+successfully.");
            } else {
                // Handle failure scenario
                request.setAttribute("error", "Failed to submit application.");
                request.getRequestDispatcher("application.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error");
        }
    }


    
    private void fetchApplications(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
        List<Application> applications = new ArrayList<>();

        try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD)) {
            String sql = "SELECT applicationID, applicationTitle, sl.serviceAddress, applicationDesc, " +
                         "applicationStatus, TO_CHAR(applicationDate, 'DD-MM-YYYY') AS applicationDate " +
                         "FROM APPLICATION_DETAILS ad " +
                         "JOIN service_location sl ON ad.serviceid = sl.serviceid WHERE applicationStatus = 'Open' OR applicationStatus = 'Ongoing'ORDER BY applicationID ASC";

            try (PreparedStatement stmt = conn.prepareStatement(sql);
                 ResultSet rs = stmt.executeQuery()) {

                while (rs.next()) {
                    Application app = new Application();
                    app.setApplicationId(rs.getString("applicationID"));
                    app.setTitle(rs.getString("applicationTitle"));
                    app.setLocation(rs.getString("serviceAddress"));
                    app.setDescription(rs.getString("applicationDesc"));
                    app.setStatus(rs.getString("applicationStatus"));
                    app.setDateOpen(rs.getString("applicationDate"));
                    applications.add(app);

                    // Debug: Print fetched data
                    System.out.println("Fetched Application: " + app.getApplicationId() + ", " + app.getTitle());
                }
                System.out.println("Total Applications Fetched: " + applications.size());


                if (applications.isEmpty()) {
                    request.setAttribute("message", "No applications found.");
                }
                request.setAttribute("applications", applications);
                request.getRequestDispatcher("application.jsp").forward(request, response);

            }
        } catch (SQLException e) {
            request.setAttribute("message", "Database error: " + e.getMessage());
        }

        // Ensure forward happens only after setting data
        request.setAttribute("applications", applications);
    }

    
//    private void fetchVolunteerData(String volunteerId, HttpServletRequest request, HttpServletResponse response) 
//            throws ServletException, IOException {
//        List<Volunteer> volunteers = new ArrayList<>();
//        try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD)) {
//            
//            
//            // Let's add logging to see what's happening
//            System.out.println("Fetching data for volunteerId: " + volunteerId);
//            
//            String sql = "select volunteerID, fullName, volunteerNotel, age, gender, address from Volunteer WHERE volunteerID = ?";
//            
//            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
//                stmt.setString(1, volunteerId);
//                
//                try (ResultSet rs = stmt.executeQuery()) {
//                    if (rs.next()) {
//                        Volunteer vol = new Volunteer();
//                        vol.setId(rs.getString("volunteerid"));
//                        vol.setFullname(rs.getString("fullname"));
//                        vol.setNoTel(rs.getString("volunteernotel"));
//                        vol.setAge(rs.getString("age"));
//                        vol.setGender(rs.getString("gender"));
//                        vol.setAddress(rs.getString("address"));
//                        volunteers.add(vol);
//
//                        System.out.println("Fetched Volunteers: " + vol.getId() + ", " + vol.getFullname());
//                    }
//                    System.out.println("Total Applications Fetched: " + volunteers.size());
//
//                if (volunteers.isEmpty()) {
//                    request.setAttribute("message", "No applications found.");
//                }
//                request.setAttribute("volunteers", volunteers);
//                request.getRequestDispatcher("application.jsp").forward(request, response);
//                }
//            }
//        } catch (SQLException e) {
//            e.printStackTrace();
//            request.setAttribute("message", "Database error: " + e.getMessage());
//        }
//        // Ensure forward happens only after setting data
//        request.setAttribute("volunteers", volunteers);
//        
//    }
    
    private String generateFormID() {
        String newId = "FR001";

        try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD)) {
            String sql = "SELECT MAX(formid) AS max_id FROM volunteer_form";
            try (PreparedStatement ps = conn.prepareStatement(sql);
                 ResultSet rs = ps.executeQuery()) {
                if (rs.next() && rs.getString("max_id") != null) {
                    String lastID = rs.getString("max_id");
                    int numberPart = Integer.parseInt(lastID.substring(2));
                    newId = "FR" + String.format("%03d", numberPart + 1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return newId;
    }

}
