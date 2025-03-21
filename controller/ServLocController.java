package rr.controller;

import java.io.IOException;
import java.io.InputStream;
import java.sql.*;
import java.util.Collection;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

@MultipartConfig
public class ServLocController extends HttpServlet {

    private static final String DB_URL = "jdbc:oracle:thin:@localhost:1521:XE";
    private static final String DB_USER = "MYCONNECTION";
    private static final String DB_PASSWORD = "system";

    // Helper method to parse integer safely
    private int parseInteger(String value, int defaultValue) {
        try {
            return value != null && !value.isEmpty() ? Integer.parseInt(value) : defaultValue;
        } catch (NumberFormatException e) {
            return defaultValue;
        }
    }

    // Main request handler
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        // Retrieve form data
        String locationID = request.getParameter("location-id");
        String coordinatorID = request.getParameter("coordinator-id");
        String stateID = request.getParameter("state-id");
        String address = request.getParameter("address");
        String jobDescription = request.getParameter("job-description");
        String status = request.getParameter("status-id");
        
        String totalCapacityParam = request.getParameter("total-capacity");
        String volunteerNumberParam = request.getParameter("volunteer-number");

        int totalCapacity = 0;
        int volunteerNumber = 0;

        if (totalCapacityParam != null && !totalCapacityParam.isEmpty()) {
            totalCapacity = Integer.parseInt(totalCapacityParam);
        }

        if (volunteerNumberParam != null && !volunteerNumberParam.isEmpty()) {
            volunteerNumber = Integer.parseInt(volunteerNumberParam);
        }

        // Validate required fields
        if (locationID == null || coordinatorID == null || stateID == null || address == null) {
            setErrorAndRedirect(request, response, "Missing required fields.");
            return;
        }

        // Get the action parameter
        String action = request.getParameter("action");

