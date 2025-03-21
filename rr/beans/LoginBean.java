package rr.beans;

import java.io.Serializable;

/**
 * Bean class for user login
 */
public class LoginBean implements Serializable {

    private String coordinatorID;  // Attribute aligned with COORDINATORID
    private String coordinatorPass; // Attribute aligned with COORDINATORPASS

    public LoginBean() {
        coordinatorID = "";
        coordinatorPass = "";
    }

    public LoginBean(String coordinatorID, String coordinatorPass) {
        this.coordinatorID = coordinatorID;
        this.coordinatorPass = coordinatorPass;
    }

    // Getter for COORDINATORID
    public String getCoordinatorID() {
        return coordinatorID;
    }

    // Setter for COORDINATORID
    public void setCoordinatorID(String coordinatorID) {
        this.coordinatorID = coordinatorID;
    }

    // Getter for COORDINATORPASS
    public String getCoordinatorPass() {
        return coordinatorPass;
    }

    // Setter for COORDINATORPASS
    public void setCoordinatorPass(String coordinatorPass) {
        this.coordinatorPass = coordinatorPass;
    }

}
