<%@page import="java.io.InputStream"%>
<%@page import="java.util.Base64"%>
<%@page import="java.io.IOException"%>

<%@ include file="sidebarAdmin.jsp" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
  <head>
    
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE-edge">
    <meta name="viewport" content="width-device-width", initial-scale="1.0">
    
    <link rel="icon" type="image/icon" href="">
    <title>Service Location</title>

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
    body{
        display: grid;
        grid-template-columns: 5px 1fr; /* Sidebar is 250px, main content fills remaining space */
        grid-template-areas: "sidebar main";
        grid-template-rows: 100vh; /* Full viewport height */
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

    .input-container .button-add-inventory {
        background-color: #f06838;
        color: #F4F6DD;
        border: none;
        border-radius: 15px;
        padding: 10px 15px;
        cursor: pointer;
    }

    .button-add-inventory:hover{
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
        width: 100%; 
        overflow-x: auto;
        margin-top: 20px;
    }
    
    .table-container table {
        width: 100%;
        border-collapse: collapse;
    }
    
    .table-container th, .table-container td {
        padding: 15px 15px 15px;
        text-align: center;
        border-bottom: 1px solid #266433;
        border-top: 1px solid #266433;
        width: auto;
    }

    .table-container .location-title, .table-container .location-name {
        text-align: left;
    }
    
    .table-container th {
        color: #266433;
        font-weight: bold;
        border-bottom: 1px solid #266433;
    }
    
    .table-container thead th {
    border-top: 1px solid #266433;
    }
    
    .table-container th:last-child {
    width: auto;
    }


    .table-container tbody tr:hover {
        background-color: #f9f7f7;
    }
    
    .table-container td input[type="checkbox"] {
        margin: 0;
        padding: 0;
    }

    .table-container td ul {
    margin: 0; 
    padding-left: 20px; 
    text-align: left; 
    }

    .location-name {
    max-width: 200px; /* Set a maximum width for the address cell */
    white-space: normal; /* Allow text to wrap to the next line */
    word-wrap: break-word; /* Break long words onto the next line if necessary */
    padding: 5px; /* Add padding if needed */
    }

    .status.full {
    background-color: #4CAF50; /* Softer green */
    box-shadow: 0 2px 5px rgba(0, 128, 0, 0.2); /* Light shadow for depth */
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
        background-color: #f06838; 
        color: #F4F6DD;
    }
    
    .action-container .image-button {
        background-color: black;
        color: #F4F6DD;
        padding: 10px 10px 10px;
        border: none;
        cursor: pointer;
        font-size: 16px;
        border-radius: 15px;
    }

    .image-button {
        position: relative;
        z-index: 1000;  /* Make sure the button is on top */
    }


    .image-button:hover{
        background: #bee097;
        color: #266433;
    }   
    
    .modal h3{
        color: #266433;
        font-size:25px;
        margin-bottom: 15px;
    }

    /* Modal styles */
    .modal {
        display: none; /* Hidden by default */
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

    /* Modal content */
    .modal-content {
        background-color: #fff;
        padding: 20px;
        border-radius: 10px;
        width: 80%;
        max-height: 90%;
        overflow-y: auto;
        position: relative;
        margin: auto;
        text-align: center;
    }

    /* Close button */
    .close {
        position: absolute;
        top: 10px;
        right: 20px;
        font-size: 30px;
        color: #333;
        cursor: pointer;
    }

    .close:hover {
        color: red;
    }

    /* Image gallery styles */
    .gallery {
        display: flex;
        flex-wrap: wrap;
        gap: 20px;
        justify-content: center;
    }

    .gallery img {
        width: 300px;
        height: 300px;
        object-fit: cover;
        border-radius: 5px;
        cursor: pointer;
        transition: transform 0.3s ease;
    }

    .gallery img:hover {
        transform: scale(1.1);
    }

  </style>
  <body>
    <main class="main-container">
        <h1>Service Location List</h1>

        <div class="main-title">
            <div class="search-container">
              <input type="text" id="search-input" placeholder="Search List" class="search-box">
              <button id="search-button"><i class="fa-solid fa-magnifying-glass"></i></button>
              
                <div class="input-container">
                    <a href="addServiceLocation.jsp">
                        <button class="button-add-inventory">Add New Service Location</button>
                      </a>                      
                </div>
            </div>
        </div>

        <div class="sorting-container">
            <div class="icon" id="display-container-category">
                <button class="filter-button active">All</button>
                <button class="filter-button">Name</button>
                <button class="filter-button">Total Capacity</button>
                <button class="filter-button">State</button>
            </div>
          </div>
        </div>

        <div class="table-container">
            <table>
                <thead>
                    <tr>
                        <!--<th><input type="checkbox"></th>-->
                        <th>ID</th>
                        <th>Coordinator ID</th>
                        <th>State ID</th>
                        <th class="location-title">Address</th>
                        <th>Total Capacity</th>
                        <th>Number of Volunteer</th>
                        <th>Job Description</th>
                        <th>Status</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        // Database connection
                        Connection conn = null;
                        Statement stmt = null;
                        ResultSet rs = null;

                        try {
                            Class.forName("oracle.jdbc.driver.OracleDriver");
                            conn = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe", "MYCONNECTION", "system");
                            stmt = conn.createStatement();

                            // Query to fetch service location data
                            String query = "SELECT * FROM Service_Location ORDER BY serviceID";
                            rs = stmt.executeQuery(query);
                            
                            // Loop through results
                            while (rs.next()) {
//                                String serviceID = rs.getString("serviceID");
                                byte[] photoBytes1 = rs.getBytes("serviceImg1");
                                byte[] photoBytes2 = rs.getBytes("serviceImg2");
                                byte[] photoBytes3 = rs.getBytes("serviceImg3");

                                String base64Image1 = (photoBytes1 != null) ? Base64.getEncoder().encodeToString(photoBytes1) : null;
                                String base64Image2 = (photoBytes2 != null) ? Base64.getEncoder().encodeToString(photoBytes2) : null;
                                String base64Image3 = (photoBytes3 != null) ? Base64.getEncoder().encodeToString(photoBytes3) : null;
                                                 
                    %>
                    <tr>
                        <!--<td><input type="checkbox"></td>-->
                        <td><%= rs.getString("serviceID") %></td>
                        <td><%=rs.getString("coordinatorID") %></td>
                        <td><%=rs.getString("stateID") %></td>
                        <td class="location-name"><%=rs.getString("serviceAddress") %></td>
                        <td><%=rs.getString("totalCapacity") %></td>
                        <td><%=rs.getString("numOfVolunteer") %></td>
                        <td>
                            <%=rs.getString("jobDescription") %>
                        </td>
                        <td class="status"><%=rs.getString("serviceStatus") %></td>
                        <td>
                            <div class="action-container">
                                <a href="updateServiceLocation.jsp?serviceID=<%= rs.getString("serviceID") %>"><button class="edit-button"><i class="fa-regular fa-pen-to-square"></i></button></a>
                                <a href="javascript:void(0);" onclick="deleteItem('<%= rs.getString("serviceID") %>')">
                                    <button class="edit-button">
                                        <i class="fa-solid fa-trash"></i>
                                    </button>
                                </a>
                                     
                            <!-- Display the images in the modal -->
                            <button class="image-button" data-images="<%= base64Image1 %>,<%= base64Image2 %>,<%= base64Image3 %>">
                                <i class="far fa-images"></i>
                            </button>
                                <!-- Modal for Image Display -->
                                <div id="image-modal" class="modal">
                                    <div class="modal-content">
                                        <span id="close-modal" class="close">&times;</span>
                                        <h3>Location Images</h3>
                                        <div class="gallery">
                                            <!-- Dynamic images will be inserted here by JavaScript -->
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </td>
                    </tr>
                     <%
                            }
                        }  catch (Exception e) {
                            out.println("Error: " + e.getMessage());
                            e.printStackTrace();
                        }

                    %>                
                </tbody>
            </table>
        </div>
    </main>

    <script>
        document.getElementById("search-button").addEventListener("click", function () {
            const searchBox = document.querySelector(".search-box").value.toLowerCase();
            const tableRows = document.querySelectorAll("tbody tr");

            tableRows.forEach((row) => {
            const locationID = row.children[0].textContent.toLowerCase();
            const coordinatorID = row.children[1].textContent.toLowerCase();
            const stateID = row.children[2].textContent.toLowerCase();
            const locationAddress = row.children[3].textContent.toLowerCase();
            const totCapacity = row.children[4].textContent.toLowerCase();
            const numOfVolunteer = row.children[5].textContent.toLowerCase();
            const status = row.children[7].textContent.toLowerCase();

              if (locationID.includes(searchBox) || coordinatorID.includes(searchBox) || stateID.includes(searchBox) || locationAddress.includes(searchBox) || totCapacity.includes(searchBox) || numOfVolunteer.includes(searchBox) || status.includes(searchBox)) {
                row.style.display = ""; // Show matching rows
                } else {
                  row.style.display = "none"; // Hide non-matching rows
                }
            });
          });
          
        function deleteItem(primaryKey) {
            // Construct the URL with parameters to the deleteServlet
          
            var url = "deleteServLoc?serviceID=" + primaryKey;
            
            // Redirect the user to the deleteServlet
            if (confirm("Are you sure you want to delete this item?")) {
                window.location.href = url; // Navigate to the deleteServlet URL
            }
        }
        
        document.addEventListener("DOMContentLoaded", function() {
        const statusCells = document.querySelectorAll('.status');

        statusCells.forEach(function(cell) {
        const statusText = cell.innerText.trim(); // Get the status text

        if (statusText === "Active") {
            cell.style.color = "green"; 
            cell.style.fontWeight = "bold"; 
            cell.style.fontSize = "16px";
            cell.style.textShadow = "0 0 10px rgba(0, 255, 0, 0.8), 0 0 20px rgba(0, 255, 0, 0.6)"; // Green glow
        } else if (statusText === "Inactive") {
            cell.style.color = "red";
            cell.style.fontWeight = "bold"; 
            cell.style.fontSize = "16px";
            cell.style.textShadow = "0 0 10px rgba(255, 0, 0, 0.4), 0 0 20px rgba(255, 0, 0, 0.3)"; // Lighter red glow
        }
        });
        });
        
        document.addEventListener("DOMContentLoaded", function () {
            const cameraButtons = document.querySelectorAll(".image-button"); // Select all image buttons
            const modal = document.getElementById("image-modal");
            const closeModal = document.getElementById("close-modal");
            const gallery = modal.querySelector(".gallery");

            // Add event listener to each camera button
            cameraButtons.forEach((button) => {
                button.addEventListener("click", function (e) {
                    e.preventDefault();

                    // Get the Base64 images from the data-* attribute
                    const images = this.getAttribute("data-images").split(',');

                    // Populate the gallery with the images
                    gallery.innerHTML = ""; // Clear existing images
                    if (images.length > 0) {
                        images.forEach((imageBase64) => {
                            const img = document.createElement("img");
                            img.src = "data:image/jpeg;base64," + imageBase64;
                            img.alt = "Service Image";
                            gallery.appendChild(img);
                        });
                    } else {
                        gallery.innerHTML = "<p>No images available for this location.</p>";
                    }

                    // Show the modal
                    modal.style.display = "flex";
                });
            });
        
            // Close modal
            closeModal.addEventListener("click", function () {
                modal.style.display = "none";
            });
        
            // Close modal when clicking outside the modal content
            window.addEventListener("click", function (e) {
                if (e.target === modal) {
                    modal.style.display = "none";
                }
            });
        });
        
        
        // Get all filter buttons
        const filterButtons = document.querySelectorAll(".filter-button");

        // Store the initial row order for the "All" button
        const originalRows = Array.from(document.querySelectorAll("tbody tr"));

        // Add event listeners to all buttons
        filterButtons.forEach((button) => {
            button.addEventListener("click", function () {
                // Remove the 'active' class from all buttons
                filterButtons.forEach((btn) => btn.classList.remove("active"));
                // Add the 'active' class to the clicked button
                this.classList.add("active");

                // Get the filter value (column to sort by)
                const filterValue = this.textContent.toLowerCase();

                // Get the table body
                const tbody = document.querySelector("tbody");

                if (filterValue === "all") {
                    // Reset to the original row order
                    tbody.innerHTML = ""; // Clear the table body
                    originalRows.forEach((row) => tbody.appendChild(row)); // Append the original rows
                } else if (filterValue === "name") {
                    // Sort rows alphabetically by "Name"
                    const tableRows = Array.from(document.querySelectorAll("tbody tr"));
                    tableRows.sort((a, b) => {
                        const nameA = a.querySelector(".location-name").textContent.trim().toLowerCase();
                        const nameB = b.querySelector(".location-name").textContent.trim().toLowerCase();
                        return nameA.localeCompare(nameB); // Sort alphabetically
                    });

                    // Reorder the rows in the table
                    tbody.innerHTML = ""; // Clear the table body
                    tableRows.forEach((row) => tbody.appendChild(row)); // Append sorted rows
                } else if (filterValue === "total capacity") {
                    // Sort rows numerically by "Total Capacity"
                    const tableRows = Array.from(document.querySelectorAll("tbody tr"));
                    tableRows.sort((a, b) => {
                        const capacityA = parseInt(a.children[4].textContent.trim(), 10);
                        const capacityB = parseInt(b.children[4].textContent.trim(), 10);
                        return capacityA - capacityB; // Sort numerically
                    });

                    // Reorder the rows in the table
                    tbody.innerHTML = ""; // Clear the table body
                    tableRows.forEach((row) => tbody.appendChild(row)); // Append sorted rows
                } else if (filterValue === "state") {
                    // Sort rows alphabetically by "State"
                    const tableRows = Array.from(document.querySelectorAll("tbody tr"));
                    tableRows.sort((a, b) => {
                        const stateA = a.children[2].textContent.trim().toLowerCase();
                        const stateB = b.children[2].textContent.trim().toLowerCase();
                        return stateA.localeCompare(stateB); // Sort alphabetically
                    });

                    // Reorder the rows in the table
                    tbody.innerHTML = ""; // Clear the table body
                    tableRows.forEach((row) => tbody.appendChild(row)); // Append sorted rows
                }
            });
        });
    </script>
  </body>
</html>