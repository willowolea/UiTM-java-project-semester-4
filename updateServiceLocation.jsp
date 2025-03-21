<%@ page import="javax.servlet.http.*, java.io.*, java.sql.*" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@300;500;700&family=Quicksand:wght@500&display=swap" rel="stylesheet">
    <script src="https://kit.fontawesome.com/939a0fa897.js" crossorigin="anonymous"></script>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Service Location Form</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Montserrat', sans-serif;
            font-family: "Quicksand", sans-serif;
        }

        body {
            background-color: #F5F9E9;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            position: relative;
        }

        .back-button {
            position: absolute;
            top: 5px;
            left: 20px;
            color: #f16838;
            padding: 10px 15px;
            font-size: 30px;
            text-decoration: none;
            display: flex;
            justify-content: center;
            align-items: center;
        }

        .back-button:hover {
            color: #339551;
        }

        .form-container {
            background-color: #FFF;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            width: 100%;
            max-width: 700px;
            border: 2px solid #D9EAD3;
            overflow: hidden; /* Prevent overflow */
        }

        h1 {
            margin-bottom: 20px;
            font-size: 1.8em;
            color: #266533;
            text-align: center;
        }

        .form-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 20px;
            max-width: 100%; /* Ensure it doesn't overflow */
            width: 100%;
        }

        .form-group {
            display: flex;
            flex-direction: column;
            width: 100%;
        }

        label {
            margin-bottom: 5px;
            font-weight: bold;
            color: #266533;
        }

        input, select, textarea {
            padding: 10px;
            border: 1px solid #A6C48A;
            border-radius: 5px;
            font-size: 1em;
            background-color: #F5F9E9;
            width: 100%; /* Ensure full width inside form */
            box-sizing: border-box; /* Ensure padding doesn't cause overflow */
        }

        input:focus, select:focus, textarea:focus {
            border-color: #7CBF44;
            outline: none;
            background-color: #FFF;
        }

        textarea {
            resize: none;
        }

        .form-actions {
            grid-column: span 2;
            display: flex;
            justify-content: flex-end;
            gap: 15px;
        }

        p {
            font-weight: bold;
            color: #266533;
            margin-top: 0;
        }

        button {
            font-size: 1em;
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-weight: bold;
        }

        .btn-submit {
            background-color: #2e560d;
            color: #FFF;
        }

        .btn-cancel {
            background-color: #E63946;
            color: #FFF;
        }

        .btn-submit:hover {
            background-color: #bee0c7;
            color: black;
        }

        .btn-cancel:hover {
            background-color: #fb9999;
            color: black;
        }

        .radio-group {
            grid-column: span 2;
            margin-top: -38px;
            margin-left: 260px;
        }

        .radio-group label {
            margin-right: 10px;
            font-weight: bold;
        }

        .upload-box {
            border: 2px dashed #a6c48a;
            padding: 20px;
            text-align: center;
            color: #266533;
            border-radius: 8px;
            border-width: 3px;
            background-color: #ffffff;
            transition: background-color 0.3s;
            cursor: pointer;          
        }

        .upload-box:hover {
            background-color: #eaf4dc;
        }

        .upload-box input {
            display: none;
        }

        @media (max-width: 600px) {
            .form-grid {
                grid-template-columns: 1fr;
            }

            .form-actions {
                flex-direction: column;
                gap: 10px;
            }
        }
    </style>
