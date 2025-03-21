/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package rr.dao;

import rr.beans.PasswordBean;
import java.sql.*;
import util.DBConnection;

public class PasswordDao {
    
    public String verifyEmailAndId(PasswordBean passwordBean) {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            con = DBConnection.createConnection();
            ps = con.prepareStatement("SELECT COUNT(*) FROM COORDINATOR WHERE coordinatorID = ? AND coordinatorEmail = ?");
            ps.setString(1, passwordBean.getCoordinatorID());
            ps.setString(2, passwordBean.getCoordinatorEmail());
            
            rs = ps.executeQuery();
            if (rs.next() && rs.getInt(1) > 0) {
                return "SUCCESS";
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (con != null) con.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return "Invalid Credentials";
    }
    
    public String updatePassword(PasswordBean passwordBean) {
        Connection con = null;
        PreparedStatement ps = null;
        
        try {
            con = DBConnection.createConnection();
            ps = con.prepareStatement("UPDATE COORDINATOR SET coordinatorPass = ? WHERE coordinatorID = ? AND coordinatorEmail = ?");
            ps.setString(1, passwordBean.getNewPassword());
            ps.setString(2, passwordBean.getCoordinatorID());
            ps.setString(3, passwordBean.getCoordinatorEmail());
            
            int rowsUpdated = ps.executeUpdate();
            if (rowsUpdated > 0) {
                return "SUCCESS";
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try {
                if (ps != null) ps.close();
                if (con != null) con.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return "Update Failed";
    }
    
    public String changePassword(PasswordBean passwordBean) {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            con = DBConnection.createConnection();
            
            // First verify old password
            ps = con.prepareStatement("SELECT COUNT(*) FROM COORDINATOR WHERE coordinatorID = ? AND coordinatorPass = ?");
            ps.setString(1, passwordBean.getCoordinatorID());
            ps.setString(2, passwordBean.getOldPassword());
            
            rs = ps.executeQuery();
            if (!rs.next() || rs.getInt(1) == 0) {
                return "Invalid Old Password";
            }
            
            // If old password is correct, update to new password
            ps.close();
            ps = con.prepareStatement("UPDATE COORDINATOR SET coordinatorPass = ? WHERE coordinatorID = ?");
            ps.setString(1, passwordBean.getNewPassword());
            ps.setString(2, passwordBean.getCoordinatorID());
            
            int rowsUpdated = ps.executeUpdate();
            if (rowsUpdated > 0) {
                return "SUCCESS";
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (con != null) con.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return "Update Failed";
    }
}