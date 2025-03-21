/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package rr.beans;


public class PasswordBean implements java.io.Serializable {
    
    private String coordinatorID;
    private String coordinatorEmail;
    private String oldPassword;
    private String newPassword;
    private String confirmPassword;

    
    public PasswordBean() {
        coordinatorID = "";
        coordinatorEmail = "";
        oldPassword = "";
        newPassword = "";
        confirmPassword = "";
    }

   
    public PasswordBean(String coordinatorID, String coordinatorEmail, String oldPassword, 
                       String newPassword, String confirmPassword) {
        this.coordinatorID = coordinatorID;
        this.coordinatorEmail = coordinatorEmail;
        this.oldPassword = oldPassword;
        this.newPassword = newPassword;
        this.confirmPassword = confirmPassword;
    }

    
    public String getCoordinatorID() {
        return coordinatorID;
    }

    public void setCoordinatorID(String coordinatorID) {
        this.coordinatorID = coordinatorID;
    }

    public String getCoordinatorEmail() {
        return coordinatorEmail;
    }

    public void setCoordinatorEmail(String coordinatorEmail) {
        this.coordinatorEmail = coordinatorEmail;
    }

    public String getOldPassword() {
        return oldPassword;
    }

    public void setOldPassword(String oldPassword) {
        this.oldPassword = oldPassword;
    }

    public String getNewPassword() {
        return newPassword;
    }

    public void setNewPassword(String newPassword) {
        this.newPassword = newPassword;
    }

    public String getConfirmPassword() {
        return confirmPassword;
    }

    public void setConfirmPassword(String confirmPassword) {
        this.confirmPassword = confirmPassword;
    }
}