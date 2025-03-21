package util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {
    private static final String URL = "jdbc:oracle:thin:@localhost:1521:XE"; // Replace 'customers' with your database name
    private static final String USERNAME = "MYCONNECTION"; // Replace 'root' with your database 
    private static final String PASSWORD = "system"; // Replace with your database password
    
    public static Connection createConnection() throws SQLException {
        Connection connection = null;

        try {
            // Load the JDBC Driver
            Class.forName("oracle.jdbc.OracleDriver");

            // Establish the connection
            connection = DriverManager.getConnection(URL, USERNAME, PASSWORD);
            System.out.println("Database connection established successfully.");
        } catch (ClassNotFoundException e) {
            System.err.println("Error: JDBC Driver not found. " + e.getMessage());
        } catch (SQLException e) {
            System.err.println("Error: Unable to connect to the database. " + e.getMessage());
        }

        return connection;
    }
    
    public static void main(String[] args) {
    try (Connection connection = DBConnection.createConnection()) {
        if (connection != null) {
            System.out.println("Connection successful.");
        } else {
            System.out.println("Connection failed.");
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
}

    public static Connection getConnection() throws SQLException, ClassNotFoundException {
            Class.forName("oracle.jdbc.driver.OracleDriver");
            return DriverManager.getConnection(URL, USERNAME, PASSWORD);//To change body of generated methods, choose Tools | Templates.
    }

}
