package rr.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.http.HttpServlet;

public class userLoginDao extends HttpServlet {

    private final String URL = "jdbc:oracle:thin:@localhost:1521/XEPDB1";
    private final String USERNAME = "MYCONNECTION";
    private final String PASSWORD = "system";

    // Method to check if the user exists and retrieve volunteer ID
    public String authenticateVolunteer(String email, String password) {
        String volunteerID = null;

        try {
            // Load Oracle JDBC Driver
            Class.forName("oracle.jdbc.driver.OracleDriver");

            // Establish connection
            Connection conn = DriverManager.getConnection(URL, USERNAME, PASSWORD);

            // Prepare SQL Query
            String query = "SELECT volunteerID FROM VOLUNTEER WHERE EMAIL = ? AND PASSWORD = ?";
            PreparedStatement stmt = conn.prepareStatement(query);
            stmt.setString(1, email);
            stmt.setString(2, password);

            // Execute query
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                // Retrieve volunteer ID
                volunteerID = rs.getString("volunteerID");
            }

            // Close connections
            rs.close();
            stmt.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

        return volunteerID;
    }
}
