<%@ page import="java.sql.*" %>
<%
    // Initialize variables
    String generatedID = "";

    try {
        // Load the database driver (modify the driver as per your database)
        Class.forName("oracle.jdbc.OracleDriver");

        // Establish a connection (update URL, username, and password)
        Connection conn = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:XE", "MYCONNECTION", "system");

        // Query to get the last coordinator ID
        String query = "SELECT inventoryID FROM (SELECT inventoryID FROM Inventory ORDER BY inventoryID DESC) WHERE ROWNUM = 1";
        PreparedStatement stmt = conn.prepareStatement(query);
        ResultSet rs = stmt.executeQuery();

        if (rs.next()) {
            String lastID = rs.getString("inventoryID");
            int numberPart = Integer.parseInt(lastID.substring(2)); // Extract numeric part
            String newID = "IV" + String.format("%03d", numberPart + 1); // Increment and format
            generatedID = newID;
        } else {
            // If no records exist, start with CO001
            generatedID = "IV001";
        }

        // Close resources
        rs.close();
        stmt.close();
        conn.close();
    } catch (Exception e) {
        e.printStackTrace();
        generatedID = "ErrorGeneratingID"; // Fallback ID in case of errors
    }
%>

<!DOCTYPE html>
<html lang="en">
  <head>
    <a href="C:\Users\User\Documents\CDCS230\SEMESTER 4\CSC584\HeaderAdmin.html"></a>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE-edge">
    <meta name="viewport" content="width-device-width", initial-scale="1.0">
    
    <link rel="icon" type="image/icon" href="">
    <title>New Inventory</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:ital,wght@0,100..900;1,100..900&family=Quicksand:wght@500&display=swap" rel="stylesheet">
        
    <script src="https://kit.fontawesome.com/939a0fa897.js" crossorigin="anonymous"></script>
    <link href='https://unpkg.com/boxicons@2.0.7/css/boxicons.min.css' rel='stylesheet'>
    
    <% 
        String popupMessage = (String) request.getAttribute("popupMessage");
        if (popupMessage != null) {
    %>
        <script>
            alert("<%= popupMessage %>");
        </script>
    <% 
        }
    %>
  </head>

  <style>
    body {
      background: #f6f4dc;
      display: flex;
      justify-content: center;
      align-items: center;
      height: 100vh;
      margin: 0;
    }
    * {
      margin: 0;
      padding: 0;
      box-sizing: border-box;
      font-family: "Quicksand", sans-serif;
    }
    .container {
      display: flex;
      justify-content: center;
      align-items: center;
      padding: 0 20px;
      height: 100vh;
    }

    .form-container {
      display: flex;
      flex-direction: column;
      gap: 20px;
      width: 100%;
      min-width: 700px;
      background-color: #fff;
      border-radius: 15px;
      padding: 20px;
      box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
      max-height: 80vh;
      overflow-x: hidden;
      overflow-y: auto;
    }
    .form-header {
      text-align: left;
      display: flex;
    }
    .form-header h1 {
      margin: 0;
      font-size: 1.8rem;
      color: #266433;
      font-weight: bolder;
    }
    .form-body {
      display: flex;
      flex-wrap: wrap;
      gap: 30px;
    }
    .form-fields {
      flex: 1 1 40%;
      min-width: 400px;
      display: flex;
      flex-direction: column;
      gap: 10px;
    }
    .form-fields label {
      font-size: 16px;
      color: #266433;
      font-weight: bold;
    }
    .form-fields input,
    .form-fields select,
    .form-fields textarea {
      width: 100%;
      padding: 10px;
      border: 1px solid #266433;
      border-radius: 15px;
      font-size: 1rem;
    }
    .form-fields textarea {
      resize: none;
      height: 80px;
    }

    .form-fields .inline-fields {
        display: flex;
        gap: 10px;
        align-items: flex-start;
        margin-bottom: 15px;
    }
  
    .inline-fields label {
        margin-bottom: 5px;
        display: flex;
    }
  
    .inline-fields div {
        flex: 1;
    }
  
    .inline-fields input {
        width: 100%;
        box-sizing: border-box;
    }
  
    select {
        width: 100%;
        padding: 10px;
        border: 1px solid #266433;
        border-radius: 15px;
        font-size: 16px;
        background-color: #fff;
    }
  
    select:focus {
        outline: none;
        border-color: #339551;
        box-shadow: 0 0 4px rgba(0, 0, 0, 0.2);
    }
  
    select option {
        font-size: 16px;
    }  

    .product-list {
        display: flex;
        flex-direction: column;
        width: 70%;
        gap: 15px;
    }
      
    .product-item {
        display: flex;
        justify-content: space-between;
        align-items: center;
        background-color: #f4f6dd;
        padding: 10px;
        border-radius: 15px;
        border: 2px dashed #266433;
        margin-bottom: 15px;
    }
      
    .product-details {
        display: flex;
        gap: 10px;
        align-items: flex-start;
        width: 80%;
        margin-bottom: 15px;  /* Adjusts spacing between fields */
    }

    .product-details div {
        flex: 1;
    }
      
    .product-item select,
    .product-item input {
        border-radius: 15px;
        padding: 10px;
        font-size: 1rem; 
        gap: 10px;
    }

    .product-details label {
        margin-bottom: 5px;
        display: flex;
    }
  
    .product-details input {
        width: 100%;
        box-sizing: border-box;
    }
      
    .product-item button {
        background-color: #f06838;
        margin: 5px 0 0 5px;
        color: white;
        padding: 10px 20px;
        border: none;
        border-radius: 15px;
        cursor: pointer;
    }
      
    .product-item button:hover {
        background-color: #E1DC53;
        color: #266433;
    }
    
    .addProduct-btn button{
        background-color: #266433;
        color: #f6f4dc;
        border: none;
        padding: 10px 15px;
        border-radius: 15px;
        cursor: pointer;
        font-size: 1rem;
    }

    .addProduct-btn button:hover {
        background-color: #339551;

    }
    
    .btn-container {
      display: flex;
      justify-content: flex-end;
      gap: 10px;
    }
    .btn-publish {
      background-color: #f06838;
      color: #f6f4dc;
      border: none;
      padding: 10px 15px;
      border-radius: 15px;
      cursor: pointer;
      font-size: 1rem;
    }
    .btn-cancel {
      color: #f6f4dc;
      border: none;
      padding: 10px 15px;
      border-radius: 15px;
      cursor: pointer;
      font-size: 1rem;
      background-color: #266433;
    }
    .btn-publish:hover {
      background-color: #E1DC53;
      color: #266433;
    }
    .btn-cancel:hover {
      background-color: #339551;
      color: #f6f4dc;
    }
  </style>

  <body>
    <div class="container">
      <div class="form-container">
        <div class="form-header">
          <h1>New Inventory</h1>
        </div>
          <form action="inventoryController" method="POST" id="inventoryForm">
            <div class="form-fields">
                <div class="inline-fields">
                    <div>
                        <label for="inventoryID">Inventory ID</label>
                        <input type="text" id="inventoryID" name="inventoryID" value="<%= generatedID %>" style="width: 200px;" readonly>
                    </div>
                    
                    <div>
                        <label for="location" style="width: 450px;">Select Location</label>
                        <select id="location-id" name="location" style="width: 450px;" required>
                                  <option value="">Select Location</option>
                                  <%
                                      Connection conn = null;
                                      Statement stmt = null;
                                      ResultSet rs = null;

                                          Class.forName("oracle.jdbc.OracleDriver");
                                          conn = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:XE", "MYCONNECTION", "system");
                                          stmt = conn.createStatement();

                                      rs = stmt.executeQuery("SELECT serviceID, serviceAddress FROM Service_Location ORDER BY serviceID asc");
                                      while (rs.next()) {
                                          String serviceIDOption = rs.getString("serviceID");
                                          String serviceLoc = rs.getString("serviceAddress");
                                  %>
                                   <option value="<%= serviceIDOption %>"><%= serviceIDOption %> - <%= serviceLoc %></option>
                                  <%
                                      }
                                  %>
                        </select>
                    </div>
                </div>
                
                <div class="inline-fields">
                    <div>
                        <label for="deliveryDate">Date Delivered</label>
                        <input type="date" id="deliveryDate" name="deliveryDate" />
                    </div>
                    <div>
                        <label for="statusDelivery">Status</label>
                        <select id="statusDelivery" name="status">
                            <option value="" disabled selected>Select Status</option>
                            <!-- Dynamically load location options from DB -->
                            <option value="In Progress">In Progress</option>
                            <option value="Completed">Completed</option>
                            <option value="Archived">Archived</option>
                        </select>
                    </div>
                </div>
            </div>

            <div class="product-list">
                <!-- Product Item (Repeated for each product selection) -->
                <div class="product-item">
                    <div class="product-details">
                        <div>   
                            <label for="product1">Product Name</label>
                            <select id="product1" name="product[]">
                            <option value="" disabled selected>Select Product</option>
                            <%
                                try {
                                    Class.forName("oracle.jdbc.OracleDriver");
                                    conn = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:XE", "MYCONNECTION", "system");
                                    stmt = conn.createStatement();

                                    rs = stmt.executeQuery("SELECT productID, productName FROM Product ORDER BY productID ASC");

                                    while (rs.next()) {
                                        String productID = rs.getString("productID");
                                        String productName = rs.getString("productName");
                            %>
                                        <option value="<%= productID %>"><%= productID %> - <%= productName %></option>
                            <%
                                    }
                                    rs.close();
                                    stmt.close();
                                    conn.close();
                                } catch (Exception e) {
                                    e.printStackTrace();
                                }
                            %>
                            </select>
                        </div>
                        <div>
                            <label for="quantity1">Quantity</label>
                            <input type="number" id="quantity1" name="quantity[]" min="1" placeholder="Quantity" />
                        </div>
                    </div>

                    <button type="button" onclick="removeProduct(this)">Remove</button>
                </div>
            </div>
            <div class="addProduct-btn">
                <button type="button" onclick="addProduct()"><i class="fa-solid fa-plus"></i>Add Product</button>
            </div>
  
          <div class="btn-container">
            <button type="button" class="btn-cancel" onclick="cancelForm()">Cancel</button>
            <input type="hidden" name="action" value="Add" >
            <button type="submit" class="btn-publish">Submit Inventory</button>
          </div>
        </form>
      </div>
    </div>
  </body>
  <script>
        // Function to add another product to the list
        function addProduct() {
        const productList = document.querySelector('.product-list');
        const newProduct = document.createElement('div');
        newProduct.classList.add('product-item');
        newProduct.innerHTML = `
            <div class="product-details">
                <div>
                    <label for="product">Product Name</label>
                    <select id="product" name="product[]">
                         <option value="" disabled selected>Select Product</option>
                            <%
                                try {
                                    Class.forName("oracle.jdbc.OracleDriver");
                                    conn = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:XE", "MYCONNECTION", "system");
                                    stmt = conn.createStatement();

                                    rs = stmt.executeQuery("SELECT productID, productName FROM Product ORDER BY productID ASC");

                                    while (rs.next()) {
                                        String productID = rs.getString("productID");
                                        String productName = rs.getString("productName");
                            %>
                                        <option value="<%= productID %>"><%= productID %> - <%= productName %></option>
                            <%
                                    }
                                    rs.close();
                                    stmt.close();
                                    conn.close();
                                } catch (Exception e) {
                                    e.printStackTrace();
                                }
                            %>
                    </select>
                </div>
                <div>
                    <label for="quantity">Quantity</label>
                    <input type="number" id="quantity" name="quantity[]" min="1" placeholder="Quantity" />
                </div>
            </div>
            <button type="button" onclick="removeProduct(this)">Remove</button>
        `;
        productList.appendChild(newProduct);
    }

    // Function to remove a product item
    function removeProduct(button) {
      const productItem = button.parentElement;
      productItem.remove();
    }
    
    document.getElementById('inventoryForm').addEventListener('submit', function (e) {
        const products = document.querySelectorAll('select[name="product[]"]');
        const quantities = document.querySelectorAll('input[name="quantity[]"]');
        for (let i = 0; i < products.length; i++) {
            if (products[i].value === '' || quantities[i].value <= 0) {
                alert('Please select valid products and enter valid quantities.');
                e.preventDefault();
                return;
            }
        }
    });

     function cancelForm() {
            if (confirm('Are you sure you want to cancel?')) {
                document.getElementById('inventoryForm').reset();
                window.location.href='inventory.jsp'; 
            }
        } 
  </script>
</html>