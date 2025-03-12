package com.tap.DAO;

public interface CartItemDAO {

	public void addToCart(int userId, int menuId, int quantity);
	
	public void removeFromCart(int userId, int menuId, int quantity);
	
}
