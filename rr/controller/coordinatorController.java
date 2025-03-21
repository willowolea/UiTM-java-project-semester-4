package rr.controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.sql.Connection;
import java.util.logging.Level;
import java.util.logging.Logger;
import rr.beans.Coordinator;

public class coordinatorController extends HttpServlet {

   private static final String URL = "jdbc:oracle:thin:@localhost:1521:XE"; 
   private static final String USERNAME = "MYCONNECTION";  
   private static final String PASSWORD = "system";

   protected void processRequest(HttpServletRequest request, HttpServletResponse response)
           throws ServletException, IOException, SQLException, ClassNotFoundException {
      response.setContentType("text/html;charset=UTF-8");
      
      
      try (PrintWriter out = response.getWriter()) {
         Coordinator cod = new Coordinator();
         
         cod.setCoordinatorID(request.getParameter("coordinatorID"));
         cod.setCoordinatorName(request.getParameter("coordinatorName"));
         cod.setCoordinatorNoTel(request.getParameter("coordinatorNo"));
         cod.setCoordinatorEmail(request.getParameter("coordinatorEmail"));
         cod.setPosition(request.getParameter("coordinatorPosition"));
         cod.setCoordinatorPass(request.getParameter("coordinatorPass"));
         
         
//         String co_id = request.getParameter("coordinatorID");
//         String co_name = request.getParameter("coordinatorName");
//         String co_num = request.getParameter("coordinatorNo");
//         String co_email = request.getParameter("coordinatorEmail");
//         String co_position = request.getParameter("coordinatorPosition");
//         String co_pass = request.getParameter("coordinatorPass");
      
         Class.forName("oracle.jdbc.OracleDriver");
         try (Connection conn = DriverManager.getConnection(URL, USERNAME, PASSWORD)) {
            if (conn == null) {
               throw new SQLException("Unable to establish database connection.");
            }
            
            String action = request.getParameter("action");
            
            // Register action
            if ("register".equalsIgnoreCase(action)) {
                if (cod.getCoordinatorName() == null || cod.getCoordinatorEmail() == null || cod.getCoordinatorPass() == null) {
                    request.setAttribute("errorMessage", "All fields are required for registration.");
                    request.getRequestDispatcher("/adminlogin.jsp").forward(request, response);
                    return;
                }

                String insertSQL = "INSERT INTO Coordinator (coordinatorID, coordinatorName, coordinatorEmail, coordinatorPass) VALUES (?, ?, ?, ?)";
                try (PreparedStatement stmt = conn.prepareStatement(insertSQL)) {
                    stmt.setString(1, cod.getCoordinatorID());
                    stmt.setString(2, cod.getCoordinatorName());
                    stmt.setString(3, cod.getCoordinatorEmail());
                    stmt.setString(4, cod.getCoordinatorPass());

                    int result = stmt.executeUpdate();
                    if (result > 0) {
                        request.getSession().setAttribute("successMessage", "Registration successful! Please login to continue.");
                        response.sendRedirect("adminlogin.jsp");
                    } else {
                        request.setAttribute("errorMessage", "Registration failed. Please try again.");
                        request.getRequestDispatcher("/adminlogin.jsp").forward(request, response);
                    }
                } catch (SQLException ex) {
                    System.err.println("SQL Error: " + ex.getMessage());
                    request.setAttribute("errorMessage", "Error during registration: " + ex.getMessage());
                    request.getRequestDispatcher("/adminlogin.jsp").forward(request, response);
                }
            }
            
            // Add action
            else if ("add".equalsIgnoreCase(action)) { 
                if (cod.getCoordinatorName() == null || cod.getCoordinatorEmail() == null || cod.getCoordinatorPass() == null || cod.getPosition() == null || cod.getCoordinatorNoTel() == null) {
                    request.setAttribute("errorMessage", "All fields are required for registration.");
                    request.getRequestDispatcher("/adminlogin.jsp").forward(request, response);
                    return;
                }
            
                String insertSQL = "INSERT INTO Coordinator (coordinatorID, coordinatorName, coordinatorNoTel, coordinatorEmail, position, coordinatorPass) VALUES (?, ?, ?, ?, ?, ?)";
                try (PreparedStatement stmt = conn.prepareStatement(insertSQL)) {
                    stmt.setString(1, cod.getCoordinatorID());
                    stmt.setString(2, cod.getCoordinatorName());
                    stmt.setString(3, cod.getCoordinatorNoTel());
                    stmt.setString(4, cod.getCoordinatorEmail());
                    stmt.setString(5, cod.getPosition());
                    stmt.setString(6, cod.getCoordinatorPass());
               
                    System.out.println("Executing query: " + stmt);
               
                    int result = stmt.executeUpdate();
                    if (result > 0) {
                        request.getSession().setAttribute("popupMessage", "Coordinator added successfully.");
                        response.sendRedirect("coordinator.jsp");
                    } else {
                        request.setAttribute("message", "Failed to add coordinator.");
                        request.getRequestDispatcher("/addCoordinator.jsp").forward(request, response);
                    }
                } catch (SQLException ex) {
                    System.err.println("SQL Error Code: " + ex.getErrorCode());
                    System.err.println("SQL State: " + ex.getSQLState());
                    System.err.println("Error Message: " + ex.getMessage());
                    ex.printStackTrace();
                    request.setAttribute("message", "Error occurred during insert operation: " + ex.getMessage());
                    request.getRequestDispatcher("/addCoordinator.jsp").forward(request, response);                  
                }
            } 
            
            // Update action
            else if ("Update".equalsIgnoreCase(action)) {
                String updateSQL = "UPDATE Coordinator SET coordinatorName = ?, coordinatorNotel = ?, coordinatorEmail = ?, position = ?, coordinatorPass = ? WHERE coordinatorID = ?";
            
                try (PreparedStatement stmt = conn.prepareStatement(updateSQL)) {
                    stmt.setString(1, cod.getCoordinatorName());
                    stmt.setString(2, cod.getCoordinatorNoTel());
                    stmt.setString(3, cod.getCoordinatorEmail());
                    stmt.setString(4, cod.getPosition());
                    stmt.setString(5, cod.getCoordinatorPass());
                    stmt.setString(6,  cod.getCoordinatorID());
               
                    System.out.println("Executing update query: " + stmt.toString());
               
                    int result = stmt.executeUpdate();
                    System.out.println("Update result: " + result);
               
                    if (result > 0) {
                        request.getSession().setAttribute("popupMessage", "Coordinator updated successfully.");
                        response.sendRedirect("coordinator.jsp");
                    } else {
                        request.setAttribute("message", "Failed to update coordinator.");
                        request.getRequestDispatcher("/updateCoordinator.jsp").forward(request, response);
                    }
                } catch (SQLException ex) {
                    System.err.println("SQL error during update operation: " + ex.getMessage());
                    ex.printStackTrace();
                    request.setAttribute("message", "Error occurred during update operation.");
                    request.getRequestDispatcher("/updateCoordinator.jsp").forward(request, response);
                }
            } else {
                request.setAttribute("message", "Invalid action parameter.");
                request.getRequestDispatcher("/coordinator.jsp").forward(request, response);
            }
         } catch (SQLException ex) {
            ex.printStackTrace();
            out.println("Error connecting to the database: " + ex.getMessage());
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error occurred.");
         }
      }
   }

   @Override
   protected void doGet(HttpServletRequest request, HttpServletResponse response)
           throws ServletException, IOException {
      try {
         processRequest(request, response);
      } catch (SQLException ex) {
         ex.printStackTrace();
         response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error occurred.");
      } catch (ClassNotFoundException ex) {
         Logger.getLogger(coordinatorController.class.getName()).log(Level.SEVERE, null, ex);
      }
   }

   @Override
   protected void doPost(HttpServletRequest request, HttpServletResponse response)
           throws ServletException, IOException {
      try {
         processRequest(request, response);
      } catch (SQLException ex) {
         ex.printStackTrace();
         response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error occurred.");
      } catch (ClassNotFoundException ex) {
         Logger.getLogger(coordinatorController.class.getName()).log(Level.SEVERE, null, ex);
      }
   }

   @Override
   public String getServletInfo() {
      return "Short description";
   }
}