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
    <title>Update Category</title>

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
        min-width: 400px; /* Ensures a minimum width */
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
                <h1>Update Category</h1>
            </div>
            <% 
                Connection conn = null;
                PreparedStatement stmt = null;
                ResultSet rs = null; 

                String cat_id, cat_name = null;

                try {
                    cat_id = request.getParameter("categoryID");

                    conn = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:XE", "MYCONNECTION", "system");
                    String query = "SELECT * FROM Category WHERE categoryID = ?";
                    stmt = conn.prepareStatement(query);
                    stmt.setString(1, cat_id);
                    rs = stmt.executeQuery();

                    if(rs.next()){
                        cat_id = rs.getString("categoryID");
                        cat_name = rs.getString("categoryName");      
            %>
            <form action="categoryController" method="POST" id="application-form">
            <div class="form-fields">
                <label for="catID">Category ID</label>
                <input type="text" id="categoryID" name="categoryID" value="<%= cat_id %>" placeholder="Enter category ID..." readonly>

                <label for="catName">Category Name</label>
                <input type="text" id="categoryName" name="categoryName" value="<%= cat_name %>" placeholder="Enter category name...">
            </div>
            <div class="btn-container">
                <button type="button" class="btn-cancel" onclick="cancelForm()">Cancel</button>
                <input type="hidden" name="action" value="Update" />
                <button class="btn-publish">Save Changes</button>
             </div
            </form>
            <%
                } else {
                     out.println("No record found");
                    }
                } catch (SQLException e) {
                    e.printStackTrace();
                    out.println("Database error occurred.");
                }        
            %>
        </div>
    </div>
        <script>
        function cancelForm() {
            if (confirm('Are you sure you want to cancel?')) {
                document.getElementById('application-form').reset();
                window.location.href='category.jsp'; 
            }
        }
    </script>
  </body>

</html>