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
import com.utility.HibernateUtility;

/**
 * Servlet implementation class UpdateMenuDetailsServlet
 */
@WebServlet("/UpdateMenuDetails")
public class UpdateMenuDetailsServlet extends HttpServlet {
	
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		String itemName = req.getParameter("item_name");
		String menuDecription = req.getParameter("menu_description");
		int price = Integer.parseInt(req.getParameter("price"));
		boolean status = "true".equals(req.getParameter("is_available"));
		String imagePath = req.getParameter("image_path");

		HttpSession session = req.getSession();
		
//		Menu menuToUpdat = (Menu)session.getAttribute("currentMenu");
		
		int id = Integer.parseInt(req.getParameter("menuId"));
		
		MenuDAOImpl menuDAOImpl = new MenuDAOImpl(HibernateUtility.getSessionFactory());
		
		Menu menuToUpdat = menuDAOImpl.getMenu(id);

		menuToUpdat.setItemName(itemName);
		menuToUpdat.setDescription(menuDecription);
		menuToUpdat.setPrice(price);
		menuToUpdat.setIsAvailable(status);
		menuToUpdat.setImagePath(imagePath);
		
		
		boolean upadateMenu = menuDAOImpl.upadateMenu(menuToUpdat);
	
		PrintWriter out = resp.getWriter();
		
		if(upadateMenu) {
//			out.println("<h1> success </h1>");
//			out.println(restaurantAddress+" "+isActive+" "+restaurantAddress+" "+restaurantPhone+" "+cusineType+" "+imagePath);
			resp.sendRedirect("Admin/restaurant_details.jsp?restaurantId="+menuToUpdat.getRestaurant().getRestaurantId());
		}
		else {
			out.println("Admin/restaurant_details.jsp?restaurantId="+menuToUpdat.getRestaurant());
//			out.println(restaurantAddress+" "+isActive+" "+restaurantAddress+" "+restaurantPhone+" "+cusineType+" "+imagePath);
		}
	}
	
}
