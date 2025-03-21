<%@page import="java.sql.*" %>

<!DOCTYPE html>
<html lang="en">
  <head>
    <a href="C:\Users\User\Documents\CDCS230\SEMESTER 4\CSC584\HeaderAdmin.html"></a>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE-edge">
    <meta name="viewport" content="width-device-width", initial-scale="1.0">
    
    <link rel="icon" type="image/icon" href="">
    <title>Inventory Slip</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:ital,wght@0,100..900;1,100..900&family=Quicksand:wght@500&display=swap" rel="stylesheet">
        
    <script src="https://kit.fontawesome.com/939a0fa897.js" crossorigin="anonymous"></script>
    <link href='https://unpkg.com/boxicons@2.0.7/css/boxicons.min.css' rel='stylesheet'>
    
    <script>
        function triggerPrint() {
            window.print();
        }
    </script>
  </head>
  <style>
    body {
        margin: 0;
        padding: 50px;
        background: #F4F6DD;
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: flex-start;
        min-height: 100vh;
    }

  *{
        box-sizing: border-box;
        font-family: 'Quicksand', sans-serif;
    }

    .print {
        width: 100%;
        max-width: 900px;
        text-align: right;
        margin-bottom: 15px;
    }

    button {
        background-color: #f06838;
        color: #fff;
        padding: 10px 20px;
        border: none;
        border-radius: 15px;
        cursor: pointer;
        font-size: 14px;
    }

    button:hover {
        background-color: #E1DC53;
        color: #266433;
    }

    .btn-back {
      background-color: #266433;
        color: #fff;
        padding: 10px 20px;
        border: none;
        border-radius: 15px;
        cursor: pointer;
        font-size: 14px;
    }

    .btn-back:hover {
      background-color: #BEE097;
        color: #266433;
    }

    .inventory-slip {
        background: #fff;
        padding: 20px;
        border-radius: 10px;
        max-width: 900px;
        width: 100%;
        max-height: 80vh;
        overflow-y: auto;
        overflow-x: auto;
    }
      
    .header {
        margin-bottom: 30px;
        padding-bottom: 10px;
    }
    
    .header h2 {
        color: #266433;
    }

    .header-details {
        display: grid; /* Use grid layout for precise control */
        grid-template-columns: auto 1fr; /* Two columns: first auto-width, second fills remaining space */
        gap: 20px 30px; /* Row and column gaps */
        align-items: center; /* Vertically align items */
    }

    .header-details div {
        display: flex;
        align-items: center; /* Vertically align content inside the div */
    }

    .header-details div strong {
        font-weight: 600;
        color: #266433;
        margin-right: 5px; /* Space between label and value */
    }

    .header-details div span {
        font-weight: 500;
        font-size: 16px;
        color: #266433;
        background-color: #fdf2ec;
        padding: 3px 8px;
        border-radius: 5px;
        white-space: nowrap; /* Prevent text wrapping */
    }

    table {
        width: 100%;
        border-collapse: collapse;
        justify-content: center;
        margin-bottom: 20px;
    }
    
    table th,
    table td {
        padding: 15px 15px 15px;
        text-align: center;
        border-bottom: 1px solid #266433;
        border-top: 1px solid #266433;
    }
    
    table th {
        background-color: #266433;
        color: #F4F6DD;
    }
    
    @media print {
        body {
            background: #fff;
            color: #000;
        }
        
        
        .print {
             display: none; /* Hide print buttons */
        }
        button {
            display: none; /* Hide all buttons */
        }
        
        .inventory-slip {
            border: none;
            padding: 0;
            margin: 0;
         }
         
        .header-details div span,
            table td {
                white-space: normal; /* Enable text wrapping in print */
                word-wrap: break-word;
            }
            table th {
                color: black;
            }
        
    }
  </style>
    <body>
        <div class="print">
            <a href="inventory.jsp"><button class="btn-back">Back</button></a>
            <button onclick="triggerPrint()">Print Inventory Slip</button>
        </div>

        <div class="inventory-slip">
            <header class="header">
              <h2>Inventory Slip</h2>
                <%
                    String inventoryID = request.getParameter("inventoryID");
                    Connection conn = null;
                    PreparedStatement stmt = null;
                    ResultSet rs = null;

                    try {
                        // Establish database connection
                        conn = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:XE", "MYCONNECTION", "system");

                        // SQL query
                        String query = "SELECT pi.inventoryID, sl.serviceAddress, iv.quantityGiven, iv.dateDelivered, " +
                                       "p.productName, pi.productID, pi.quantity " +
                                       "FROM Inventory iv " +
                                       "LEFT JOIN product_inventory pi ON pi.inventoryID = iv.inventoryID " +
                                       "LEFT JOIN Service_Location sl ON sl.serviceID = iv.serviceID " +
                                       "LEFT JOIN Product p ON p.productID = pi.productID " +
                                       "WHERE pi.inventoryID = ?";

                        stmt = conn.prepareStatement(query);
                        stmt.setString(1, inventoryID);
                        rs = stmt.executeQuery();

                        boolean headerRendered = false; // Flag to control header rendering

                        while (rs.next()) {
                            if (!headerRendered) {
                                // Render header details only once
                %>
              <div class="header-details">
                <div><strong>Inventory ID:</strong> <span>#<%= rs.getString("inventoryID") %></span></div>
                <div><strong>Service Location:</strong> <span><%= rs.getString("serviceAddress") %></span></div>
                <div><strong>Total Quantity:</strong> <span><%= rs.getInt("quantityGiven") %></span></div>
                <div><strong>Date Delivered:</strong> <span><%= rs.getDate("dateDelivered") %></span></div>
              </div>
            </header>
            <table class="product-table">
              <thead>
                <tr>
                  <th>Product ID</th>
                  <th>Product Name</th>
                  <th>Quantity</th>
                </tr>
              </thead>
              <tbody>
                  <%
                        headerRendered = true; // Set flag to true after rendering header
                        }
                  %>
                 <tr>
                    <td><%= rs.getString("productID") %></td>
                    <td><%= rs.getString("productName") %></td>
                    <td><%= rs.getInt("quantity") %></td>
                  </tr>
                <%
                        }
                        if (!headerRendered) {
                            // No records found
                %>
                    <tr>
                      <td colspan="3">No records found for this inventory.</td>
                    </tr>
                <%
                        }
                %>
              </tbody>
            </table>
            <%
                } catch (SQLException e) {
                    out.println("<p>Error: " + e.getMessage() + "</p>");
                } finally {
                    try {
                        if (rs != null) rs.close();
                        if (stmt != null) stmt.close();
                        if (conn != null) conn.close();
                    } catch (SQLException e) {
                        out.println("<p>Error closing resources: " + e.getMessage() + "</p>");
                    }
                }
            %>
        </div>
    </body>
</html>