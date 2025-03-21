package rr.beans;

public class Application {
    private String applicationId;
    private String title;
    private String location;
    private String description;
    private String status;
    private String dateOpen;
    
    // Generate getters and setters
    public String getApplicationId() { return applicationId; }
    public void setApplicationId(String applicationId) { this.applicationId = applicationId; }
    
    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }
    
    public String getLocation() { return location; }
    public void setLocation(String location) { this.location = location; }
    
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    
    public String getDateOpen() { return dateOpen; }
    public void setDateOpen(String dateOpen) { this.dateOpen = dateOpen; }
}