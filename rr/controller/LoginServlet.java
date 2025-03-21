package rr.controller;

import rr.beans.LoginBean;
import rr.dao.LoginDao;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * Servlet for handling login requests
 */
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Retrieve coordinator ID and password from the request
        String coordinatorID = request.getParameter("coordinatorID");
        String coordinatorPass = request.getParameter("coordinatorPass");

        // Validate input
        if (coordinatorID == null || coordinatorID.isEmpty() || coordinatorPass == null || coordinatorPass.isEmpty()) {
            request.setAttribute("errMessage", "ID and Password cannot be empty.");
            request.getRequestDispatcher("adminlogin.jsp").forward(request, response);
            return;
        }

        // Set up the LoginBean with user input
        LoginBean loginBean = new LoginBean();
        loginBean.setCoordinatorID(coordinatorID);
        loginBean.setCoordinatorPass(coordinatorPass);

        // Initialize the LoginDao
        LoginDao loginDao = new LoginDao();

        // Authenticate the user
        String userValidate = loginDao.authenticateUser(loginBean);

        // Start a session for the user
        HttpSession session = request.getSession();

        if ("SUCCESS".equals(userValidate)) {
            // If authentication is successful, set session attributes
            System.out.println("Login SUCCESS for user: " + coordinatorID);
            session.setAttribute("coordinatorID", coordinatorID);

            // Redirect to dashboardController
            request.getSession().setAttribute("popupMessage", "Log in successful. Redirecting to dashboard.");
            response.sendRedirect("dashboardController");
            
        } else {
            // If authentication fails, display error message
            System.out.println("Login FAILED for user: " + coordinatorID);
            request.setAttribute("errMessage", userValidate);

            // Forward back to login.jsp with error message
            request.getRequestDispatcher("adminlogin.jsp").forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Redirect GET requests to login.jsp
        response.sendRedirect("adminlogin.jsp");
    }

    @Override
    public String getServletInfo() {
        return "LoginServlet handles user login requests";
    }
}