</head>
<body>
    <a href="ServiceLocation.jsp" class="back-button">
        <i class="fa-solid fa-arrow-left"></i>
    </a>

    <div class="form-container">
        <h1 id="form-title">Edit Service Location</h1>
        <% 
            String locationID = request.getParameter("location-id");
            Connection conn = null;
            PreparedStatement stmt = null;
            ResultSet rs = null; 

            try {
                String sl_id = request.getParameter("serviceID");
                
                conn = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:XE", "MYCONNECTION", "system");
                
                // Retrieve the existing data for the service location using locationID
                String query = "SELECT * FROM Service_Location WHERE serviceID = ?";
                stmt = conn.prepareStatement(query);
                stmt.setString(1, sl_id);
                rs = stmt.executeQuery();

                if (rs.next()) {
                    String coordinatorID = rs.getString("coordinatorID");
                    String stateID = rs.getString("stateID");
                    String address = rs.getString("serviceAddress");
                    int totalCapacity = rs.getInt("totalCapacity");
                    int numOfVolunteer = rs.getInt("numOfVolunteer");
                    String jobDescription = rs.getString("jobDescription");
                    String status = rs.getString("serviceStatus");

                    // Add any additional fields as needed for displaying images, etc.
        %>
        <form action="ServLocController" method="POST" id="service-location-form" enctype="multipart/form-data">
            <div class="form-grid">
                <div class="form-group">
                    <label for="location-id">Location ID</label>
                    <input type="text" id="location-id" name="location-id" value="<%= sl_id %>" readonly required>
                </div>
                <div class="form-group">
                    <label for="coordinator-id">Coordinator ID</label>
                    <select id="coordinator-id" name="coordinator-id" required>
                        <option value="">Select Coordinator</option>
                        <%
                            // Connect to the database and fetch coordinators
                            Statement stmt2 = conn.createStatement();
                            ResultSet rs2 = stmt2.executeQuery("SELECT coordinatorID, coordinatorName FROM Coordinator");
                            while (rs2.next()) {
                                String coordinatorIDOption = rs2.getString("coordinatorID");
                                String coordinatorName = rs2.getString("coordinatorName");
                                boolean selected = coordinatorIDOption.equals(coordinatorID);
                        %>
                        <option value="<%= coordinatorIDOption %>" <%= selected ? "selected" : "" %>>
                            <%= coordinatorIDOption %> - <%= coordinatorName %>
                        </option>
                        <%
                            }
                        %>
                    </select>
                </div>
                <div class="form-group">
                    <label for="state-id">State ID</label>
                    <select id="state-id" name="state-id" required>
                        <option value="">Select State</option>
                        <%
                            // Fetching state data from the database
                            ResultSet rs3 = stmt2.executeQuery("SELECT stateID, stateName FROM States");
                            while (rs3.next()) {
                                String stateIDOption = rs3.getString("stateID");
                                String stateName = rs3.getString("stateName");
                                boolean selected = stateIDOption.equals(stateID);
                        %>
                        <option value="<%= stateIDOption %>" <%= selected ? "selected" : "" %>>
                            <%= stateName %>
                        </option>
                        <%
                            }
                        %>
                    </select>
                </div>
                <div class="form-group">
                    <label for="address">Address</label>
                    <textarea id="address" name="address" placeholder="Enter Address" rows="2" required><%= address %></textarea>
                </div>
                <div class="form-group">
                    <label for="total-capacity">Total Capacity</label>
                    <input type="number" id="total-capacity" name="total-capacity" placeholder="Enter Total Capacity" value="<%= totalCapacity %>" required>
                </div>
                <div class="form-group">
                    <label for="volunteer-number">Number of Volunteers</label>
                    <input type="number" id="volunteer-number" name="volunteer-number" placeholder="Enter Number of Volunteers" value="<%= numOfVolunteer %>" required>
                </div>
                <div class="form-group" style="grid-column: span 2;">
                    <label for="job-description">Job Description</label>
                    <textarea id="job-description" name="job-description" placeholder="Enter Job Description" rows="3" required><%= jobDescription %></textarea>
                </div>
                <div class="form-group">
                    <label for="status-id">Status</label>
                    <select id="status-id" name="status-id" required>
                        <option value="Active" <%= "Active".equals(status) ? "selected" : "" %>>Active</option>
                        <option value="Inactive" <%= "Inactive".equals(status) ? "selected" : "" %>>Inactive</option>
                    </select>
                </div>

                <div class="form-group">
                    <label>Drag & Drop file here Or click to browse (3 images max)</label>
                    <input type="file" id="file-input" accept="image/*" name="serviceImg" multiple>
                </div>

                <div class="form-actions">
                    <input type="hidden" name="action" value="Update">
                    <button class="btn-submit">Save</button>
                    <button type="button" class="btn-cancel" onclick="cancelForm()">Cancel</button>
                </div>
            </div>
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

    <script>
//        document.getElementById('service-location-form').addEventListener('submit', function (e) {
//            e.preventDefault();
//            alert('Form submitted successfully!');
//        });

        function cancelForm() {
            if (confirm('Are you sure you want to cancel?')) {
                document.getElementById('service-location-form').reset();
                window.location.href='ServiceLocation.jsp'; 
            }
        }
    </script>
</body>
</html>
