package com.tap.servlets;

import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalDateTime;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.tap.DAO.MenuDAO;
import com.tap.DAOImpl.MenuDAOImpl;
import com.tap.DAOImpl.OrderDAOImpl;
import com.tap.DAOImpl.OrderItemDAOImpl;
import com.tap.DAOImpl.RestaurantDAOImpl;
import com.utility.HibernateUtility;
import com.tap.model.*;

/**
 * Servlet implementation class OrderServlets
 */
@WebServlet("/orderServlet")
public class OrderServlets extends HttpServlet {
	
	private OrderDAOImpl orderDAOImpl;
	private OrderItemDAOImpl orderItemDAOImpl;
	
	@Override
		public void init() throws ServletException {
			orderDAOImpl =  new OrderDAOImpl(HibernateUtility.getSessionFactory());
			orderItemDAOImpl =  new OrderItemDAOImpl(HibernateUtility.getSessionFactory());
		}
	
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		
		try {
			HttpSession session = req.getSession();
			
			User user = (User)session.getAttribute("user");
			Cart cart = (Cart)session.getAttribute("cart");
			String deliveryName = req.getParameter("deliveryName");
			String deliveryPhone = req.getParameter("deliveryPhone");
			String deliveryAddress = req.getParameter("deliveryAddress");
			String paymentMode = req.getParameter("paymentMode");

			
			System.out.println(deliveryName);
			System.out.println(deliveryPhone);
			System.out.println(deliveryAddress);
			System.out.println(paymentMode);
			System.out.println(cart.getRestaurantId());
			
			RestaurantDAOImpl restaurantDAOImpl = new RestaurantDAOImpl(HibernateUtility.getSessionFactory());
			Restaurant restaurant = restaurantDAOImpl.getRestaurant(cart.getRestaurantId());
			int adminId = restaurant.getAdminUserId();
			LocalDate orderDate = LocalDateTime.now().toLocalDate();
			
			Orders order = new Orders(user, adminId, deliveryName, deliveryPhone, deliveryAddress, restaurant, orderDate, cart.getTotalPrice(), "Processing", paymentMode);
			orderDAOImpl.saveOrder(order);
			System.out.println(1);
			
			for(CartItem cartItem : cart.getItems().values()) {
				int totalPrice = cartItem.getQuantity() * cartItem.getPrice();
				MenuDAOImpl menuDAOImpl = new MenuDAOImpl(HibernateUtility.getSessionFactory());
				Menu menu = menuDAOImpl.getMenu(cartItem.getMenuId());
				OrderItem orderItem = new OrderItem(order, menu, cartItem.getQuantity(), totalPrice);
				
				orderItemDAOImpl.saveOrderItem(orderItem);
			}
			session.removeAttribute("cart");
//			resp.sendRedirect("order_animation.jsp");
//			resp.sendRedirect("order_animation.jsp?orderNumber="+order.getOrderId()+"address="+order.getDeliveryAddress());

			session.setAttribute("orderNumber", order.getOrderId());
			session.setAttribute("address", order.getDeliveryAddress());

			resp.sendRedirect("order_animation.jsp");
		} catch (Exception e) {
			e.printStackTrace();
//			System.out.println("Something went wring please try again");
			resp.getWriter().println("Something went wring please try again");
		}
		
	}

}