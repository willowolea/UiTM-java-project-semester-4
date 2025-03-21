/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package rr.controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.net.URLEncoder;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.enterprise.inject.New;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import rr.beans.Application;

/**
 *
 * @author User
 */
public class applicationController extends HttpServlet {
    
    // Database credentials
    private static final String URL = "jdbc:oracle:thin:@localhost:1521:XE"; // Oracle database URL
    private static final String USERNAME = "MYCONNECTION"; // Database username
    private static final String PASSWORD = "system"; // Database password

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, ClassNotFoundException, SQLException {
        response.setContentType("text/html;charset=UTF-8");
        
        List<Application> application_list = new ArrayList<>();
        
        try (PrintWriter out = response.getWriter()) {
            Application application = new Application();
            
            application.setApplicationId(request.getParameter("applicationID"));
            application.setTitle(request.getParameter("applicationTitle"));
            application.setLocation(request.getParameter("location"));
            application.setDescription(request.getParameter("applicationDesc"));
            application.setStatus(request.getParameter("applicationStatus"));
            application.setDateOpen(request.getParameter("applicationDate"));
            
            application_list.add(application);
            
//            String applicationID = request.getParameter("applicationID");
//            String title = request.getParameter("applicationTitle");
//            String location = request.getParameter("location");
//            String applicationDesc = request.getParameter("applicationDesc");
//            String applicationDate = request.getParameter("applicationDate");
//            String status = request.getParameter("applicationStatus");
            
            if (application.getTitle() == null || application.getLocation() == null || application.getDescription() == null || application.getDateOpen() == null || application.getStatus() == null) {
                request.setAttribute("errorMessage", "Missing required parameters.");
                request.getRequestDispatcher("/addApplication.jsp").forward(request, response);
                return;
            }
            Class.forName("oracle.jdbc.OracleDriver");
            
            try (Connection conn = DriverManager.getConnection(URL, USERNAME, PASSWORD)) {
                String action = request.getParameter("action");
                
                if("Add".equalsIgnoreCase(action)) {
                    String insertSql = "INSERT INTO Application_Details (applicationID, serviceID, applicationDesc, applicationDate, applicationStatus, applicationTitle) VALUES " +
                            "(?, ?, ?, ?, ?, ?)";
                    try(PreparedStatement stmt = conn.prepareStatement(insertSql)) {
                        stmt.setString(1, application.getApplicationId());
                        stmt.setString(2, application.getLocation());
                        stmt.setString(3, application.getDescription());
                        stmt.setString(5, application.getStatus());
                        stmt.setString(6, application.getTitle());
                        
                        java.sql.Date sqlDate = java.sql.Date.valueOf(application.getDateOpen());
                        stmt.setDate(4, sqlDate);
                        
                        System.out.println("Executing query: " + stmt);
                        int result = stmt.executeUpdate();
                        if (result > 0) {
                            request.getSession().setAttribute("popupMessage", "New application added successfully.");
                            response.sendRedirect("applicationDetails.jsp?popupMessage=" + URLEncoder.encode("New application added successfully.", "UTF-8"));
                        } else {
                            request.setAttribute("message", "Failed to add application.");
                            request.getRequestDispatcher("/addApplication.jsp").forward(request, response);
                        }
                    } catch (SQLException ex) {
                        System.err.println("SQL Error Code: " + ex.getErrorCode());
                        System.err.println("SQL State: " + ex.getSQLState());
                        System.err.println("Error Message: " + ex.getMessage());
                        ex.printStackTrace();
                        request.setAttribute("message", "Error occurred during insert operation: " + ex.getMessage());
                        request.getRequestDispatcher("/addApplication.jsp").forward(request, response);                  
                    }
                } else if ("Update".equalsIgnoreCase(action)) {
                    String updateSql = "UPDATE Application_Details SET serviceID = ?, applicationDesc = ?, applicationDate = ?, applicationStatus = ?, applicationTitle = ? WHERE applicationID = ?";
                    
                    try (PreparedStatement stmt = conn.prepareStatement(updateSql)) {
                        if (application.getApplicationId() == null || application.getApplicationId().isEmpty()) {
                            request.setAttribute("message", "Application ID is required.");
                            request.getRequestDispatcher("/updateApplication.jsp").forward(request, response);
                            return;
                        }

                        java.sql.Date sqlDate = java.sql.Date.valueOf(application.getDateOpen());
                        
                        stmt.setString(1, application.getLocation());           // serviceID
                        stmt.setString(2, application.getDescription());    // applicationDesc
                        stmt.setDate(3, sqlDate);              // applicationDate
                        stmt.setString(4, application.getStatus());             // applicationStatus
                        stmt.setString(5, application.getTitle());              // applicationTitle
                        stmt.setString(6, application.getApplicationId());      // applicationID (this is for the WHERE clause)

                        // Log SQL statement for debugging
                        System.out.println("Executing update query: " + stmt.toString());

                        int result = stmt.executeUpdate();
                        System.out.println("Update result: " + result);

                        // Avoid printing to response before redirect
                        if (result > 0) {
                            // Set session message before redirect
                            request.getSession().setAttribute("popupMessage", "Application updated successfully.");
                            request.getRequestDispatcher("applicationDetails.jsp").forward(request, response);
                        } else {
                            // If no update occurred, forward the request with an error message
                            request.setAttribute("message", "Failed to update application.");
                            request.getRequestDispatcher("/updateApplication.jsp").forward(request, response);
                        }
                    } catch (SQLException ex) {
                        System.err.println("SQL error during update operation: " + ex.getMessage());
                        ex.printStackTrace();
                        request.setAttribute("message", "Error occurred during update operation.");
                        // Forward the request in case of an error, but make sure response is not committed yet
                        request.getRequestDispatcher("/updateApplication.jsp").forward(request, response);
                    }
                } else {
                    request.setAttribute("message", "Invalid action parameter.");
                    request.getRequestDispatcher("/applicationDetails.jsp").forward(request, response);
                }
            } catch (SQLException ex) {
                ex.printStackTrace();  // Log the detailed exception
                out.println("Error connecting to the database: " + ex.getMessage());
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error occurred.");
            }
            }
        }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            processRequest(request, response);
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(applicationController.class.getName()).log(Level.SEVERE, null, ex);
        } catch (SQLException ex) {
            Logger.getLogger(applicationController.class.getName()).log(Level.SEVERE, null, ex);
        }

        
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            processRequest(request, response);
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(applicationController.class.getName()).log(Level.SEVERE, null, ex);
        } catch (SQLException ex) {
            Logger.getLogger(applicationController.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
