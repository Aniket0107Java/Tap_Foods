package com.tap.servlets;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.tap.DAOImpl.RestaurantDAOImpl;
import com.tap.model.Restaurant;
import com.utility.HibernateUtility;

/**
 * Servlet implementation class UpdateRetaurantDetailsServlet
 */
@WebServlet("/UpdateRestaurantDetails")
public class UpdateRetaurantDetailsServlet extends HttpServlet {
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		String restaurantName = req.getParameter("restaurant_name");
		boolean isActive = "true".equals(req.getParameter("is_active"));
		String restaurantAddress = req.getParameter("restaurant_address");
		String restaurantPhone = req.getParameter("restaurant_phone");
		String cusineType = req.getParameter("cuisine_type");
		String imagePath = req.getParameter("image_url");

		
		HttpSession session = req.getSession();
		
		
		Restaurant currentRestaurant = (Restaurant)session.getAttribute("restaurant");
		
		currentRestaurant.setName(restaurantName);
		currentRestaurant.setIsActive(isActive);
		currentRestaurant.setAddress(restaurantAddress);
		currentRestaurant.setPhone(restaurantPhone);
		currentRestaurant.setCusineType(cusineType);
		currentRestaurant.setImagePath(imagePath);
		
		RestaurantDAOImpl restaurantDAOImpl = new RestaurantDAOImpl(HibernateUtility.getSessionFactory());
		
		boolean upadateRestaurant = restaurantDAOImpl.upadateRestaurant(currentRestaurant);
		
		PrintWriter out = resp.getWriter();
		
		if(upadateRestaurant) {
//			out.println("<h1> success </h1>");
//			out.println(restaurantAddress+" "+isActive+" "+restaurantAddress+" "+restaurantPhone+" "+cusineType+" "+imagePath);
			resp.sendRedirect("Admin/restaurant_details.jsp?restaurantId="+currentRestaurant.getRestaurantId());
			
		}
		else {
			out.println("<h1> failed </h1>");
			out.println(restaurantAddress+" "+isActive+" "+restaurantAddress+" "+restaurantPhone+" "+cusineType+" "+imagePath);
		}
	}
}
