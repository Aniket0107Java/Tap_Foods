package com.tap.servlets;

import java.io.IOException;
import java.io.PrintWriter;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.tap.DAOImpl.UserDAOImpl;
import com.tap.model.Address;
import com.tap.model.User;
import com.utility.HibernateUtility;

/**
 * Servlet implementation class SaveUserServlet
 */
@WebServlet("/saveUser")
public class SaveUserServlet extends HttpServlet {
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		
	    PrintWriter out = resp.getWriter();
	    
	    try {
	    	String name = req.getParameter("name");
			String username = req.getParameter("username");
			String password = req.getParameter("password");
			String email = req.getParameter("email");
			String phone = req.getParameter("phone");
			String address = req.getParameter("address");
			String role = req.getParameter("role");
			LocalDateTime createdDate = LocalDateTime.now();
			LocalDateTime lastLoginDate = LocalDateTime.now();
			
			User user = new User(name, username, password, email, phone, role, createdDate, lastLoginDate);
			Address addresses = new Address();
		    addresses.setAddress(address);
		    addresses.setUser(user);
		    addresses.setName(name);
		    addresses.setPhone(phone);
		    
		    // Add address to user's address list
		    List<Address> add = new ArrayList<>();
		    add.add(addresses);
		    user.setAddresses(add);
			
			UserDAOImpl userDAOImpl = new UserDAOImpl(HibernateUtility.getSessionFactory());
			
			if(userDAOImpl.usernameExists(username)) {
				resp.sendRedirect("footer/confirmation.jsp");
			}
			else {
				boolean f = userDAOImpl.saveUser(user);
				out.println("<h1>Successfully</h1>");
			}
			
		} catch (Exception e) {
			// TODO: handle exception
			out.println("<h1>failed</h1>");
			e.printStackTrace();
		}
	}
}
