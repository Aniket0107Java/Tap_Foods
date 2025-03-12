package com.tap.model;

import java.util.HashMap;
import java.util.Map;

import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

//@Entity
//@Table(name = "cart")
public class Cart {

    @Id
    private int cartId; // Primary key
    
    private int userId;
    private int restaurantId;

    private Map<Integer, CartItem> items; // Stores menuId -> CartItem

    public Cart() {
        this.items = new HashMap<>();
    }

    public Cart(int restaurantId) {
        this.restaurantId = restaurantId;
        this.items = new HashMap<>();
    }

    public int getCartId() {
        return cartId;
    }

    public void setCartId(int cartId) {
        this.cartId = cartId;
    }

    public int getRestaurantId() {
        return restaurantId;
    }

    public void setRestaurantId(int restaurantId) {
        this.restaurantId = restaurantId;
    }

    public Map<Integer, CartItem> getItems() {
        return items;
    }

    // Add item to cart (If exists, update quantity)
    public void addItem(CartItem item) {
        if (items.containsKey(item.getMenuId())) {
            CartItem existingItem = items.get(item.getMenuId());
            existingItem.setQuantity(existingItem.getQuantity() + item.getQuantity());
        } else {
            items.put(item.getMenuId(), item);
        }
    }

    // Update item quantity
    public void updateItem(int menuId, int quantity) {
        if (items.containsKey(menuId)) {
            if (quantity > 0) {
                items.get(menuId).setQuantity(quantity);
            } else {	
                items.remove(menuId);
            }
        }
    }

    // Remove item from cart
    public void removeItem(int menuId) {
        items.remove(menuId);
    }

    // Get total cart price
    public int getTotalPrice() {
        return items.values().stream().mapToInt(item -> item.getPrice() * item.getQuantity()).sum();
    }

    @Override
    public String toString() {
        return "Cart{" +
                "cartId=" + cartId +
                ", restaurantId=" + restaurantId +
                ", items=" + items.values() +
                '}';
    }
}
