/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package rr.beans;
import java.time.LocalDate;

/**
 *
 * @author User
 */
public class volunteer_application {
    public String formId;
    public String applicationID;
    public String volunteerID;
    public String coordinatorID;
    public String formStatus;
    public LocalDate date;

    public volunteer_application() {
    }

    public volunteer_application(String formId, String applicationID, String volunteerID, String coordinatorID, String formStatus, LocalDate date) {
        this.formId = formId;
        this.applicationID = applicationID;
        this.volunteerID = volunteerID;
        this.coordinatorID = coordinatorID;
        this.formStatus = formStatus;
        this.date = date;
    }

    public String getFormId() {
        return formId;
    }

    public void setFormId(String formId) {
        this.formId = formId;
    }

    public String getApplicationID() {
        return applicationID;
    }

    public void setApplicationID(String applicationID) {
        this.applicationID = applicationID;
    }

    public String getVolunteerID() {
        return volunteerID;
    }

    public void setVolunteerID(String volunteerID) {
        this.volunteerID = volunteerID;
    }

    public String getCoordinatorID() {
        return coordinatorID;
    }

    public void setCoordinatorID(String coordinatorID) {
        this.coordinatorID = coordinatorID;
    }

    public String getFormStatus() {
        return formStatus;
    }

    public void setFormStatus(String formStatus) {
        this.formStatus = formStatus;
    }

    public LocalDate getDate() {
        return date;
    }

    public void setDate(LocalDate Date) {
        this.date = Date;
    }
    
    
}
