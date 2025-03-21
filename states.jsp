<%@ include file="sidebarAdmin.jsp" %>

<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<!DOCTYPE html>
<html lang="en">
  <head>
    <a href="C:\Users\User\Documents\CDCS230\SEMESTER 4\CSC584\HeaderAdmin.html"></a>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE-edge">
    <meta name="viewport" content="width-device-width", initial-scale="1.0">
    
    <link rel="icon" type="image/icon" href="">
    <title>Category</title>

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
    
    .grid-container {
        display: grid;
        grid-template-columns: 260px 1fr 1fr 1fr;
        grid-template-rows: 0.2fr 3fr;
        grid-template-areas: 
        "sidebar header header header"
        "sidebar main main main";
        height: 100vh;
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
        margin-left: 78px;
        flex-grow: 1;
    }

    .input-container .button-create-category {
        background-color: #f06838;
        color: #F4F6DD;
        border: none;
        border-radius: 15px;
        padding: 10px 15px;
        cursor: pointer;
    }

    .main-container h1 {
        font-size: x-large;
        font-weight: bold;
        margin-bottom: 20px;
        padding-bottom: 15px; /* Adjust padding */
        border-bottom: 1px solid #266433;
        width: 72.5%; /* Match the table's width */
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
        width: 90%; /* Adjust to take up the full width of the parent */
        overflow-x: auto;
        margin-top: 20px;
    }
    
    .table-container table {
        width: 80%; /* Table spans the full container width */
        border-collapse: collapse;
    }
    
    .table-container th, .table-container td {
        padding: 15px 15px 15px;
        text-align: center;
        border-bottom: 1px solid #266433;
        border-top: 1px solid #266433;
    }

    .table-container .category-title, .table-container .category-name {
        text-align: left;
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
    
    .action-container {
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

    .button-create-category:hover{
        background-color: #e2dc50;
        color: #266433;
    }

    .button-add-product:hover{
        background-color: #bee097;
        color: #266433;
    }
    .edit-button:hover {
        background-color: #f06838; /* A dark gray for edit buttons */
        color: #F4F6DD;
    }

    @media (max-width: 768px) {
        .input-container {
            margin-left: 0; 
            justify-content: flex-start;
            width: 100%; 
        }

        .button-create-category {
            flex-grow: 1; /* Allow the button to stretch if needed */
            text-align: center; /* Center-align text */
            max-width: 100%; /* Prevent overflow */
        }
    }
  </style>
  <body>
    <main class="main-container">
        <h1>State</h1>
        <div class="main-title">
            <div class="search-container">
              <input type="text" id="search-input" placeholder="Search Category" class="search-box">
              <button id="search-button"><i class="fa-solid fa-magnifying-glass"></i></button>

                <div class="input-container">
                    <!--<a href="addState.jsp"><button class="button-create-category">Add States</button></a>-->
                </div>
            </div>
        </div>

        <div class="sorting-container">
            <div class="icon" id="display-container-category">
                <button class="filter-button active" value="all">All</button>
                <button class="filter-button" value="state">State</button>
            </div>
          </div>
        </div>

        <div class="table-container">
            <table>
                <thead>
                    <tr>
                        <!--<th><input type="checkbox"></th>-->
                        <th>ID</th>
                        <th class="category-title">State Name</th>
                        <!--<th>Actions</th>-->
                    </tr>
                </thead>
                <tbody>
                    <% 
                        Connection conn = null;
                        PreparedStatement stmt = null;
                        ResultSet rs = null; 

                        try {
                            conn = conn = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:XE", "MYCONNECTION", "system");
                            String query = "SELECT * FROM States";
                            stmt = conn.prepareStatement(query);
                            rs = stmt.executeQuery();

                            while(rs.next()){
                    %>
                    <tr>
                        <!--<td><input type="checkbox"></td>-->
                        <td><%=rs.getString("stateID") %></td>
                        <td class="category-name"><%=rs.getString("stateName") %></td>
<!--                        <td>
                            <div class="action-container">
                                <a href="updateCategory.jsp?stateID=<%= rs.getString("stateID") %>"><button class="edit-button"><i class="fa-regular fa-pen-to-square"></i></button></a>
                                <a href="javascript:void(0);" onclick="deleteItem('States', 'stateID', '<%= rs.getString("stateID") %>')">
                                    <button class="edit-button">
                                        <i class="fa-solid fa-trash"></i>
                                    </button>
                                </a>                            
                            </div>
                        </td>-->
                    </tr>
                    <% 
                            }
                        }  catch (SQLException e) {
                            out.println("Error Retrieving music record: " + e.getMessage());
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
        document.getElementById("search-button").addEventListener("click", function () {
            const searchBox = document.querySelector(".search-box").value.toLowerCase();
            const tableRows = document.querySelectorAll("tbody tr");

            tableRows.forEach((row) => {
            const statesID = row.children[0].textContent.toLowerCase();
            const statesName = row.children[1].textContent.toLowerCase();

              if (statesID.includes(searchBox) || statesName.includes(searchBox)) {
                row.style.display = ""; // Show matching rows
                } else {
                  row.style.display = "none"; // Hide non-matching rows
                }
            });
          });
          
        // Get all filter buttons
        const filterButtons = document.querySelectorAll(".filter-button");

        // Add event listeners to all buttons
        filterButtons.forEach((button) => {
            button.addEventListener("click", function () {
                // Remove active class from all buttons
                filterButtons.forEach((btn) => btn.classList.remove("active"));

                // Add active class to the clicked button
                this.classList.add("active");

                // Get the filter value from the button's value
                const filterValue = this.getAttribute("value").toLowerCase();

                // Get all table rows
                const tableRows = Array.from(document.querySelectorAll("tbody tr"));

                if (filterValue === "all") {
                    // Show all rows for "All"
                    location.reload();
                } else if (filterValue === "state") {
                    // Sort rows alphabetically by "State Name" column
                    tableRows.sort((a, b) => {
                        const nameA = a.querySelector(".category-name").textContent.trim().toLowerCase();
                        const nameB = b.querySelector(".category-name").textContent.trim().toLowerCase();
                        return nameA.localeCompare(nameB); // Compare strings alphabetically
                    });

                    // Reorder the table rows in the DOM
                    const tbody = document.querySelector("tbody");
                    tbody.innerHTML = ""; // Clear current rows
                    tableRows.forEach((row) => tbody.appendChild(row)); // Append sorted rows
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
  </body>
</html>