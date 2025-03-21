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
public class inventory {
    public String inventoryID;
    public String serviceID;
    public Integer quantityGiven;
    public LocalDate dateDelivered;
    public String statusInventory;
    
    public inventory() {
    }
    
    public inventory(String inventoryID, String serviceID, Integer quantityGiven, LocalDate dateDelivered, String statusInventory) {
        this.inventoryID = inventoryID;
        this.serviceID = serviceID;
        this.quantityGiven = quantityGiven;
        this.dateDelivered = dateDelivered;
        this.statusInventory = statusInventory;
    }

    public String getInventoryID() {
        return inventoryID;
    }

    public void setInventoryID(String inventoryID) {
        this.inventoryID = inventoryID;
    }

    public String getServiceID() {
        return serviceID;
    }

    public void setServiceID(String serviceID) {
        this.serviceID = serviceID;
    }

    public Integer getQuantityGiven() {
        return quantityGiven;
    }

    public void setQuantityGiven(Integer quantityGiven) {
        this.quantityGiven = quantityGiven;
    }

    public LocalDate getDateDelivered() {
        return dateDelivered;
    }

    public void setDateDelivered(LocalDate dateDelivered) {
        this.dateDelivered = dateDelivered;
    }

    public String getStatusInventory() {
        return statusInventory;
    }

    public void setStatusInventory(String statusInventory) {
        this.statusInventory = statusInventory;
    }
    
    
}
