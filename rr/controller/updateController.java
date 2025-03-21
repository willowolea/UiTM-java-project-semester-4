
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/updateController")
public class updateController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");

        try (PrintWriter out = response.getWriter()) {
            String fullname = request.getParameter("fullname");
            String email = request.getParameter("email");
            String age = request.getParameter("age");
            String address = request.getParameter("address");
            String gender = request.getParameter("gender");
            String volunteernotel = request.getParameter("volunteernotel");
            String volunteerID = request.getSession().getAttribute("volunteerID").toString();

            Connection conn = null;
            PreparedStatement pstmt = null;

            try {

                Class.forName("oracle.jdbc.driver.OracleDriver");
                conn = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:XE", "MYCONNECTION", "system");

                String sql = "UPDATE VOLUNTEER SET FULLNAME = ?, EMAIL = ?, AGE = ?, ADDRESS = ?, GENDER = ?, VOLUNTEERNOTEL = ? WHERE VOLUNTEERID = ?";
                pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, fullname);
                pstmt.setString(2, email);
                pstmt.setString(3, age);
                pstmt.setString(4, address);
                pstmt.setString(5, gender);
                pstmt.setString(6, volunteernotel);
                pstmt.setString(7, volunteerID);

                // Execute the update
                int rowsUpdated = pstmt.executeUpdate();
                if (rowsUpdated > 0) {
                    out.println("<script>");
                    out.println("alert('Profile updated!');");
                    out.println("window.location.href='userDashboard?volunteerID=" + volunteerID + "&update=success';");
                    out.println("</script>");
                } else {
                    response.sendRedirect("userDashboard?volunteerID=" + volunteerID + "&update=fail");
                }
            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect("userDashboard?volunteerID=" + volunteerID + "&update=error");
            } finally {
                try {
                    if (pstmt != null) {
                        pstmt.close();
                    }
                    if (conn != null) {
                        conn.close();
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        }
    }
}
