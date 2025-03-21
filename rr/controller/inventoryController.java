package rr.controller;

import java.io.IOException;
import java.net.URLEncoder;
import java.sql.*;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class inventoryController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            // Connect to the database
            conn = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:XE", "MYCONNECTION", "system");

            if ("Add".equalsIgnoreCase(action)) {
                // Get inventory details
                String inventoryID = request.getParameter("inventoryID");
                String serviceID = request.getParameter("location"); // Assuming location corresponds to SERVICEID
                String dateDelivered = request.getParameter("deliveryDate");
                String[] productIDs = request.getParameterValues("product[]");
                String[] quantities = request.getParameterValues("quantity[]");
                String status = request.getParameter("status");

                // Insert the inventory record
                String insertInventoryQuery = "INSERT INTO Inventory (INVENTORYID, SERVICEID, QUANTITYGIVEN, DATEDELIVERED, STATUSINVENTORY) VALUES (?, ?, ?, TO_DATE(?, 'YYYY-MM-DD'), ?)";
                stmt = conn.prepareStatement(insertInventoryQuery);
                stmt.setString(1, inventoryID);
                stmt.setString(2, serviceID);

                // Calculate total quantity given
                int totalQuantity = 0;
                for (String quantity : quantities) {
                    totalQuantity += Integer.parseInt(quantity);
                }
                stmt.setInt(3, totalQuantity);
                stmt.setString(4, dateDelivered);
                stmt.setString(5, status);
                int result = stmt.executeUpdate(); // Execute and get result for conditional check

                // Check if the inventory record was successfully added
                if (result > 0) {
                    // Insert product details into Product_Inventory and deduct quantities from the Product table
                    String insertProductInventoryQuery = "INSERT INTO Product_Inventory (PRODUCTID, INVENTORYID, QUANTITY) VALUES (?, ?, ?)";
                    String updateProductQuantityQuery = "UPDATE Product SET PRODUCTQTT = PRODUCTQTT - ? WHERE PRODUCTID = ?";

                    for (int i = 0; i < productIDs.length; i++) {
                        int quantity = Integer.parseInt(quantities[i]);

                        // Check stock sufficiency
                        if (!isStockSufficient(conn, productIDs[i], quantity)) {
                            request.getSession().setAttribute("popupMessage", "Insufficient stock for product: " + productIDs[i]);
                            response.sendRedirect("addInventory.jsp");
                            return; // Stop further processing
                        }

                        // Insert into Product_Inventory
                        stmt = conn.prepareStatement(insertProductInventoryQuery);
                        stmt.setString(1, productIDs[i]);
                        stmt.setString(2, inventoryID);
                        stmt.setInt(3, quantity);
                        stmt.executeUpdate();

                        // Deduct quantity from Product table
                        stmt = conn.prepareStatement(updateProductQuantityQuery);
                        stmt.setInt(1, quantity);
                        stmt.setString(2, productIDs[i]);
                        stmt.executeUpdate();
                    }

                    // Set success message and redirect
                    request.getSession().setAttribute("popupMessage", "New Inventory added successfully.");
                    response.sendRedirect("inventory.jsp?popupMessage=" + URLEncoder.encode("New Inventory added successfully.", "UTF-8"));
                } else {
                    // Set failure message and forward back to the form
                    request.setAttribute("popupMessage", "Failed to add inventory.");
                    request.getRequestDispatcher("/addInventory.jsp").forward(request, response);
                }
            } else if ("Update".equalsIgnoreCase(action)) {
                String inventoryID = request.getParameter("inventoryID");
                String serviceID = request.getParameter("location");
                String statusInventory = request.getParameter("statusInventory");
                String dateDelivered = request.getParameter("deliveryDate");

                // Get product and quantity arrays from the request
                String[] productIDs = request.getParameterValues("product[]");
                String[] quantities = request.getParameterValues("quantity[]");

                ResultSet rs = null;

                try {
                    conn = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:XE", "MYCONNECTION", "system");

                    // Step 1: Fetch existing product_inventory for the given inventoryID
                    Map<String, Integer> existingProducts = new HashMap<>();
                    String fetchQuery = "SELECT productID, quantity FROM Product_Inventory WHERE inventoryID = ?";
                    stmt = conn.prepareStatement(fetchQuery);
                    stmt.setString(1, inventoryID);
                    rs = stmt.executeQuery();
                    while (rs.next()) {
                        existingProducts.put(rs.getString("productID"), rs.getInt("quantity"));
                    }
                    rs.close();
                    stmt.close();

                    // Step 2: Update existing product quantities and handle removed products
                    for (Map.Entry<String, Integer> entry : existingProducts.entrySet()) {
                        String productID = entry.getKey();
                        int currentQuantity = entry.getValue();
                        boolean productFound = false;

                        for (int i = 0; i < productIDs.length; i++) {
                            if (productIDs[i].equals(productID)) {
                                productFound = true;
                                int newQuantity = Integer.parseInt(quantities[i]);

                                if (newQuantity > currentQuantity) {
                                    int additionalQuantity = newQuantity - currentQuantity;

                                    // Check stock sufficiency
                                    if (!isStockSufficient(conn, productID, additionalQuantity)) {
                                        request.getSession().setAttribute("popupMessage", "Insufficient stock for product: " + productID);
                                        response.sendRedirect("updateInventory.jsp?inventoryID=" + inventoryID);
                                        return; // Stop further processing
                                    }

                                    // Deduct additional quantity
                                    updateProductQuantity(conn, productID, -additionalQuantity);
                                } else if (newQuantity < currentQuantity) {
                                    // Handle reduced quantity
                                    int reducedQuantity = currentQuantity - newQuantity;
                                    updateProductQuantity(conn, productID, reducedQuantity);
                                }

                                // Update quantity in Product_Inventory
                                updateProductInventory(conn, inventoryID, productID, newQuantity);
                                break;
                            }
                        }

                        if (!productFound) {
                            // Remove product from inventory
                            updateProductQuantity(conn, productID, currentQuantity);
                            deleteProductInventory(conn, inventoryID, productID);
                        }
                    }

                    // Step 3: Add new products to the inventory
                    for (int i = 0; i < productIDs.length; i++) {
                        String productID = productIDs[i];
                        int quantity = Integer.parseInt(quantities[i]);

                        if (!existingProducts.containsKey(productID)) {
                            // Check stock sufficiency
                            if (!isStockSufficient(conn, productID, quantity)) {
                                request.getSession().setAttribute("popupMessage", "Insufficient stock for product: " + productID);
                                response.sendRedirect("updateInventory.jsp?inventoryID=" + inventoryID);
                                return; // Stop further processing
                            }

                            // Deduct from Product table and add to Product_Inventory
                            updateProductQuantity(conn, productID, -quantity);
                            insertProductInventory(conn, inventoryID, productID, quantity);
                        }
                    }

                    // Step 4: Update the inventory details
                    updateInventory(conn, inventoryID, serviceID, statusInventory, dateDelivered, quantities);

                    // Step 5: Redirect with success message
                    request.getSession().setAttribute("popupMessage", "Inventory updated successfully.");
                    response.sendRedirect("inventory.jsp");
                } catch (SQLException e) {
                    request.setAttribute("popupMessage", "Failed to update inventory: " + e.getMessage());
                    request.getRequestDispatcher("updateInventory.jsp").forward(request, response);
                } finally {
                    closeResources(rs, stmt, conn);
                }
            } 
            else if ("Delete".equalsIgnoreCase(action)) {
                ResultSet rs2 = null;
                String inventoryID = request.getParameter("inventoryID");

                try {
                    conn = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:XE", "MYCONNECTION", "system");

                    // Check if the inventory status is "Archived"
                    String checkStatusQuery = "SELECT statusInventory FROM Inventory WHERE inventoryID = ?";
                    stmt = conn.prepareStatement(checkStatusQuery);
                    stmt.setString(1, inventoryID);
                    rs2 = stmt.executeQuery();

                    if (rs2.next()) {
                        String status = rs2.getString("statusInventory");
                        if ("Archived".equalsIgnoreCase(status)) {
                            // Delete associated records from Product_Inventory
                            String deleteProductInventoryQuery = "DELETE FROM Product_Inventory WHERE inventoryID = ?";
                            stmt = conn.prepareStatement(deleteProductInventoryQuery);
                            stmt.setString(1, inventoryID);
                            stmt.executeUpdate();
                            stmt.close();

                            // Delete the inventory record
                            String deleteInventoryQuery = "DELETE FROM Inventory WHERE inventoryID = ?";
                            stmt = conn.prepareStatement(deleteInventoryQuery);
                            stmt.setString(1, inventoryID);
                            int rowsDeleted = stmt.executeUpdate();
                            stmt.close();

                            if (rowsDeleted > 0) {
                                request.getSession().setAttribute("popupMessage", "Inventory successfully deleted.");
                            } else {
                                request.getSession().setAttribute("popupMessage", "Failed to delete inventory.");
                            }
                        } else {
                            request.getSession().setAttribute("popupMessage", "Cannot delete inventory. Only 'Archived' inventories can be deleted.");
                        }
                    } else {
                        request.getSession().setAttribute("popupMessage", "Inventory not found.");
                    }
                } catch (SQLException e) {
                    e.printStackTrace();
                    request.getSession().setAttribute("popupMessage", "Error occurred: " + e.getMessage());
                } finally {
                    try {
                        if (rs2 != null) rs2.close();
                        if (stmt != null) stmt.close();
                        if (conn != null) conn.close();
                    } catch (SQLException e) {
                        e.printStackTrace();
                    }
                }

                response.sendRedirect("inventory.jsp"); // Redirect back to the inventory list page
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("message", "Error: " + e.getMessage());
            request.getRequestDispatcher("/addInventory.jsp").forward(request, response);
        } finally {
            try {
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
    
    private void updateProductQuantity(Connection conn, String productID, int adjustment) throws SQLException {
        String query = "UPDATE Product SET productQtt = productQtt + ? WHERE productID = ?";
        try (PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, adjustment);
            stmt.setString(2, productID);
            stmt.executeUpdate();
        }
    }
    
    private void updateProductInventory(Connection conn, String inventoryID, String productID, int quantity) throws SQLException {
        String query = "UPDATE Product_Inventory SET quantity = ? WHERE inventoryID = ? AND productID = ?";
        try (PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, quantity);
            stmt.setString(2, inventoryID);
            stmt.setString(3, productID);
            stmt.executeUpdate();
        }
    }

    private void deleteProductInventory(Connection conn, String inventoryID, String productID) throws SQLException {
        String query = "DELETE FROM Product_Inventory WHERE inventoryID = ? AND productID = ?";
        try (PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, inventoryID);
            stmt.setString(2, productID);
            stmt.executeUpdate();
        }
    }

    private void insertProductInventory(Connection conn, String inventoryID, String productID, int quantity) throws SQLException {
        String query = "INSERT INTO Product_Inventory (productID, inventoryID, quantity) VALUES (?, ?, ?)";
        try (PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, productID);
            stmt.setString(2, inventoryID);
            stmt.setInt(3, quantity);
            stmt.executeUpdate();
        }
    }
    
    private void updateInventory(Connection conn, String inventoryID, String serviceID, String statusInventory, String dateDelivered, String[] quantities) throws SQLException {
        int totalQuantity = Arrays.stream(quantities).mapToInt(Integer::parseInt).sum();
        String query = "UPDATE Inventory SET serviceID = ?, quantityGiven = ?, dateDelivered = ?, statusInventory = ? WHERE inventoryID = ?";
        try (PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, serviceID);
            stmt.setInt(2, totalQuantity);
            
            java.sql.Date sqlDate = java.sql.Date.valueOf(dateDelivered);
            stmt.setDate(3, sqlDate);
            
            stmt.setString(4, statusInventory);
            stmt.setString(5, inventoryID);
            stmt.executeUpdate();
        }
    }

    private void closeResources(ResultSet rs, PreparedStatement stmt, Connection conn) {
        try {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    
    private boolean isStockSufficient(Connection conn, String productID, int requiredQuantity) throws SQLException {
        String query = "SELECT productQtt FROM Product WHERE productID = ?";
        try (PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, productID);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    int currentStock = rs.getInt("productQtt");
                    return currentStock >= requiredQuantity && currentStock >= 5;
                }
            }
        }
        return false;
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
}
