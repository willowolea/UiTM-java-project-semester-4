/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package rr.beans;
import java.io.Serializable;
import java.time.LocalDate;
/**
 *
 * @author User
 */
public class product implements java.io.Serializable {
    public String productID;
    public String categoryID;
    public String volunteerID;
    public String inventoryID;
    public String productName;
    public Integer productQtt;
    public byte[] productImg;
    public LocalDate dateReceived;
    public String remark;

    public product() {
    }

    public product(String productID, String categoryID, String volunteerID, String inventoryID, String productName, Integer productQtt, byte[] productImg, LocalDate dateReceived, String remark) {
        this.productID = productID;
        this.categoryID = categoryID;
        this.volunteerID = volunteerID;
        this.inventoryID = inventoryID;
        this.productName = productName;
        this.productQtt = productQtt;
        this.productImg = productImg;
        this.dateReceived = dateReceived;
        this.remark = remark;
    }

    public String getProductID() {
        return productID;
    }

    public void setProductID(String productID) {
        this.productID = productID;
    }

    public String getCategoryID() {
        return categoryID;
    }

    public void setCategoryID(String categoryID) {
        this.categoryID = categoryID;
    }

    public String getVolunteerID() {
        return volunteerID;
    }

    public void setVolunteerID(String volunteerID) {
        this.volunteerID = volunteerID;
    }

    public String getInventoryID() {
        return inventoryID;
    }

    public void setInventoryID(String inventoryID) {
        this.inventoryID = inventoryID;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public Integer getProductQtt() {
        return productQtt;
    }

    public void setProductQtt(Integer productQtt) {
        this.productQtt = productQtt;
    }

    public byte[] getProductImg() {
        return productImg;
    }

    public void setProductImg(byte[] productImg) {
        this.productImg = productImg;
    }

    public LocalDate getDateReceived() {
        return dateReceived;
    }

    public void setDateReceived(LocalDate dateReceived) {
        this.dateReceived = dateReceived;
    }

    public String getRemark() {
        return remark;
    }

    public void setRemark(String remark) {
        this.remark = remark;
    }
    
    
}
