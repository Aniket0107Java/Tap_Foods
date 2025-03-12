package com.tap.servlets;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.tap.DAOImpl.UserDAOImpl;
import com.tap.model.User;
import com.utility.HibernateUtility;

/**
 * Servlet implementation class UpdateUserDetailsServlet
 */
@WebServlet("/UpdateUserDetails")
public class UpdateUserDetailsServlet extends HttpServlet {
	
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		
		String phone = req.getParameter("phone");
		String name = req.getParameter("name");
		String email = req.getParameter("email");
		
		
		try {
			UserDAOImpl userDAOImpl = new UserDAOImpl(HibernateUtility.getSessionFactory());
			
			
			HttpSession session = req.getSession();
			
			User user = (User)session.getAttribute("user");
			
			user.setPhone(phone);
			user.setEmail(email);
			user.setName(name);
			
			userDAOImpl.upadateUser(user);
			
			resp.sendRedirect("User/profile.jsp");
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		
	}

}
