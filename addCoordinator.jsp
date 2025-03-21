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
        String query = "SELECT coordinatorID FROM (SELECT coordinatorID FROM Coordinator ORDER BY coordinatorID DESC) WHERE ROWNUM = 1";
        PreparedStatement stmt = conn.prepareStatement(query);
        ResultSet rs = stmt.executeQuery();

        if (rs.next()) {
            String lastID = rs.getString("coordinatorID");
            int numberPart = Integer.parseInt(lastID.substring(2)); // Extract numeric part
            String newID = "CO" + String.format("%03d", numberPart + 1); // Increment and format
            generatedID = newID;
        } else {
            // If no records exist, start with CO001
            generatedID = "CO001";
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
    <title>New Coordinator</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:ital,wght@0,100..900;1,100..900&family=Quicksand:wght@500&display=swap" rel="stylesheet">
        
    <script src="https://kit.fontawesome.com/939a0fa897.js" crossorigin="anonymous"></script>
    <link href='https://unpkg.com/boxicons@2.0.7/css/boxicons.min.css' rel='stylesheet'>
  </head>
  <style>
    body{
      background: #f6f4dc;
      display: flex;
      justify-content: center;
      align-items: center;
      height: 100vh;
      margin: 0;
    }

  *{
      margin: 0;
      padding: 0;
      box-sizing: border-box;
      font-family: "Quicksand", sans-serif;
    }

    .container {
        display: flex;
        justify-content: center;
        align-items: center;
        padding: 0 20px; /* Add padding for responsiveness */
        height: 100vh;
    }

    .form-container {
        display: flex;
        flex-direction: column;
        gap: 20px;
        width: 100%; /* Takes 90% of the parent container's width */
        background-color: #fff;
        border-radius: 15px;
        padding: 20px;
        box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
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
      flex-wrap: wrap; /* Allows sections to stack on smaller screens */
      gap: 30px; /* Increased gap for spacing */
    }

    .form-fields {
        flex: 1 1 40%; /* Takes 60% of available space */
        min-width: 500px; /* Ensures a minimum width */
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

    .form-fields .inline-fields {
        display: flex;
        gap: 10px;
        align-items: flex-start;
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

    .btn-container {
        display: flex;
        justify-content: flex-end;
        gap: 10px;
        margin-top: 10px;
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
            <!-- Form Header -->
            <div class="form-header">
                <h1>New Coordinator</h1>
            </div>
      
            <form action="coordinatorController" method="POST" id="application-form">
                <div class="form-fields">

                    <label for="coordinatorName">Coordinator Name</label>
                    <input type="text" id="coordinatorName" name="coordinatorName" placeholder="Enter Coordinator Name...">

                    <div class="inline-fields">
                        <div>
                            <label for="coordinatorNo">Coordinator ID</label>
                            <input type="text" id="coordinatorID" name="coordinatorID" value="<%= generatedID %>" readonly>

                        </div>
                            
                        <div>
                            <label for="coordinatorNo">Phone No.</label>
                            <input type="text" id="coordinatorNo" name="coordinatorNo" placeholder="Enter Phone No...">
                        </div>
                    </div>

                    <div class="inline-fields">
                        <div>
                            <label for="coordinatorPosition">Position</label>
                            <input type="text" id="coordinatorPosition" name="coordinatorPosition" placeholder="Enter Position...">
                        </div>

                        <div>
                            <label for="coordinatorEmail">Email</label>
                            <input type="text" id="coordinatorEmail" name="coordinatorEmail" placeholder="Enter Email...">
                            
                        </div>
                    </div>
                    <label for="coordinatorPass">Password</label>
                    <input type="text" id="coordinatorPass" name="coordinatorPass" placeholder="Enter Password...">
                </div>
                
                <div class="btn-container">
                    <button type="button" class="btn-cancel" onclick="cancelForm()">Cancel</button>
                    <input type="hidden" name="action" value="add" />
                    <button class="btn-publish">Add Coordinator</button>
                  </div>
            </form>

        </div>
    </div>
    <script>
        function cancelForm() {
            if (confirm('Are you sure you want to cancel?')) {
                document.getElementById('application-form').reset();
                window.location.href='coordinator.jsp'; 
            }
        }
    </script>
              
  </body>

</html>