package rr.beans;

public class Volunteer {
    private String volunteerID;
    private String fullname;
    private String age;
    private String address;
    private String gender;
    private String password;
    private String email;
    private String volunteerNotel;
    
    // Default constructor
    public Volunteer() {
    }
    
    // Constructor with parameters
    public Volunteer(String volunteerID, String fullname, String age, String address, 
                    String gender, String password, String email, String volunteerNotel) {
        this.volunteerID = volunteerID;
        this.fullname = fullname;
        this.age = age;
        this.address = address;
        this.gender = gender;
        this.password = password;
        this.email = email;
        this.volunteerNotel = volunteerNotel;
    }
    
    // Getters and Setters
    public String getVolunteerID() {
        return volunteerID;
    }
    
    public void setVolunteerID(String volunteerID) {
        this.volunteerID = volunteerID;
    }
    
    public String getFullname() {
        return fullname;
    }
    
    public void setFullname(String fullname) {
        this.fullname = fullname;
    }
    
    public String getAge() {
        return age;
    }
    
    public void setAge(String age) {
        this.age = age;
    }
    
    public String getAddress() {
        return address;
    }
    
    public void setAddress(String address) {
        this.address = address;
    }
    
    public String getGender() {
        return gender;
    }
    
    public void setGender(String gender) {
        this.gender = gender;
    }
    
    public String getPassword() {
        return password;
    }
    
    public void setPassword(String password) {
        this.password = password;
    }
    
    public String getEmail() {
        return email;
    }
    
    public void setEmail(String email) {
        this.email = email;
    }
    
    public String getVolunteerNotel() {
        return volunteerNotel;
    }
    
    public void setVolunteerNotel(String volunteerNotel) {
        this.volunteerNotel = volunteerNotel;
    }
}