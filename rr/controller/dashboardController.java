package rr.controller;

import java.io.*;
import java.sql.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;


public class dashboardController extends HttpServlet {
    
    private static final String URL = "jdbc:oracle:thin:@localhost:1521:XE"; 
    private static final String USERNAME = "MYCONNECTION";  
    private static final String PASSWORD = "system";
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int volunteerCount = getVolunteerCount();
            int coordinatorCount = getCoordinatorCount();
            int locationCount = getServiceLocationCount();
            int productCount = getTotalProductQuantity();

            System.out.println("Volunteer Count: " + volunteerCount);
            System.out.println("Coordinator Count: " + coordinatorCount);
            System.out.println("Location Count: " + locationCount);
            System.out.println("Product Count: " + productCount);

            request.setAttribute("volunteerCount", volunteerCount);
            request.setAttribute("coordinatorCount", coordinatorCount);
            request.setAttribute("locationCount", locationCount);
            request.setAttribute("productCount", productCount);

            // Get monthly volunteer data
            List<Integer> monthlyData = getMonthlyVolunteerData();
            System.out.println("Monthly Volunteers: " + monthlyData);
            request.setAttribute("monthlyVolunteers", monthlyData);

            // Get location data by state
            Map<String, Integer> stateData = getLocationsByState();
            System.out.println("State Data: " + stateData);
            request.setAttribute("stateLabels", new ArrayList<>(stateData.keySet()));
            request.setAttribute("stateData", new ArrayList<>(stateData.values()));

        // Forward to dashboard page
        RequestDispatcher dispatcher = request.getRequestDispatcher("./dashboard.jsp");
        dispatcher.forward(request, response);
            
        } catch (SQLException e) {
            e.printStackTrace();
            throw new ServletException("Database error", e);
        }
    }
    
    private int getVolunteerCount() throws SQLException {
        String sql = "SELECT COUNT(*) FROM Volunteer";
        return executeCountQuery(sql);
    }
    
    private int getCoordinatorCount() throws SQLException {
        String sql = "SELECT COUNT(*) FROM Coordinator";
        return executeCountQuery(sql);
    }
    
    private int getServiceLocationCount() throws SQLException {
        String sql = "SELECT COUNT(*) FROM Service_Location";
        return executeCountQuery(sql);
    }
    
    private int getTotalProductQuantity() throws SQLException {
        String sql = "SELECT NVL(SUM(productQtt), 0) FROM Product";
        return executeCountQuery(sql);
    }
    
    private List<Integer> getMonthlyVolunteerData() throws SQLException {
        List<Integer> monthlyData = new ArrayList<>(Collections.nCopies(12, 0));
        String sql = "SELECT EXTRACT(MONTH FROM formDate) as month, COUNT(DISTINCT v.volunteerID) as count " +
                    "FROM Volunteer v " +
                    "LEFT JOIN Volunteer_Form vf ON v.volunteerID = vf.volunteerID " +
                    "WHERE EXTRACT(YEAR FROM formDate) = EXTRACT(YEAR FROM SYSDATE) " +
                    "GROUP BY EXTRACT(MONTH FROM formDate) " +
                    "ORDER BY month";
                    
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                int month = rs.getInt("month");
                int count = rs.getInt("count");
                monthlyData.set(month - 1, count);
            }
        }
        return monthlyData;
    }
    
    private Map<String, Integer> getLocationsByState() throws SQLException {
        Map<String, Integer> stateData = new LinkedHashMap<>();
        String sql = "SELECT s.stateName, COUNT(sl.serviceID) as locationCount " +
                    "FROM States s " +
                    "LEFT JOIN Service_Location sl ON s.stateID = sl.stateID " +
                    "GROUP BY s.stateID, s.stateName " +
                    "ORDER BY s.stateName";
                    
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                stateData.put(
                    rs.getString("stateName"),
                    rs.getInt("locationCount")
                );
            }
        }
        return stateData;
    }
    
    private int executeCountQuery(String sql) throws SQLException {
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            return rs.next() ? rs.getInt(1) : 0;
        }
    }
    
    private Connection getConnection() throws SQLException {
        try {
            Class.forName("oracle.jdbc.OracleDriver");
            return DriverManager.getConnection(URL, USERNAME, PASSWORD);
        } catch (ClassNotFoundException e) {
            throw new SQLException("Oracle Driver not found", e);
        }
    }
}