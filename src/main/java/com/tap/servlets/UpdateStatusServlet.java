package com.tap.servlets;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.tap.DAOImpl.OrderDAOImpl;
import com.tap.model.Orders;
import com.utility.HibernateUtility;

/**
 * Servlet implementation class OrderHistoryServlets
 */
@WebServlet("/updateStatus")
public class UpdateStatusServlet extends HttpServlet {
	
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		
		String status = req.getParameter("orderStatus");
		
		int orderId = Integer.parseInt(req.getParameter("orderId"));
		System.out.println("status: "+status);
		System.out.println("orderId: "+orderId);
		
		OrderDAOImpl orderDAOImpl = new OrderDAOImpl(HibernateUtility.getSessionFactory());
		
		Orders order = orderDAOImpl.getOrder(orderId);
		
		order.setStatus(status);
		
		orderDAOImpl.upadateOrder(order);
		
		resp.sendRedirect("admindashboard.jsp");
		
	}
	
}
