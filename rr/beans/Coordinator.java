/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package rr.beans;

/**
 *
 * @author User
 */
public class Coordinator {
    public String coordinatorID;
    public String coordinatorName;
    public String coordinatorNoTel;
    public String coordinatorEmail;
    public String position;
    public String coordinatorPass;

    public Coordinator() {
    }

    public Coordinator(String coordinatorID, String coordinatorName, String coordinatorNoTel, String coordinatorEmail, String position, String coordinatorPass) {
        this.coordinatorID = coordinatorID;
        this.coordinatorName = coordinatorName;
        this.coordinatorNoTel = coordinatorNoTel;
        this.coordinatorEmail = coordinatorEmail;
        this.position = position;
        this.coordinatorPass = coordinatorPass;
    }

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

    public String getCoordinatorNoTel() {
        return coordinatorNoTel;
    }

    public void setCoordinatorNoTel(String coordinatorNoTel) {
        this.coordinatorNoTel = coordinatorNoTel;
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
