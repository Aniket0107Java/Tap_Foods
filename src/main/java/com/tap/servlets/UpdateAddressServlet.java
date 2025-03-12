package com.tap.servlets;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.tap.DAOImpl.AddressDAOImpl;
import com.tap.DAOImpl.UserDAOImpl;
import com.tap.model.Address;
import com.tap.model.User;
import com.utility.HibernateUtility;


@WebServlet("/updateAddressServlet")
public class UpdateAddressServlet extends HttpServlet {
	
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		
		HttpSession session = req.getSession();
		
		User user = (User) session.getAttribute("user");
		
		String name = req.getParameter("name");
		String address = req.getParameter("address");
		String phone = req.getParameter("phone");
		int userId = user.getUserId();
		
		Address address2 = new Address(address, user, name, phone);
		
		AddressDAOImpl addressDAOImpl = new AddressDAOImpl(HibernateUtility.getSessionFactory());
		
		addressDAOImpl.addNewAddress(address2);
		
		UserDAOImpl userDAOImpl = new UserDAOImpl(HibernateUtility.getSessionFactory());
		
		User updatedUser = userDAOImpl.getUser(user.getEmail(), user.getPassword()); 
		
		session.setAttribute("user", updatedUser);
		
		resp.sendRedirect("checkout.jsp");
		
	}
	
}
