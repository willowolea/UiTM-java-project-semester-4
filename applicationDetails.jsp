<%@page import="java.sql.Connection"%>
<%@ include file="sidebarAdmin.jsp" %>

<%@ page import="java.sql.*" %>

<!DOCTYPE html>
<html lang="en">
  <head>
    
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE-edge">
    <meta name="viewport" content="width-device-width", initial-scale="1.0">
    
    <link rel="icon" type="image/icon" href="">
    <title>Application Details</title>

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
    
    .input-container .button-print-coordinator {
        background-color: #266433;
        color: #F4F6DD;
        border: none;
        border-radius: 15px;
        padding: 10px 15px;
        cursor: pointer;
    }

    .button-print-coordinator:hover{
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
        justify-content: center;
        align-items: flex-start;
        flex-direction: column;
        margin-bottom: 20px;
        gap: 20px;
    }
  
    .filter-dropdown {
      width: 200px;
      padding: 10px;
      font-size: 14px;
      border: none;
      border-radius: 15px;
      background-color: #266433; /* Background color */
      color: #fff; /* Text color */
      outline: none;
      cursor: pointer;
      transition: background-color 0.3s ease, color 0.3s ease;
    }
  
    .filter-dropdown:focus {
      background-color: #266433;
    }
  
    .filter-dropdown option {
      background-color: #fff;
      color: #266433;
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
        padding: 15px 15px 15px; /* Reduced the padding to 10px from 15px */
        text-align: center;
        border-bottom: 1px solid #266433;
        border-top: 1px solid #266433;
    }
    
    .table-container .location-title, .table-container .location-name,
    .table-container .coordinator-title, .table-container .coordinator-name {
        text-align: left;
    }

    .table-container td:nth-child(3){
      width: 335px; /* Adjust this width as necessary */
  }
  
  /* You can also adjust this for the header of the description column */
  .table-container th:nth-child(3) {
      width: 335px; /* Same width for consistency */
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

/*    @media (max-width: 768px) {
      .search-container {
          flex-direction: column;  Stack elements vertically 
          align-items: stretch;  Make items full width 
          gap: 15px;  Increase gap for better spacing 
      }
  
      .input-container {
          justify-content: center;  Center the button on smaller screens 
      }
  
      .button-create-application {
          width: 100%;  Full-width button for smaller screens 
          text-align: center;  Center the button text 
      }
    }*/
  </style>
  <body>
    <main class="main-container">
        <h1>Application Details</h1>
        <div class="main-title">
            <div class="search-container">
                <input type="text" id="search-input" placeholder="Search Application" class="search-box">
                <button id="search-button"><i class="fa-solid fa-magnifying-glass"></i></button>

                <div class="input-container">
                    <!--<button class="button-print-coordinator" onclick="window.print();">Print</button>-->
                    <a href="addApplication.jsp"><button class="button-create-application">Create New Application</button></a>
                </div>
            </div>
        </div>

        <div class="sorting-container">
          <div class="icon" id="display-container-category">
            <!-- Sorting by Location -->
            <select id="sortLocation" class="filter-dropdown">
              <option value="all-locations" selected>All Locations</option>
              <option value="asc">A-Z</option>
              <option value="desc">Z-A</option>
            </select>

            <select id="sortStatus" class="filter-dropdown">
              <option value="all-status" selected>All Status</option>
              <option value="open">Open</option>
              <option value="ongoing">Ongoing</option>
              <option value="closed">Closed</option>
            </select>
          </div>
        </div>

        <div class="table-container">
            <table>
              <thead>
                <tr>
                  <!--<th><input type="checkbox"></th>-->
                  <th>Application ID</th>
                  <th class="location-title">Location</th>
                  <th>Application Title</th>
                  <th>Description</th>
                  <th>Status</th>
                  <th>Date Submitted</th>
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
                            String query = "SELECT ad.*, sl.serviceAddress FROM Application_Details ad JOIN Service_Location sl ON ad.serviceID = sl.serviceID ORDER BY ad.applicationID ASC";
                            stmt = conn.prepareStatement(query);
                            rs = stmt.executeQuery();

                            while(rs.next()){
                                
                %>
                <tr>
                  <!--<td><input type="checkbox"></td>-->
                  <td><%=rs.getString("applicationID") %></td>
                  <td class="location-name"><%=rs.getString("serviceAddress") %></td>
                  <td><%=rs.getString("applicationTitle") %></td>
                  <td><%=rs.getString("applicationDesc") %></td>
                  <td class="application-status"><%=rs.getString("applicationStatus") %></td>
                  <td><%=rs.getDate("applicationDate") %></td>
                  <td class="action-container">
                    <a href="updateApplication.jsp?applicationID=<%=rs.getString("applicationID") %>"><button class="edit-button"><i class="fa-solid fa-pen-to-square"></i> </button></a>
                    <a href="javascript:void(0);" onclick="deleteItem('Application_Details', 'applicationID', '<%= rs.getString("applicationID") %>')">
                        <button class="edit-button">
                            <i class="fa-solid fa-trash"></i>
                        </button>
                    </a>
                  </td>
                </tr>
                <% 
                            }
                        }  catch (SQLException e) {
                            out.println("Error Retrieving list record: " + e.getMessage());
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
  </body>
  <script>
      document.getElementById("search-button").addEventListener("click", function () {
            const searchBox = document.querySelector(".search-box").value.toLowerCase();
            const tableRows = document.querySelectorAll("tbody tr");

            tableRows.forEach((row) => {
            const applicationID = row.children[0].textContent.toLowerCase();
            const applicationLocation = row.children[1].textContent.toLowerCase();
            const applicationName = row.children[2].textContent.toLowerCase();
            const applicationStt = row.children[4].textContent.toLowerCase();

              if (applicationID.includes(searchBox) || applicationLocation.includes(searchBox) || applicationName.includes(searchBox) || applicationStt.includes(searchBox)) {
                row.style.display = ""; // Show matching rows
                } else {
                  row.style.display = "none"; // Hide non-matching rows
                }
            });
      });
      
      document.getElementById("sortLocation").addEventListener("change", function () {
            const sortValue = this.value; // Get the selected sorting value
            const tableRows = Array.from(document.querySelectorAll("tbody tr")); // Get all table rows

            if (sortValue === "asc") {
                // Sort rows alphabetically by Coordinator Name
                tableRows.sort((a, b) => {
                    const nameA = a.querySelector(".location-name").textContent.toLowerCase();
                    const nameB = b.querySelector(".location-name").textContent.toLowerCase();
                    return nameA.localeCompare(nameB);
                });
            } else if (sortValue === "desc") {
                // Sort rows in reverse alphabetical order by Coordinator Name
                tableRows.sort((a, b) => {
                    const nameA = a.querySelector(".location-name").textContent.toLowerCase();
                    const nameB = b.querySelector(".location-name").textContent.toLowerCase();
                    return nameB.localeCompare(nameA);
                });
            } else 
                location.reload();

            // Reorder the table rows
            const tbody = document.querySelector("tbody");
            tbody.innerHTML = ""; // Clear the current rows
            tableRows.forEach((row) => tbody.appendChild(row)); // Append sorted rows
        });

        document.getElementById("sortStatus").addEventListener("change", function () {
            const sortValue = this.value; // Get the selected sorting value
            const tableRows = Array.from(document.querySelectorAll("tbody tr")); // Get all table rows

            if (sortValue === "all-status") {
                // Show all rows when "All Status" is selected
                tableRows.forEach((row) => {
                    row.style.display = ""; // Reset to default display
                });
            } else {
                // Filter rows based on the selected status
                tableRows.forEach((row) => {
                    const status = row.querySelector(".application-status").textContent.toLowerCase(); // Get the status from the row
                    if (status === sortValue) {
                        row.style.display = ""; // Show matching rows
                    } else {
                        row.style.display = "none"; // Hide non-matching rows
                    }
                });
            }
        });
        
                //Status Labeling Color
                document.addEventListener("DOMContentLoaded", function() {
                    const statusCells = document.querySelectorAll('.application-status');

                    statusCells.forEach(function(cell) {
                    const statusText = cell.innerText.trim(); // Get the status text

                    if (statusText === "Open") {
                        cell.style.color = "green"; 
                        cell.style.fontWeight = "bold"; 
                        cell.style.fontSize = "16px";
                        cell.style.textShadow = "0 0 10px rgba(0, 255, 0, 0.8), 0 0 20px rgba(0, 255, 0, 0.6)"; // Green glow
                    } else if (statusText === "Closed") {
                        cell.style.color = "red";
                        cell.style.fontWeight = "bold"; 
                        cell.style.fontSize = "16px";
                        cell.style.textShadow = "0 0 10px rgba(255, 0, 0, 0.4), 0 0 20px rgba(255, 0, 0, 0.3)"; // Lighter red glow
                    } else if(statusText === "Ongoing") {
                        cell.style.color = "#d4a017"; // Dark yellow text
                        cell.style.fontWeight = "bold"; 
                        cell.style.fontSize = "16px";
                        cell.style.textShadow = "0 0 8px rgba(255, 255, 0, 0.6), 0 0 12px rgba(255, 215, 0, 0.5)"; // Subtle yellow glow
                    }
                    });
                });        

    function deleteItem(table, primaryKey, keyValue) {
            // Construct the URL with parameters to the deleteServlet
            var url = "deleteServlet?table=" + table + "&primarykey=" + primaryKey + "&exprimkey=" + keyValue;
            
            // Redirect the user to the deleteServlet
            if (confirm("Are you sure you want to delete this item?")) {
                window.location.href = url; // Navigate to the deleteServlet URL
            }
        } 
  </script>
</html>