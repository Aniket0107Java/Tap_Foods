package com.tap.servlets;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.tap.DAOImpl.MenuDAOImpl;
import com.tap.model.Menu;
import com.tap.model.Restaurant;
import com.utility.HibernateUtility;

/**
 * Servlet implementation class AddMenuItemServlet
 */
@WebServlet("/AddMenuItem")
public class AddMenuItemServlet extends HttpServlet {
	
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		
		String itemName = req.getParameter("item_name");
		String menuDecription = req.getParameter("menu_description");
		int price = Integer.parseInt(req.getParameter("price"));
		boolean status = Boolean.parseBoolean(req.getParameter("is_available"));
		String imagePath = req.getParameter("image_path");		
		HttpSession session = req.getSession();
		
		Restaurant currentRestaurant = (Restaurant)session.getAttribute("restaurant");
		
		Menu menu = new Menu(currentRestaurant, itemName, menuDecription, price, "4.5", status, imagePath);
		
		MenuDAOImpl menuDAOImpl = new MenuDAOImpl(HibernateUtility.getSessionFactory());
		
		boolean saveMenu = menuDAOImpl.saveMenu(menu);
		
		PrintWriter out = resp.getWriter();
		
		if(saveMenu) {
//			out.println("<h1> success </h1>");
//			out.println(restaurantAddress+" "+isActive+" "+restaurantAddress+" "+restaurantPhone+" "+cusineType+" "+imagePath);
			resp.sendRedirect("Admin/restaurant_details.jsp?restaurantId="+currentRestaurant.getRestaurantId());
		}
		else {
			out.println("<h1> failed </h1>");
//			out.println(restaurantAddress+" "+isActive+" "+restaurantAddress+" "+restaurantPhone+" "+cusineType+" "+imagePath);
		}
		
	}

}
