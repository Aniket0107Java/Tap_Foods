package com.tap.servlets;

import java.io.IOException;
import java.io.PrintWriter;
import java.time.LocalDateTime;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.hibernate.Session;

import com.tap.DAO.UserDAO;
import com.tap.DAOImpl.UserDAOImpl;
import com.tap.model.User;
import com.utility.HibernateUtility;

/**
 * Servlet implementation class UserLoginServlet
 */


@WebServlet("/UserLogin")
public class UserLoginServlet extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Retrieve email and password from the request
        String email = req.getParameter("email");
        String password = req.getParameter("password");
        String role = req.getParameter("role");

        try {
            UserDAOImpl userDaoImpl = new UserDAOImpl(HibernateUtility.getSessionFactory());

            // Fetch the user based on email and password
            User user = userDaoImpl.getUser(email, password);

            HttpSession session = req.getSession();
            if (user != null) {
            	if( role.equals("customer") && user.getRole().equalsIgnoreCase("customer") ) {
            		session.setAttribute("user", user);
            		userDaoImpl.upadateUser(user);
            		resp.sendRedirect("User/user_homepage.jsp");
            	}
            	else if (role.equalsIgnoreCase("admin") && user.getRole().equalsIgnoreCase("admin")) {
            		session.setAttribute("user", user);
            		
            		userDaoImpl.upadateUser(user);
            		resp.sendRedirect("admindashboard.jsp");
            	}
            	else {
            		session.setAttribute("message", "Login Failed: Invalid Username or Password");
            		resp.sendRedirect("sign_in.jsp");
            	}
            }
        } catch (Exception e) {
            e.printStackTrace();
            resp.getWriter().println("<h1>An error occurred during login. Please try again later.</h1>");
        }
    }
}
