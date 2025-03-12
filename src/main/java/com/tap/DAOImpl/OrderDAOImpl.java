package com.tap.DAOImpl;

import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;

import com.tap.DAO.OrderDAO;
import com.tap.model.Orders;
import com.tap.model.Restaurant;

public class OrderDAOImpl implements OrderDAO {

	private SessionFactory sessionFactory;
	
	public OrderDAOImpl(SessionFactory sessionFactory) {
		super();
		this.sessionFactory = sessionFactory;
	}

	@Override
	public void saveOrder(Orders orders) {
		Session session = null;
		Transaction transaction = null;
		try {
			session = sessionFactory.openSession();
			transaction = session.beginTransaction();
			
			session.save(orders);
			transaction.commit();
		
		} catch (Exception e) {
			e.printStackTrace();
			transaction.rollback();
		
		} finally {			
			session.close();
		}
	}

	@Override
	public Orders getOrder(int orderId) {
		Orders order = null;
		Session session = sessionFactory.openSession();
		Transaction transaction = null;
		try {
			transaction = session.beginTransaction();
			
			order = session.get(Orders.class, orderId);
			
			transaction.commit();
		} catch (Exception e) {
			// TODO: handle exception
			transaction.rollback();
		} finally {
			session.close();
		}
		return order;
	}

	@Override
	public List<Orders> getAllOrders() {
		List<Orders> orders = null;

		// Open a session
		Session session = sessionFactory.openSession();

		// Begin a transaction (optional for read-only operations but a good practice)
		Transaction transaction = session.beginTransaction();

		try {
			// HQL query to fetch all rows from the "Restaurant" entity
			String hql = "FROM Orders";

			// Create query
			Query<Orders> query = session.createQuery(hql, Orders.class);

			// Execute the query and get the results
			orders = query.list();

			// Commit the transaction
			transaction.commit();
		} catch (Exception e) {
			if (transaction != null)
				transaction.rollback();
			e.printStackTrace();
		} finally {
			session.close();
		}

		return orders;
	}
	
	public List<Orders> getAllOrdersByAdminId(int adminId) {
		List<Orders> orders = null;

		// Open a session
		Session session = sessionFactory.openSession();

		// Begin a transaction (optional for read-only operations but a good practice)
		Transaction transaction = session.beginTransaction();

		try {
			// HQL query to fetch all rows from the "Restaurant" entity
			String hql = "FROM Orders WHERE adminId = : adminId";
//			Query<Restaurant> query = session.createQuery("FROM Restaurant WHERE adminUserId = :adminUserId", Restaurant.class);
			
			// Create query
			Query<Orders> query = session.createQuery(hql, Orders.class);
			query.setParameter("adminId", adminId);

			// Execute the query and get the results
			orders = query.list();

			// Commit the transaction
			transaction.commit();
		} catch (Exception e) {
			if (transaction != null)
				transaction.rollback();
			e.printStackTrace();
		} finally {
			session.close();
		}

		return orders;
	}

	@Override
	public boolean deleteOrder(int orderId) {
		int res = 0;
//		try {
//			connection = DBConnection.getConnection();
//			preparedStatement = connection.prepareStatement(DELETE_ORDER_QUERY);
//			preparedStatement.setInt(1, orderId);
//			res = preparedStatement.executeUpdate();
//		
//		} catch (Exception e) {
//			e.printStackTrace();
//		}
		return res==1;
	}

	@Override
	public void upadateOrder(Orders order) {
		Session session = sessionFactory.openSession();
		
		Transaction transaction = null;
		
		try {
			transaction = session.beginTransaction();
			
			session.update(order);
			
			transaction.commit();
			
		} catch (Exception e) {
			// TODO: handle exception
			transaction.rollback();
		} finally {
			session.close();
		}
	}

}