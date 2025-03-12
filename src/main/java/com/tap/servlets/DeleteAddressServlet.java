package com.tap.servlets;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.tap.DAOImpl.AddressDAOImpl;
import com.utility.HibernateUtility;

@WebServlet("/deleteAddress")
public class DeleteAddressServlet extends HttpServlet {
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		int addressId = Integer.parseInt(req.getParameter("addressId"));
		
		AddressDAOImpl addressDAOImpl = new AddressDAOImpl(HibernateUtility.getSessionFactory());
		
		addressDAOImpl.deleteAddress(addressId);
		resp.sendRedirect("User/profile.jsp");
	}
}
