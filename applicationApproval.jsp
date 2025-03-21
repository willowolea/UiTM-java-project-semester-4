<%@page import="util.DBConnection"%>
<%@ include file="sidebarAdmin.jsp" %>

<%@page import="java.sql.Connection"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE-edge">
    <meta name="viewport" content="width-device-width", initial-scale="1.0">
    
    <link rel="icon" type="image/icon" href="">
    <title>Application Approval</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:ital,wght@0,100..900;1,100..900&family=Quicksand:wght@500&display=swap" rel="stylesheet">
        
    <script src="https://kit.fontawesome.com/939a0fa897.js" crossorigin="anonymous"></script>
    <link href='https://unpkg.com/boxicons@2.0.7/css/boxicons.min.css' rel='stylesheet'>
    
    <script>
        window.onload = function() {
            var message = "<%= request.getAttribute("message") != null ? request.getAttribute("message") : "" %>";
            if (message) {
                alert(message); // Display the pop-up message
            }
        };
    </script>
    
    <%-- Check for the popupMessage in the session --%>
    
    <%
        String popupMessage = (String) session.getAttribute("popupMessage");
        if (popupMessage != null) {
    %>
        <script>
            // Display the popup message
            alert("<%= popupMessage %>");
        </script>
    <%
            session.removeAttribute("popupMessage"); // Remove the message after displaying
        }
    %>
  </head>
  <style>
    body{
        display: grid;
        grid-template-columns: 5px 1fr; /* Sidebar is 250px, main content fills remaining space */
        grid-template-rows: 100vh; /* Full viewport height */
        grid-template-areas: "sidebar main";
        height: 100vh;
        margin: 0;
        background: #F4F6DD;
      }
  
    *{
        margin: 0;
        padding: 0;
        box-sizing: border-box;
        font-family: 'Montserrat', sans-serif;
        font-family: "Quicksand", sans-serif;
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
    
    .main-container {
        position: relative;
        min-height: 100vh;
        left: 78px; /* Matches the closed sidebar width */
        top: 0;
        width: calc(100% - 78px); /* Adjust based on sidebar width */
        transition: all 0.5s ease;
        z-index: 2;
        grid-area: main;
        overflow-y: auto;
        padding: 20px 20px;
    }
    
    .sidebar.open ~ .main-container {
        left: 250px; /* Adjust the left position when the sidebar is open */
        width: calc(100% - 250px);
        overflow-y: hidden;
    }
  
    .search-container {
      display: flex;
      align-items: center; 
      justify-content: space-between; 
      gap: 10px;
      margin-bottom: 20px;
      width: 100%;
      }
  
    .search-box-container {
        gap: 10px;
    }
  
    .search-box {
        padding: 10px;
        border: 1px solid #ddd;
        border-radius: 15px;
        width: 250px;
    }
  
    #search-button {
        background-color: #266433;
        margin-left: 5px;
        color: #F4F6DD;
        border: none;
        padding: 10px 10px;
        border-radius: 15px;
        cursor: pointer;
        width: 50px;
    }
  
    .input-container {
        display: flex;
        align-items: center;
        gap: 10px; 
        justify-content: flex-end;
        flex-grow: 1;
    }
  
    .input-container .button-print-application {
        background-color: #f06838;
        color: #F4F6DD;
        border: none;
        border-radius: 15px;
        padding: 10px 15px;
        cursor: pointer;
        
    }
  
    .button-print-application:hover{
          background-color: #bee097;
          color: #266433;
    }
  
    .main-container h1 {
        font-size: x-large;
        font-weight: bold;
        margin-bottom: 20px;
        padding-bottom: 15px; /* Adjust padding */
        border-bottom: 1px solid #266433;
        width: 100%; /* Match the table's width */
    }
  
    .button {
        background-color: #266433;
        color: #F4F6DD;
        border: none;
        border-radius: 15px;
        padding: 10px 15px;
        cursor: pointer;
    }
  
    .sorting-container {
        display: flex;
        gap: 10px;
        margin-bottom: 30px;
    }
    
    .sorting-container button{
        background-color: #266433;
        color: #F4F6DD;
        border: none;
        padding: 8px 12px;
        border-radius: 15px;
        height: 40px;
        cursor: pointer;
    }
    
    .filter-button.active {
        background-color: #bee097; /* Highlight color for the active button */
        color: #266433; /* Text color for the active button */
    }
          
    .table-container {
        width: 100%; /* Adjust to take up the full width of the parent */
        overflow-x: auto;
        margin-top: 20px;
    }
          
    .table-container table {
        width: 100%; /* Table spans the full container width */
        border-collapse: collapse;
    }
          
    .table-container th, .table-container td {
        padding: 15px 15px 15px;
        text-align: center;
        border-bottom: 1px solid #266433;
        border-top: 1px solid #266433;
    }
      
    .table-container .location-title, .table-container .location-name,
    .table-container .coordinator-title, .table-container .coordinator-name {
        text-align: left;
    }

    .table-container td:nth-child(3), td:nth-child(4) {
        width: 200px; /* Adjust this width as necessary */
    }
    
    /* You can also adjust this for the header of the description column */
    .table-container th:nth-child(3),th:nth-child(4) {
        width: 200px; /* Same width for consistency */
    }
          
    .table-container th {
        color: #266433;
        font-weight: bold;
    }
          
    .table-container tbody tr:hover {
        background-color: #ddd;
    }
          
    .table-container td input[type="checkbox"] {
        margin: 0;
        padding: 0;
    }
      
    .action-container{
        gap: 5px;
    }
          
    .action-container .edit-button {
        background: #e2dc50;
        padding: 10px 10px 10px;
        border: none;
        cursor: pointer;
        font-size: 14px;
        border-radius: 15px;
        color: #266433;
      }
      
    .edit-button:hover {
        background-color: #f06838; /* A dark gray for edit buttons */
        color: #F4F6DD;
    }
  </style>
  <body>
    <main class="main-container">
        <h1>Application Approval</h1>
        <div class="main-title">
            <div class="search-container">
                <input type="text" id="search-input" placeholder="Search Application" class="search-box">
                <button id="search-button" onclick="searchApplication()"><i class="fa-solid fa-magnifying-glass"></i></button>

                <div class="input-container">
                    <!--<button class="button-print-application" id="printarea">Print</button>-->
                </div>
            </div>
        </div>

        <div class="sorting-container">
                <div class="icon" id="display-container-category">
                    <button class="filter-button active" value="all">All</button>
                    <button class="filter-button" value="status">Status</button>
                    <button class="filter-button" value="date">Date</button>
                    <button class="filter-button" value="name">Coordinator</button>
                </div>
            </div>
        </div>

        <div class="table-container">
            <table>
                <thead>
                    <tr>
                        <!--<th><input type="checkbox" id="selectAllCheckbox"></th>-->
                        <th>Form ID</th>
                        <th>Application ID</th>
                        <th class="location-title">Location Name</th>
                        <th>Volunteer ID</th>
                        <th>Application Date</th>
                        <th>Status</th>
                        <th class="coordinator-title">Approved By</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                   <% 
                        Connection conn = null;
                        PreparedStatement stmt = null;
                        ResultSet rs = null; 

                        try {
                                conn = conn = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:XE", "MYCONNECTION", "system");
                                String query = "SELECT f.formID, f.applicationID, sl.serviceAddress, f.volunteerID,  f.formDate, f.formStatus, c.coordinatorName FROM Volunteer_Form f "
                                        + "LEFT JOIN Application_Details ad ON f.applicationID = ad.applicationID "
                                        + "LEFT JOIN Service_Location sl ON ad.serviceID = sl.serviceID LEFT JOIN Coordinator c ON f.coordinatorID = c.coordinatorID ORDER BY f.formID ASC";
                                
                            stmt = conn.prepareStatement(query);
                            rs = stmt.executeQuery();

                           while (rs.next()) {
              
                                String coordinatorName = rs.getString("coordinatorName");
                                    if (coordinatorName == null) {
                                        coordinatorName = "Not Assigned";
                                    }                                  
                    %>
                    <tr>
                        <!--<td><input type="checkbox" class="rowCheckbox"></td>-->
                        <td><%=rs.getString("formID") %></td>
                        <td><%=rs.getString("applicationID") %></td>
                        <td class="location-name"><%=rs.getString("serviceAddress") %></td>
                        <td><%=rs.getString("volunteerID") %></td>
                        <td><%=rs.getDate("formDate") %></td>
                        <td class="status"><%=rs.getString("formStatus") %></td>
                        <td class="coordinator-name"><%= coordinatorName %></td>
                        <td>
                            <div class="action-container">
                                <a href="viewApplication.jsp?formID=<%=rs.getString("formID") %>"><button class="edit-button"><i class="fa-solid fa-eye"></i></i></button></a>
                                <a href="javascript:void(0);" onclick="deleteItem('Volunteer_Form', 'formID', '<%= rs.getString("formID") %>')">
                                    <button class="edit-button">
                                        <i class="fa-solid fa-trash"></i>
                                    </button>
                                </a>
                            </div>
                        </td>
                    </tr>
                    <% 
                        }
                        }  catch (SQLException e) {
                            out.println("Error Retrieving form record: " + e.getMessage());
                        }  finally {
                            if (rs != null) rs.close();
                            if (stmt != null) stmt.close();
                            if (conn != null) conn.close();
                        }       
                    %>
                </tbody>
            </table>
        </div>
    </main>
            <script>
            function searchApplication() {
                    const searchInput = document.getElementById('search-input').value.trim().toLowerCase(); // Trim and convert input to lowercase
                    const tableBody = document.querySelector('.table-container tbody'); // Locate the table body
                    const rows = tableBody ? tableBody.getElementsByTagName('tr') : []; // Get all rows in the table body

                    if (!tableBody) {
                        console.error("Table body not found.");
                        return;
                    }

                    // Loop through each row and determine if it matches the search input
                    for (let row of rows) {
                        const cells = row.getElementsByTagName('td');
                        let rowText = '';

                        // Concatenate text from all relevant cells in the row
                        for (let i = 0; i < cells.length; i++) {
                            rowText += cells[i].textContent.toLowerCase() + ' ';
                        }

                        // Show or hide the row based on whether it contains the search input
                        if (rowText.includes(searchInput)) {
                            row.style.display = ''; // Show row
                        } else {
                            row.style.display = 'none'; // Hide row
                        }
                    }
                }
                
                document.getElementById('search-input').addEventListener('keypress', function (e) {
                    if (e.key === 'Enter') {
                        searchVolunteers();
                    }
                });


                // Sorting Function
                function sortTable(columnIndex, sortType = 'string') {
                    const tableBody = document.querySelector('.table-container tbody');
                    const rows = Array.from(tableBody.getElementsByTagName('tr'));

                    rows.sort((a, b) => {
                        let aValue = a.getElementsByTagName('td')[columnIndex].textContent.trim();
                        let bValue = b.getElementsByTagName('td')[columnIndex].textContent.trim();

                        // Handle different sorting types
                        if (sortType === 'number') {
                            return parseFloat(aValue) - parseFloat(bValue);
                        } else if (sortType === 'date') {
                            // Convert to Date objects for comparison
                            return new Date(bValue) - new Date(aValue);
                        } else {
                            // Default to string sorting
                            return aValue.localeCompare(bValue);
                        }
                    });

                    // Clear and repopulate table body
                    while (tableBody.firstChild) {
                        tableBody.removeChild(tableBody.firstChild);
                    }

                    rows.forEach(row => tableBody.appendChild(row));
                }


                // Event listeners
                document.querySelectorAll('.filter-button').forEach((button, index) => {
                    button.addEventListener('click', function () {
                        // Remove active class from all buttons
                        document.querySelectorAll('.filter-button').forEach(btn => btn.classList.remove('active'));
                        // Add active class to clicked button
                        this.classList.add('active');

                        // Determine sorting type and column index based on button value
                        switch (this.getAttribute('value')) {
                            case 'status':
                                sortTable(5, 'string'); // Sort by Status
                                break;
                            case 'date':
                                sortTable(4, 'date'); // Sort by Date
                                break;
                            case 'name':
                                sortTable(6, 'string'); // Sort by Coordinator Name
                                break;
                            case 'all':
                            default:
                                sortTable(1, 'string'); // Default to Form ID
                        }
                    });
                });
                
                
                //Status Labeling Color
                document.addEventListener("DOMContentLoaded", function() {
                    const statusCells = document.querySelectorAll('.status');

                    statusCells.forEach(function(cell) {
                    const statusText = cell.innerText.trim(); // Get the status text

                    if (statusText === "Approved") {
                        cell.style.color = "green"; 
                        cell.style.fontWeight = "bold"; 
                        cell.style.fontSize = "16px";
                        cell.style.textShadow = "0 0 10px rgba(0, 255, 0, 0.8), 0 0 20px rgba(0, 255, 0, 0.6)"; // Green glow
                    } else if (statusText === "Not Approved") {
                        cell.style.color = "red";
                        cell.style.fontWeight = "bold"; 
                        cell.style.fontSize = "16px";
                        cell.style.textShadow = "0 0 10px rgba(255, 0, 0, 0.4), 0 0 20px rgba(255, 0, 0, 0.3)"; // Lighter red glow
                    } else if(statusText === "Pending") {
                        cell.style.color = "#d4a017"; // Dark yellow text
                        cell.style.fontWeight = "bold"; 
                        cell.style.fontSize = "16px";
                        cell.style.textShadow = "0 0 8px rgba(255, 255, 0, 0.6), 0 0 12px rgba(255, 215, 0, 0.5)"; // Subtle yellow glow
                    }
                    });
                });
                
                //Delete Function
                function deleteItem(table, primaryKey, keyValue) {
                    // Construct the URL with parameters to the deleteServlet
                    var url = "deleteServlet?table=" + table + "&primarykey=" + primaryKey + "&exprimkey=" + keyValue;

                    // Redirect the user to the deleteServlet
                    if (confirm("Are you sure you want to delete this item?")) {
                        window.location.href = url; // Navigate to the deleteServlet URL
                    }
                } 

            </script>
  </body>
</html>