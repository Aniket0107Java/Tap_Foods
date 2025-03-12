package com.tap.servlets;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.tap.DAOImpl.RestaurantDAOImpl;
import com.tap.model.Restaurant;
import com.utility.HibernateUtility;

/**
 * Servlet implementation class HomeServlet
 */
@WebServlet("/HomServlet")
public class HomeServlet extends HttpServlet {
	
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		
		
		RestaurantDAOImpl restaurantDAOImpl = new RestaurantDAOImpl(HibernateUtility.getSessionFactory());
		
		List<Restaurant> allRestaurant = restaurantDAOImpl.getAllRestaurant();
//		Restaurant restaurant = restaurantDAOImpl.getRestaurant(1);
		
		PrintWriter out = resp.getWriter();
		for(Restaurant r : allRestaurant) {
//			System.out.println(r);
			
			out.println("<h1>"+ r +"</h1>");
		}
//		System.out.println(restaurant);
		
		
	}
	
}
