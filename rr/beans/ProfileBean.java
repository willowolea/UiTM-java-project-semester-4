/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package rr.beans;

public class ProfileBean {
    private String coordinatorID;
    private String coordinatorName;
    private String coordinatorNotel;
    private String coordinatorEmail;
    private String position;
    private String coordinatorPass;

    // Default constructor
    public ProfileBean() {
    }

    // Constructor with parameters
    public ProfileBean(String coordinatorID, String coordinatorName, String coordinatorNotel, 
                      String coordinatorEmail, String position, String coordinatorPass) {
        this.coordinatorID = coordinatorID;
        this.coordinatorName = coordinatorName;
        this.coordinatorNotel = coordinatorNotel;
        this.coordinatorEmail = coordinatorEmail;
        this.position = position;
        this.coordinatorPass = coordinatorPass;
    }

    // Getters and Setters
    public String getCoordinatorID() {
        return coordinatorID;
    }

    public void setCoordinatorID(String coordinatorID) {
        this.coordinatorID = coordinatorID;
    }

    public String getCoordinatorName() {
        return coordinatorName;
    }

    public void setCoordinatorName(String coordinatorName) {
        this.coordinatorName = coordinatorName;
    }

    public String getCoordinatorNotel() {
        return coordinatorNotel;
    }

    public void setCoordinatorNotel(String coordinatorNotel) {
        this.coordinatorNotel = coordinatorNotel;
    }

    public String getCoordinatorEmail() {
        return coordinatorEmail;
    }

    public void setCoordinatorEmail(String coordinatorEmail) {
        this.coordinatorEmail = coordinatorEmail;
    }

    public String getPosition() {
        return position;
    }

    public void setPosition(String position) {
        this.position = position;
    }

    public String getCoordinatorPass() {
        return coordinatorPass;
    }

    public void setCoordinatorPass(String coordinatorPass) {
        this.coordinatorPass = coordinatorPass;
    }
}