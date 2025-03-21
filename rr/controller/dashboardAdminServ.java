package rr.controller;

import java.io.*;
import java.sql.*;
import java.util.*;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.*;
import javax.servlet.http.*;

public class dashboardAdminServ extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException, ClassNotFoundException {
    response.setContentType("text/html;charset=UTF-8");
    
    // Declare database connection details
    Class.forName("oracle.jdbc.OracleDriver");
    final String URL = "jdbc:oracle:thin:@localhost:1521:XE";
    final String USERNAME = "MYCONNECTION";
    final String PASSWORD = "system";

    try (PrintWriter out = response.getWriter()) {
        try {
            // Retrieve data
            int volunteerCount = getVolunteerCount(URL, USERNAME, PASSWORD);
            int coordinatorCount = getCoordinatorCount(URL, USERNAME, PASSWORD);
            int locationCount = getServiceLocationCount(URL, USERNAME, PASSWORD);
            int productCount = getTotalProductQuantity(URL, USERNAME, PASSWORD);

            // Debug logs
            System.out.println("Volunteer Count: " + volunteerCount);
            System.out.println("Coordinator Count: " + coordinatorCount);
            System.out.println("Location Count: " + locationCount);
            System.out.println("Product Count: " + productCount);

            // Set attributes for JSP
            request.setAttribute("volunteerCount", volunteerCount);
            request.setAttribute("coordinatorCount", coordinatorCount);
            request.setAttribute("locationCount", locationCount);
            request.setAttribute("productCount", productCount);

            // Monthly volunteer data
            List<Integer> monthlyData = getMonthlyVolunteerData(URL, USERNAME, PASSWORD);
            System.out.println("Monthly Volunteers: " + monthlyData);
            request.setAttribute("monthlyVolunteers", monthlyData);

            // Location data by state
            Map<String, Integer> stateData = getLocationsByState(URL, USERNAME, PASSWORD);
            System.out.println("State Data: " + stateData);
            request.setAttribute("stateLabels", new ArrayList<>(stateData.keySet()));
            request.setAttribute("stateData", new ArrayList<>(stateData.values()));

            // Forward to dashboard page
            RequestDispatcher dispatcher = request.getRequestDispatcher("dashboard.jsp");
            dispatcher.forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            throw new ServletException("Database error", e);
        }
    }
}

    // HTTP GET method
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            processRequest(request, response);
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(dashboardAdminServ.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    // HTTP POST method
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            processRequest(request, response);
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(dashboardAdminServ.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    private int getVolunteerCount(String url, String username, String password) throws SQLException {
    String sql = "SELECT COUNT(*) FROM Volunteer";
    return executeCountQuery(sql, url, username, password);
}

    private int getCoordinatorCount(String url, String username, String password) throws SQLException {
        String sql = "SELECT COUNT(*) FROM Coordinator";
        return executeCountQuery(sql, url, username, password);
    }

    private int getServiceLocationCount(String url, String username, String password) throws SQLException {
        String sql = "SELECT COUNT(*) FROM Service_Location";
        return executeCountQuery(sql, url, username, password);
    }

    private int getTotalProductQuantity(String url, String username, String password) throws SQLException {
        String sql = "SELECT NVL(SUM(productQtt), 0) FROM Product";
        return executeCountQuery(sql, url, username, password);
    }

    private List<Integer> getMonthlyVolunteerData(String url, String username, String password) throws SQLException {
        List<Integer> monthlyData = new ArrayList<>(Collections.nCopies(12, 0));
        String sql = "SELECT EXTRACT(MONTH FROM formDate) as month, COUNT(DISTINCT v.volunteerID) as count " +
                     "FROM Volunteer v " +
                     "LEFT JOIN Volunteer_Form vf ON v.volunteerID = vf.volunteerID " +
                     "WHERE EXTRACT(YEAR FROM formDate) = EXTRACT(YEAR FROM SYSDATE) " +
                     "GROUP BY EXTRACT(MONTH FROM formDate) " +
                     "ORDER BY month";

        try (Connection conn = DriverManager.getConnection(url, username, password);
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

    private Map<String, Integer> getLocationsByState(String url, String username, String password) throws SQLException {
        Map<String, Integer> stateData = new LinkedHashMap<>();
        String sql = "SELECT s.stateName, COUNT(sl.serviceID) as locationCount " +
                     "FROM States s " +
                     "LEFT JOIN Service_Location sl ON s.stateID = sl.stateID " +
                     "GROUP BY s.stateID, s.stateName " +
                     "ORDER BY s.stateName";

        try (Connection conn = DriverManager.getConnection(url, username, password);
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

    private int executeCountQuery(String sql, String url, String username, String password) throws SQLException {
        try (Connection conn = DriverManager.getConnection(url, username, password);
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            return rs.next() ? rs.getInt(1) : 0;
        }
    }
}
