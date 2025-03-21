<!DOCTYPE html>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>
<%@ page import="javax.servlet.http.*, java.io.*, java.sql.*" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>


<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE-edge">
    <meta name="viewport" content="width-device-width", initial-scale="1.0">

    <link rel="icon" type="image/icon" href="">
    <title>Volunteer Application</title>

    <!-- <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;700&family=Nunito:wght@300;400;700&display=swap" rel="stylesheet"> -->
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:ital,wght@0,100;0,200;0,300;0,400;0,500;0,600;0,700;0,800;0,900;1,100;1,200;1,300;1,400;1,500;1,600;1,700;1,800;1,900&display=swap" rel="stylesheet">

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <script src="https://kit.fontawesome.com/939a0fa897.js" crossorigin="anonymous"></script>
    <link href='https://unpkg.com/boxicons@2.0.7/css/boxicons.min.css' rel='stylesheet'>

    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css" rel="stylesheet">
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

    <style>
        body{
            height: 100%;
            min-height: 100vh;
            background: #F4F6DD;
            display: flex; /* Enable flex layout */
            flex-direction: column; 
        }
        
        *{ 
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Poppins', sans-serif;
        }
        
        .grid-container {
            display: grid;
            grid-template-columns: 260px 1fr 1fr 1fr;
            grid-template-rows: auto 1fr;
            grid-template-areas: 
            "sidebar header header header"
            "sidebar main main main";
            flex: 1;
            width: 100%;
        }
        
        .header {
            grid-area: header;
            height: 70px;
            background-color: #F4F6DD;
            display: flex;
            align-items: center;
            justify-content: flex-end;
            padding: 0 30px 0 30px;
            box-shadow: 0 6px 7px -4px rgba(0, 0, 0, 0.2);
            cursor: pointer;
        }
     
        /* SIDEBAR*/
        .logo {
            display: flex;
            justify-content: center;  /* Center horizontally */
            align-items: center;      /* Center vertically */
            width: 100%;              /* Ensure it takes up full width */
            margin-bottom: 20px;
            margin-top: 20px;   
        }

        .logo-img {
            height: 80px;
            width: auto;
        }

        .sidebar {
            width: 250px;
            height: 100%;
            background-color: #388e3c;
            color: white;
            display: flex;
            flex-direction: column;
            position: fixed;
            left: 0;
            top: 0;
            padding: 6px 14px;
            z-index: 99;
            transition: all 0.5s ease;
        }

        .sidebar-link {
            text-decoration: none;
            color: white;
            margin: 15px 0;
            font-size: 18px;
            display: block;
            padding: 10px 15px;
            border-radius: 5px;
            text-align: center;
            transition: background-color 0.3s ease;
        }

        .sidebar-link.active {
            background-color: #2e7d32;
            font-weight: 600;
        }

        .section.active {
            display: block;
        }

        .sidebar h2 {
            padding: 8px;
            margin-bottom: 30px;
            font-size: 30px;
        }

        .sidebar a {
            display: flex;
            align-items: center;
            gap: 10px;
            text-decoration: none;
            color: white;
            margin: 16px 0;
            font-size: 16px;
            padding: 10px 15px;
            border-radius: 5px;
            transition: background-color 0.3s ease;
        }

        .sidebar a.active {
            background-color: #2e7d32;
            font-weight: 600;
        }

        .sidebar a:hover {
            background-color: #4caf50;
        }
        /* END SIDEBAR*/

        .main-container {
            flex: 1;
            margin-left: 260px;
            padding: 20px;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            height: 100vh;
            overflow-y: auto;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 10px;
        }

        table,
        th,
        td {
            border: 1px solid #000;
        }

        th,
        td {
            padding: 10px;
            text-align: left;
        }

        th {
            background-color: #388e3c;
            color: white;
        }

        .input-container .button-create-application {
            background-color: #f06838;
            color: #F4F6DD;
            border: none;
            border-radius: 15px;
            padding: 10px 15px;
            cursor: pointer;
            transition: background-color 0.3s, color 0.3s;
        }
      
        .button-create-application:hover{
              background-color: #bee097;
              color: #266433;
        }

        .content {
            flex: 1;
            padding: 20px;
            overflow-y: auto;
        }

        .section {
            margin-bottom: 30px;
            padding: 20px;
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }

        .section h3 {
            font-weight: 600;
            font-size: 26px;
            margin-bottom: 20px;
        }

        .action-container .apply-button {
            background: #45a049;
            padding: 10px 10px 10px;
            border: none;
            cursor: pointer;
            font-size: 14px;
            border-radius: 15px;
            color: #ffffff;
          }
          
        .apply-button:hover {
            background-color: #bee097; /* A dark gray for edit buttons */
            color: #266433;
        }

        /* Center the modal content */
        .modal-content {
            width: 100%; 
            max-width: 900px; 
            max-height: 80%;
            height: auto; 
            border-radius: 15px;
            background-color: #388e3c;
            border: 1px solid gray;
            color: white;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.5);
            display: block;
            padding: 30px;
            overflow-y: auto;
            position: relative; /* Added to allow the close button to be positioned relative to the modal content */
            margin: 0 auto; /* Center horizontally */
            margin-top: 40px;
        }

        /* Center the modal itself */
        .modal {
            display: none; 
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.8); 
            justify-content: center; 
            align-items: center;
        }

        /* Adjusting the body when modal is open */
        body.modal-open {
            overflow: hidden; /* Prevent scrolling when the modal is open */
        }

        .close-btn {
            position: absolute;
            top: 10px;
            right: 20px;
            font-size: 30px;
            color: white;
            cursor: pointer;
            font-weight: bold;
        }
        
        .close-btn:hover {
            color: #f44336;
        }        

        .application-box {
            width: 100%; 
            max-width: 900px;
            background-color: #388e3c;
            border: 1px solid gray;
            border-radius: 15px;
            padding: 20px;
            color: white;
            margin-left: 20px;
            position: relative;
            box-shadow: rgba(50, 50, 93, 0.25) 0px 2px 5px -1px, rgba(0, 0, 0, 0.3) 0px 1px 3px -1px; 
        }

        /* Form styling */
        .form-group {
            margin-bottom: 15px; /* More compact spacing between form fields */
        }

        .form-group input,
        .form-group select,
        .form-group textarea {
            width: 100%; 
            padding: 10px;
            margin: 5px 0; 
            border-radius: 8px;
            border: 1px solid gray;
            font-size: 14px;
            box-sizing: border-box;
            height: 40px;
        }

        .inline-fields {
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

        /* Buttons */
        .btn-container button {
            padding: 10px 15px; /* Compact button padding */
            font-size: 16px;
            width: 100%; /* Full width for buttons */
            border-radius: 8px;
        }

        .form-group label {
            font-size: 16px;
            font-weight: bold;
        }

        .form-group .radio-wrapper-10 {
            display: flex;
            font-family: "Courier New", monospace;
            font-weight: bold;
        }

        @media (max-width: 48em) {
            .form-group .radio-wrapper-10 {
                flex-direction: column;
                align-items: flex-start;
                text-align: left;
            }
        }

        .form-group .radio-wrapper-10 label {
            position: relative;
            display: inline-block;
            margin: 10px;
        }

        @media (max-width: 48em) {
            .form-group .radio-wrapper-10 label {
                display: block;
                margin: 10px 0;
            }
        }

        .form-group .radio-wrapper-10 label input {
            opacity: 0;
            position: absolute;
        }

        .form-group .radio-wrapper-10 label .inner-label {
            position: relative;
            display: inline-block;
            padding-left: 40px;
        }

        .form-group .radio-wrapper-10 label .inner-label:before {
            content: "";
            position: absolute;
            left: 0;
            bottom: 0;
            border-bottom: 1px dashed rgba(0, 0, 0, 0.25);
            width: 30px;
            transition: border-bottom 0.5s ease;
        }

        .form-group .radio-wrapper-10 label input:focus ~ .inner-label:before {
            border-bottom: 1px solid rgba(0, 0, 0, 0.75);
        }

        .form-group .radio-wrapper-10 label input:checked ~ .inner-label:after {
            content: "✓";
            color: #000;
            position: absolute;
            font-size: 1em;
            left: 12px;
            top: 1px;
        }

        .btn-container {
            display: flex;
            justify-content: space-between;
            width: 250px;
            gap: 15px;
            height: 40px;
        }

        .btn-submit {
            background-color: #4caf50;
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            padding: 10px;
            cursor: pointer;
        }

        .btn-cancel {
            background-color: #f44336;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 8px;
            font-size: 16px;
            cursor: pointer;
        }

        .btn-submit:hover {
            background-color: #45a049;
        }

        .btn-cancel:hover {
            background-color: #e53935;
        }

        /* Responsive Sidebar */
        @media (max-width: 768px) {
            .sidebar {
                transform: translateX(-100%);
            }

            .sidebar.show {
                transform: translateX(0);
            }

            .toggle-btn {
                position: fixed;
                top: 10px;
                left: 10px;
                z-index: 1000;
                background-color: #266533;
                color: white;
                border: none;
                font-size: 24px;
                padding: 5px 10px;
                cursor: pointer;
                border-radius: 5px;
            }
        }
    </style>
</head>
<body>
    <%
            String volunteerID = (String) session.getAttribute("volunteerID");
            if (volunteerID == null) {
                response.sendRedirect("LoginPage.jsp"); // Redirect to login if not logged in
                return;
            }
        %>
    <!-- Sidebar -->
    <div class="sidebar">
        <div class="logo">
            <img src=".\img\logo.png" class="logo-img">
        </div>

        <a href="userDashboard"><i class="fa-solid fa-chart-simple"></i>Dashboard</a>
        <a href="userProfileController"><i class="fas fa-user"></i>User Profile</a>
        <a href="shelterLocation.jsp"><i class="fas fa-map-marker-alt"></i>Service Locations</a>
        <a href="userHistoryController?volunteerID=<%=volunteerID%>"><i class="fas fa-history"></i>Volunteering History</a>
        <a href="DonationController"><i class="fa fa-box"></i>Donation</a>
        <a href="SubmitApplicationController" class="active"><i class="fa fa-clipboard"></i>Submit Application</a>
        <a href="userLogout"><i class="fa-solid fa-right-from-bracket"></i>Log out</a>
    </div>

    <main class="main-container">
        <div class="content">
            <div class="section">
                <!--<p>Debug: Logged-in Volunteer ID = ${volunteerID}</p>-->
                
                <h3>Volunteer Application List</h3>
                <table>
                <thead>
                    <tr>
                        <th style="width:90px; text-align:center;">Application ID</th>
                        <th>Application Title</th>
                        <th>Location</th>
                        <th>Description</th>
                        <th style="width:50px; text-align:center;">Status</th>
                        <th style="width:120px; text-align:center;">Date Open</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach items="${applications}" var="app">
                        <tr>
                            <td style="width:90px; text-align:center;">${app.applicationId}</td>
                            <td>${app.title}</td>
                            <td>${app.location}</td>
                            <td>${app.description}</td>
                            <td style="width:50px; text-align:center;">${app.status}</td>
                            <td style="width:120px; text-align:center;">${app.dateOpen}</td>
                            <td class="action-container">
                                <button class="apply-button" onclick="showModal('${app.applicationId}')">Apply</button>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
                </table>
            </div>
        </div>
        
        <!-- Modal (Hidden initially) -->
        <div id="applicationModal" class="modal">
            <div class="modal-content">
                <span class="close-btn" onclick="closeModal()">&times;</span>
                <%
    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;

    String fullName = null, age = null, gender = null, address = null, noTel = null;

    try {
        // Retrieve volunteerID from session
        volunteerID = (String) session.getAttribute("volunteerID");
        if (volunteerID == null || volunteerID.isEmpty()) {
            out.println("<p style='color: red;'>Volunteer ID is not set in the session.</p>");
            return;
        }

        // Database connection
        Class.forName("oracle.jdbc.driver.OracleDriver");
        conn = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe", "MYCONNECTION", "system");

        // SQL query
        String query = "SELECT * FROM Volunteer WHERE volunteerID = ?";
        stmt = conn.prepareStatement(query);
        stmt.setString(1, volunteerID);

        // Execute query and fetch data
        rs = stmt.executeQuery();

        if (rs.next()) {
            fullName = rs.getString("fullName");
            age = rs.getString("age");
            gender = rs.getString("gender");
            noTel = rs.getString("volunteerNotel");
            address = rs.getString("address");
        } else {
            out.println("<p style='color: red;'>No record found for volunteerID: " + volunteerID + "</p>");
        }
%>
                <h2>Submit Application</h2>
                <form action="SubmitApplicationController" method="POST">
                    <input type="hidden" id="applicationID" name="applicationId">
                        <div class="inline-fields">
                            <div class="form-group">
                                <label for="userID">User ID:</label>
                                <input type="text" id="userID" name="userID" 
                                       value="<%= volunteerID %>" required readonly>
                            </div>

                            <div class="form-group">
                                <label for="full-name">Full Name:</label>
                                <input type="text" id="full-name" name="full-name" 
                                       value="<%= fullName %>" required>
                            </div>
                        </div>

                        <div class="inline-fields">
                            <div class="form-group">
                                <label for="phone">Phone Number:</label>
                                <input type="text" id="phone" name="phone" 
                                       value="<%= noTel %>" required>
                            </div>

                            <div class="form-group">
                                <label for="age">Age:</label>
                                <input type="text" id="age" name="age" 
                                       value="<%= age %>" required>
                            </div>

                            <div class="form-group">
                                <label>Gender:</label>
                                <div class="radio-wrapper-10">
                                    <label for="male">
                                        <input id="male" type="radio" name="gender" value="Male" <%= "Male".equals(gender) ? "checked" : "" %>>
                                        <span class="inner-label">Male</span>
                                    </label>
                                    <label for="female">
                                        <input id="female" type="radio" name="gender" value="Female" <%= "Female".equals(gender) ? "checked" : "" %>>
                                        <span class="inner-label">Female</span>
                                    </label>
                                </div>
                            </div>
                        </div>

                        <div class="inline-fields">
                            <div class="form-group">
                                <label for="date">Date:</label>
                                <input type="date" id="date" name="date" required>
                            </div>

                            <div class="form-group">
                                <label for="status-name">Status Application:</label>
                                <input type="text" id="status-name" name="status-name" value="Pending" readonly>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="address">Address:</label>
                            <textarea id="address" name="address" required rows="3"><%= address %></textarea>
                        </div>
  

                    <div class="btn-container">
                        <button type="submit" class="btn-submit">Submit</button>
                        <button type="button" class="btn-cancel" onclick="closeModal()">Cancel</button>
                    </div>
                </form>
                <%
                        } catch (SQLException e) {
                    e.printStackTrace();
                    out.println("<p style='color: red;'>Database error: " + e.getMessage() + "</p>");
                } finally {
                    if (rs != null) rs.close();
                    if (stmt != null) stmt.close();
                    if (conn != null) conn.close();
                }
                %>
            </div>
        </div>
    </main>
    <script>
        function showModal(applicationId) {
            // Set the application ID in the hidden input
            const applicationInput = document.getElementById('applicationID');
            if (applicationInput) {
                applicationInput.value = applicationId;
            } else {
                console.error("Hidden input #applicationID not found");
            }

            // Display the modal
            const modal = document.getElementById('applicationModal');
            if (modal) {
                modal.style.display = 'flex'; // Change display to flex to show modal
            } else {
                console.error("Modal #applicationModal not found");
            }
        }

        function closeModal() {
            // Hide the modal
            const modal = document.getElementById('applicationModal');
            if (modal) {
                modal.style.display = 'none';
            }
        }

        
//        // Add this to your existing script section
//        window.onload = function() {
//            const gender = "<%= gender %>"; // Retrieve the gender from the server-side
//            if (gender) {
//                const genderInput = document.querySelector(`input[name="gender"][value="${gender}"]`);
//                if (genderInput) {
//                    genderInput.checked = true; // This visually sets the radio button to checked
//                }
//            }
//        };
    </script>
    
</body>
</html>