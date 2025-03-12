package com.tap.DAOImpl;

import java.nio.channels.ClosedChannelException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;

import com.tap.DAO.MenuDAO;

import com.tap.model.Menu;
import com.tap.model.OrderItem;
import com.tap.model.Restaurant;

public class MenuDAOImpl implements MenuDAO {

//	private static final String SAVE_MENU_QUERY = "INSERT INTO `menu` (`menuId`, `restaurantId`, `itemName`, `description`, `price`, `ratings`, `isAvailable`, `imagePath`) VALUES (?,?,?,?,?,?,?,?)";
//	private static final String GET_MENU_QUERY = "SELECT * FROM `orderItem` WHERE `orderItemId` = ?";
//	private static final String DELETE_MENU_QUERY = "DELETE FROM `menu` WHERE `menuId` = ?";
//	private static final String GET_ALL_MENU_QUERY = "SELECT * FROM `orderItem`";
//	private static final String UPDATE_MENU_QUERY = "UPDATE `orderItem` SET `quantity` = ? `price` = ? WHERE orderId = ?";
//
//	Connection connection = null;
//	PreparedStatement preparedStatement = null;
//	Statement statement = null;

	private SessionFactory sessionFactory;

	public MenuDAOImpl(SessionFactory sessionFactory) {
		super();
		this.sessionFactory = sessionFactory;
	}

	@Override
	public boolean saveMenu(Menu menu) {
		
		Session session = sessionFactory.openSession();
		
		Transaction transaction = null;
		
		try {
			transaction = session.beginTransaction();
			session.save(menu);
			transaction.commit();
			return true;
		} catch (Exception e) {
			transaction.rollback();
			return false;
		}
		
	}

	@Override
	public Menu getMenu(int menuId) {
		Menu menu = null;

		Session session = sessionFactory.openSession();
		try {

			menu = session.get(Menu.class, menuId);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			session.close();
		}

		return menu;
	}

	@Override
	public List<Menu> getAllMenu(int restaurantId) {
		Session session = sessionFactory.openSession();
		List<Menu> menuList = new ArrayList<>();
	    try {
	        session = sessionFactory.openSession();
	        session.beginTransaction();

	        Query<Menu> query = session.createQuery(
	            "FROM Menu WHERE restaurant_id = :restaurantId", Menu.class);
	        query.setParameter("restaurantId", restaurantId);

	        menuList = query.getResultList();

	        session.getTransaction().commit();
	    } catch (Exception e) {
	        if (session != null && session.getTransaction() != null) {
	            session.getTransaction().rollback();
	        }
	        e.printStackTrace();
	    } finally {
	        if (session != null) {
	            session.close();
	        }
	    }
	    return menuList;
	}

	@Override
	public boolean deleteMenu(int menuId) {
		int res = 0;
//		try {
//			connection = DBConnection.getConnection();
//			preparedStatement = connection.prepareStatement(DELETE_MENU_QUERY);
//			preparedStatement.setInt(1, menuId);
//			res = preparedStatement.executeUpdate();
//		} catch (Exception e) {
//			e.printStackTrace();
//		}
		return res == 1;
	}

	@Override
	public boolean upadateMenu(Menu menu) {
		Session session = sessionFactory.openSession(); 
		
		Transaction transaction = null;
		
		try {
	        transaction = session.beginTransaction();
	        session.update(menu);
//	        Commit if successful
	        transaction.commit();        
	        return true;
	    } catch (Exception e) {
//	    	 Rollback on failure
	    	transaction.rollback();  
	        if (transaction != null) {
	        }
	        e.printStackTrace();
	        return false;
	    } finally {
	        session.close();
	    }
	}

}
