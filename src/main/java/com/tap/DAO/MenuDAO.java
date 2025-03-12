package com.tap.DAO;

import java.util.List;

import com.tap.model.Menu;
import com.tap.model.OrderItem;

public interface MenuDAO {
	public boolean saveMenu(Menu menu);
	public Menu getMenu(int menuId);
	public List<Menu>getAllMenu(int restaurantId);
	public boolean deleteMenu(int menuId);
	public boolean upadateMenu(Menu menu);
}