        // Handle the action logic (e.g., "Add" or other operations)
        if ("Add".equalsIgnoreCase(action)) {
            handleAdd(request, response, locationID, coordinatorID, stateID, address, jobDescription, status, totalCapacity, volunteerNumber);
        } else if ("Update".equalsIgnoreCase(action)) {
            handleUpdate(request, response, locationID, coordinatorID, stateID, address, jobDescription, status, totalCapacity, volunteerNumber);
        } else {
            setErrorAndRedirect(request, response, "Unknown action.");
        }
    }

    // Handle the "Add" action
    private void handleAdd(HttpServletRequest request, HttpServletResponse response,
                           String locationID, String coordinatorID, String stateID, String address,
                           String jobDescription, String status, int totalCapacity, int volunteerNumber)
            throws ServletException, IOException {
        Collection<Part> parts = request.getParts(); // Get all parts in the request
        InputStream[] imageStreams = new InputStream[3];  // Array to store up to 3 image streams
        int imageIndex = 0;

        // Loop through all the parts and find image files
        for (Part part : parts) {
            if (part.getName().equals("serviceImg") && part.getSize() > 0) {
                if (imageIndex < 3) {  // Ensure that no more than 3 images are uploaded
                    imageStreams[imageIndex] = part.getInputStream();
                    imageIndex++;
                }
            }
        }

        try {
            // Connect to the database
            Class.forName("oracle.jdbc.OracleDriver");
            try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD)) {
                conn.setAutoCommit(false); // Disable auto-commit for transaction management
                
                // SQL query to insert the data into Service_Location table
                String sql = "INSERT INTO Service_Location (serviceID, coordinatorID, stateID, serviceAddress, totalCapacity, numOfVolunteer, jobDescription, serviceStatus, serviceImg1, serviceImg2, serviceImg3) "
                        + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

                try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                    // Set the non-image parameters
                    stmt.setString(1, locationID);
                    stmt.setString(2, coordinatorID);
                    stmt.setString(3, stateID);
                    stmt.setString(4, address);
                    stmt.setInt(5, totalCapacity);
                    stmt.setInt(6, volunteerNumber);
                    stmt.setString(7, jobDescription);
                    stmt.setString(8, status);

                    // Set the image parameters (if available)
                    for (int i = 0; i < 3; i++) {
                        if (imageStreams[i] != null) {
                            stmt.setBinaryStream(i + 9, imageStreams[i]);
                        } else {
                            stmt.setNull(i + 9, java.sql.Types.BLOB);
                        }
                    }

                    // Execute the query
                    int rowsAffected = stmt.executeUpdate();
                    if (rowsAffected > 0) {
                        conn.commit(); // Commit the transaction if successful
                        request.setAttribute("popupMessage", "Service Location added successfully.");
                        request.getRequestDispatcher("ServiceLocation.jsp").forward(request, response);
                    } else {
                        throw new SQLException("Failed to insert data. No rows affected.");
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            setErrorAndRedirect(request, response, "Error: " + e.getMessage());
        }
    }
    
    private void handleUpdate(HttpServletRequest request, HttpServletResponse response,
                           String locationID, String coordinatorID, String stateID, String address,
                           String jobDescription, String status, int totalCapacity, int volunteerNumber)
            throws ServletException, IOException {
        Collection<Part> parts = request.getParts(); // Get all parts in the request
        InputStream[] imageStreams = new InputStream[3];  // Array to store up to 3 image streams
        int imageIndex = 0;

        // Loop through all the parts and find image files
        for (Part part : parts) {
            if (part.getName().equals("serviceImg") && part.getSize() > 0) {
                if (imageIndex < 3) {  // Ensure that no more than 3 images are uploaded
                    imageStreams[imageIndex] = part.getInputStream();
                    imageIndex++;
                }
            }
        }

        try {
            // Connect to the database
            Class.forName("oracle.jdbc.OracleDriver");
            try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD)) {
                conn.setAutoCommit(false); // Disable auto-commit for transaction management

                // First, fetch the current image data to retain if no new image is provided
                String selectSql = "SELECT serviceImg1, serviceImg2, serviceImg3 FROM Service_Location WHERE serviceID = ?";
                try (PreparedStatement selectStmt = conn.prepareStatement(selectSql)) {
                    selectStmt.setString(1, locationID);

                    try (ResultSet rs = selectStmt.executeQuery()) {
                        if (rs.next()) {
                            // Set the existing images in case no new images are uploaded
                            if (imageStreams[0] == null) {
                                imageStreams[0] = rs.getBinaryStream("serviceImg1");
                            }
                            if (imageStreams[1] == null) {
                                imageStreams[1] = rs.getBinaryStream("serviceImg2");
                            }
                            if (imageStreams[2] == null) {
                                imageStreams[2] = rs.getBinaryStream("serviceImg3");
                            }
                        }
                    }
                }

                // SQL query to update the data in Service_Location table
                String sql = "UPDATE Service_Location SET coordinatorID = ?, stateID = ?, serviceAddress = ?, "
                        + "totalCapacity = ?, numOfVolunteer = ?, jobDescription = ?, serviceStatus = ?, "
                        + "serviceImg1 = ?, serviceImg2 = ?, serviceImg3 = ? WHERE serviceID = ?";

                try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                    // Set the non-image parameters
                    stmt.setString(1, coordinatorID);
                    stmt.setString(2, stateID);
                    stmt.setString(3, address);
                    stmt.setInt(4, totalCapacity);
                    stmt.setInt(5, volunteerNumber);
                    stmt.setString(6, jobDescription);
                    stmt.setString(7, status);

                    // Set the image parameters (if available)
                    for (int i = 0; i < 3; i++) {
                        if (imageStreams[i] != null) {
                            stmt.setBinaryStream(i + 8, imageStreams[i]);
                        } else {
                            stmt.setNull(i + 8, java.sql.Types.BLOB);
                        }
                    }

                    // Set the serviceID for the WHERE clause
                    stmt.setString(11, locationID);

                    // Execute the update query
                    int rowsAffected = stmt.executeUpdate();
                    if (rowsAffected > 0) {
                        conn.commit(); // Commit the transaction if successful
                        request.setAttribute("popupMessage", "Service Location updated successfully.");
                        request.getRequestDispatcher("ServiceLocation.jsp").forward(request, response);
                    } else {
                        throw new SQLException("Failed to update data. No rows affected.");
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            setErrorAndRedirect(request, response, "Error: " + e.getMessage());
        }
    }
    
    // Helper method to redirect with an error message
    private void setErrorAndRedirect(HttpServletRequest request, HttpServletResponse response, String message)
            throws ServletException, IOException {
        request.getSession().setAttribute("popupMessage", message);
        response.sendRedirect("addServiceLocation.jsp");
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
        return "Handles the service location form submission for adding service locations.";
    }
}
