package com.tap.servlets;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.google.gson.Gson;
import com.tap.DAOImpl.MenuDAOImpl;
import com.tap.model.Cart;
import com.tap.model.CartItem;
import com.tap.model.Menu;
import com.utility.HibernateUtility;

@WebServlet("/cart")
public class CartServlets extends HttpServlet {
    private Gson gson = new Gson();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();

        int menuId = Integer.parseInt(req.getParameter("menuId"));
        int newRestaurantId = Integer.parseInt(req.getParameter("restaurantId"));
        int price = Integer.parseInt(req.getParameter("price"));
        int quantity = Integer.parseInt(req.getParameter("quantity"));
        String action = req.getParameter("action");

        Cart cart = (Cart) session.getAttribute("cart");
        if (cart == null) {
            cart = new Cart(newRestaurantId);
            session.setAttribute("cart", cart);
        }

        // Special action to check cart state
        if ("check".equals(action)) {
            CartResponse response = prepareCartResponse(cart);
            resp.setContentType("application/json");
            resp.setCharacterEncoding("UTF-8");
            resp.getWriter().write(gson.toJson(response));
            return;
        }

        // If adding item from different restaurant, clear cart first
        if (cart.getRestaurantId() != newRestaurantId && !cart.getItems().isEmpty()) {
            cart = new Cart(newRestaurantId);
            session.setAttribute("cart", cart);
        }

        if ("add".equals(action)) {
            addItem(cart, menuId, price, quantity);
        } else if ("update".equals(action)) {
            updateItem(cart, menuId, quantity);
        } else if ("remove".equals(action)) {
            CartItem item = cart.getItems().get(menuId);
            if (item != null && item.getQuantity() > 1) {
                // If quantity > 1, decrease quantity
                updateItem(cart, menuId, item.getQuantity() - 1);
            } else {
                // If quantity is 1, remove the item
                removeItem(cart, menuId);
            }
        }

        session.setAttribute("cart", cart);
        
        // Prepare response data
        CartResponse cartResponse = prepareCartResponse(cart);
        
        // Send JSON response
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        resp.getWriter().write(gson.toJson(cartResponse));
    }

    private CartResponse prepareCartResponse(Cart cart) {
        CartResponse response = new CartResponse();
        response.setItemCount(cart.getItems().size());
        response.setTotalPrice(cart.getTotalPrice());
        response.setRestaurantId(cart.getRestaurantId());

        List<CartItemResponse> items = new ArrayList<>();
        MenuDAOImpl menuDAOImpl = new MenuDAOImpl(HibernateUtility.getSessionFactory());

        for (Map.Entry<Integer, CartItem> entry : cart.getItems().entrySet()) {
            CartItem cartItem = entry.getValue();
            Menu menu = menuDAOImpl.getMenu(cartItem.getMenuId());
            
            CartItemResponse itemResponse = new CartItemResponse();
            itemResponse.setMenuId(cartItem.getMenuId());
            itemResponse.setName(cartItem.getName());
            itemResponse.setPrice(cartItem.getPrice());
            itemResponse.setQuantity(cartItem.getQuantity());
            itemResponse.setImagePath(menu.getImagePath());
            
            items.add(itemResponse);
        }
        
        response.setItems(items);
        return response;
    }

    private void addItem(Cart cart, int menuId, int price, int quantity) {
        MenuDAOImpl menuDAOImpl = new MenuDAOImpl(HibernateUtility.getSessionFactory());
        Menu menu = menuDAOImpl.getMenu(menuId);
        
        if (menu != null) {
            CartItem existingItem = cart.getItems().get(menuId);
            if (existingItem != null) {
                // If item exists, increase quantity
                updateItem(cart, menuId, existingItem.getQuantity() + 1);
            } else {
                // If new item, add it
                String name = menu.getItemName();
                CartItem cartItem = new CartItem(menuId, name, price, quantity);
                cart.addItem(cartItem);
            }
        }
    }

    private void updateItem(Cart cart, int menuId, int quantity) {
        cart.updateItem(menuId, quantity);
    }

    private void removeItem(Cart cart, int menuId) {
        cart.removeItem(menuId);
    }

    // Response classes for JSON serialization
    private static class CartResponse {
        private int itemCount;
        private int totalPrice;
        private int restaurantId;
        private List<CartItemResponse> items;

        public void setItemCount(int itemCount) { this.itemCount = itemCount; }
        public void setTotalPrice(int totalPrice) { this.totalPrice = totalPrice; }
        public void setRestaurantId(int restaurantId) { this.restaurantId = restaurantId; }
        public void setItems(List<CartItemResponse> items) { this.items = items; }
    }

    private static class CartItemResponse {
        private int menuId;
        private String name;
        private int price;
        private int quantity;
        private String imagePath;

        public void setMenuId(int menuId) { this.menuId = menuId; }
        public void setName(String name) { this.name = name; }
        public void setPrice(int price) { this.price = price; }
        public void setQuantity(int quantity) { this.quantity = quantity; }
        public void setImagePath(String imagePath) { this.imagePath = imagePath; }
    }
}