package rr.dao;

import util.DBConnection;
import rr.beans.LoginBean;
import java.sql.*;

/**
 * Login DAO for user authentication
 */
public class LoginDao {

    public String authenticateUser(LoginBean loginBean) {
        
        String coordinatorID = loginBean.getCoordinatorID(); // User-entered ID
        String coordinatorPass = loginBean.getCoordinatorPass(); // User-entered password

        // SQL query to authenticate user
        String query = "SELECT COORDINATORID, COORDINATORPASS FROM COORDINATOR WHERE COORDINATORID = ? AND COORDINATORPASS = ?";

        try (Connection con = DBConnection.createConnection();  // Establish database connection
             PreparedStatement pstmt = con.prepareStatement(query)) {

            // Set query parameters
            pstmt.setString(1, coordinatorID);
            pstmt.setString(2, coordinatorPass);

            // Debug: Print query execution
            System.out.println("Executing query: " + pstmt.toString());

            try (ResultSet resultSet = pstmt.executeQuery()) {
                // Check if a record is found
                if (resultSet.next()) {
                    System.out.println("Login SUCCESS for user: " + coordinatorID);
                    return "SUCCESS";
                } else {
                    System.out.println("Login FAILED for user: " + coordinatorID);
                    return "Invalid user credentials";
                }
            }

        } catch (SQLException e) {
            // Print stack trace for debugging SQL exceptions
            e.printStackTrace();
            return "Database error occurred";
        }
    }
}
