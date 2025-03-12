package com.tap.DAO;

import com.tap.model.CartItem;

public interface CartDAO {

	public void saveCart(CartItem cartItem);
	public void deleteCart(int itemId);
	
}
