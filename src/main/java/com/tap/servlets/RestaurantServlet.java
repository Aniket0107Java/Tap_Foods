package com.tap.servlets;

import java.awt.MenuItem;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.tap.DAO.RestaurantDAO;
import com.tap.DAOImpl.RestaurantDAOImpl;
import com.tap.model.Restaurant;
import com.utility.HibernateUtility;
import com.tap.model.*;

@WebServlet("/admin/addRestaurant")
public class RestaurantServlet extends HttpServlet {

    private RestaurantDAO restaurantDAO;

//    @Override
//    public void init() throws ServletException {
//        restaurantDAO = new RestaurantDAO();
//    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String name = request.getParameter("restaurant_name");
        String address = request.getParameter("restaurant_address");
        String phone = request.getParameter("restaurant_phone");
        String email = request.getParameter("cusinetype");
        String imageUrl = request.getParameter("imageUrl");
        HttpSession session = request.getSession();
        User user = (User)session.getAttribute("user");
        
        Restaurant restaurant = new Restaurant();
        restaurant.setName(name);
        restaurant.setAddress(address);
        restaurant.setPhone(phone);
        restaurant.setCusineType(email);
        restaurant.setRating("4.5");
        restaurant.setImagePath(imageUrl);
        restaurant.setIsActive(true);
        restaurant.setEta("40 min");
        restaurant.setAdminUserId(user.getUserId());		
        
        Restaurant restaurant2 = new Restaurant(name, address, phone, "4.5", email, true, "30-40 min", user.getUserId(), imageUrl);
        

        // Collecting menu items from the form
        List<Menu> menuItems = new ArrayList<>();
        for (int i = 1; i <= 5; i++) { // Assume there are 5 menu items for simplicity
            String itemName = request.getParameter("item-name-"+i);
            String itemDescription = request.getParameter("item-description-"+i);
            String itemPrice = request.getParameter("item-price-"+i);
            String itemImage = request.getParameter("item-image-"+i);
            if (itemName != null && !itemName.isEmpty()) {
                Menu menuItem = new Menu();
                menuItem.setItemName(itemName);
                menuItem.setDescription(itemDescription);
                menuItem.setPrice(Integer.parseInt(itemPrice));
                menuItem.setRatings("4.6");
                menuItem.setIsAvailable(true);
                menuItem.setRestaurant(restaurant);
                menuItems.add(menuItem);
            }
        }

        restaurant.setMenuItems(menuItems);

        // Save restaurant and menu items to DB using Hibernate
        RestaurantDAOImpl restaurantDAOImpl = new RestaurantDAOImpl(HibernateUtility.getSessionFactory());
        restaurantDAOImpl.addRestaurantWithMenu(restaurant);

        request.setAttribute("message", "Restaurant and menu added successfully!");
//        request.getRequestDispatcher("/admin/dashboard").forward(request, response);
        PrintWriter writer = response.getWriter();
        writer.println("<h1> success </h1>");
    }
}
