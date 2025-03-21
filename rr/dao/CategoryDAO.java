package rr.dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import rr.beans.CategoryBean;
import  util.DBConnection;

public class CategoryDAO {
    public List<CategoryBean> getAllCategories() throws SQLException, ClassNotFoundException {
        List<CategoryBean> categories = new ArrayList<>();
        String sql = "SELECT categoryID, categoryName FROM Category";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                CategoryBean category = new CategoryBean();
                category.setCategoryId(rs.getString("categoryID"));
                category.setCategoryName(rs.getString("categoryName"));
                categories.add(category);
            }
        }
        return categories;
    }
}