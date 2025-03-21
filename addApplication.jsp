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
        String query = "SELECT applicationID FROM (SELECT applicationID FROM Application_Details ORDER BY applicationID DESC) WHERE ROWNUM = 1";
        PreparedStatement stmt = conn.prepareStatement(query);
        ResultSet rs = stmt.executeQuery();

        if (rs.next()) {
            String lastID = rs.getString("applicationID");
            int numberPart = Integer.parseInt(lastID.substring(2)); // Extract numeric part
            String newID = "AP" + String.format("%03d", numberPart + 1); // Increment and format
            generatedID = newID;
        } else {
            // If no records exist, start with CO001
            generatedID = "AP001";
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
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>New Application</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@100..900&family=Quicksand:wght@500&display=swap" rel="stylesheet">
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
      width: 90%;
      padding: 0 20px;
      max-width: 800px; 
      height: 100vh;
    }

    .form-container {
      display: flex;
      flex-direction: column;
      gap: 20px;
      width: 100%;
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
      width: 100%;
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

    /* Adjust the table or form fields for smaller screens */
@media (max-width: 768px) {
  .container {
    width: 100%; /* Expand to full width for smaller screens */
    padding: 10px; /* Reduce padding for smaller viewports */
    margin: 0 auto; /* Keep it centered */
  }

    .form-container {
      width: 90%; /* Increase the width to take up more space */
      padding: 20px; /* Add some padding for better spacing */
    }

    .form-fields {
      min-width: 100%; /* Make fields take up full width */
    }

    .form-fields label {
      font-size: 14px; /* Slightly smaller text for labels */
    }

    .form-fields input,
    .form-fields select,
    .form-fields textarea {
      font-size: 1rem; /* Keep input text readable */
      padding: 12px; /* Add extra padding for better usability */
    }

    .inline-fields {
      flex-direction: column; /* Stack the fields vertically */
      gap: 15px; /* Add spacing between stacked fields */
    }

    .btn-container {
      justify-content: center; /* Center buttons for better alignment */
      flex-direction: column; /* Stack buttons vertically */
      gap: 10px; /* Add space between buttons */
    }

    .btn-publish,
    .btn-cancel {
      width: 100%; /* Make buttons full-width for small screens */
    }
  }
  </style>

  <body>
    <div class="container">
        <div class="form-container">
        <!-- Form Header -->
            <div class="form-header">
              <h1>New Application Details</h1>
            </div>

            <!-- Form Fields -->
            <div class="form-body">
                <form action="applicationController" method="POST" id="application-form">
                    <div class="form-fields">
                      <label for="opportunityTitle">Opportunity Title</label>
                      <input type="text" id="opportunityTitle" name="applicationTitle" placeholder="Enter the title of the relief effort..." required>

                      <div class="inline-fields">
                          <div>
                              <label for="location">Application ID</label>
                              <input type="text" id="applicationID" name="applicationID" value="<%= generatedID %>" readonly>
                          </div>
                          <div>
                              <label for="location">Location</label>
                              <select id="location-id" name="location" required>
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

                      <label for="description">Relief Effort Description</label>
                      <textarea id="description" name="applicationDesc" placeholder="Provide a detailed description of the disaster and relief efforts..." required></textarea>

                      <div class="inline-fields">
                        <div>
                          <label for="date">Date</label>
                          <input type="date" id="date" name="applicationDate" required>
                        </div>

                        <div>
                          <label for="status">Status Application</label>
                          <select id="status" name="applicationStatus" class="filter-dropdown">
                            <option value="all-status" selected>All Status</option>
                            <option value="Open">Open</option>
                            <option value="Ongoing">Ongoing</option>
                            <option value="Closed">Closed</option>
                          </select>
                        </div>
                      </div>
                  </div>
                    <!-- Buttons -->
                    <div class="btn-container">
                      <button type="button" class="btn-cancel" onclick="cancelForm()">Cancel</button>
                      <input type="hidden" name="action" value="Add">
                      <button class="btn-publish">Publish Volunteer Application</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    <script>
        function cancelForm() {
            if (confirm('Are you sure you want to cancel?')) {
                document.getElementById('application-form').reset();
                window.location.href='applicationDetails.jsp'; 
            }
        }
    </script>
  </body>
</html>
