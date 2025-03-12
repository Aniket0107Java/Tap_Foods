package com.tap.DAOImpl;

import java.util.List;

import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;

import com.tap.DAO.RestaurantDAO;
import com.tap.model.Restaurant;
import com.tap.model.User;
import com.utility.HibernateUtility;

public class RestaurantDAOImpl implements RestaurantDAO {

	private SessionFactory sessionFactory;

	public RestaurantDAOImpl(SessionFactory sessionFactory) {
		super();
		this.sessionFactory = sessionFactory;
	}

	@Override
	public void addRestaurantWithMenu(Restaurant restaurant) {
        Transaction transaction = null;
        try (Session session = HibernateUtility.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            
            // Save the restaurant (it will automatically save the menu items due to cascade)
            session.save(restaurant);
            
            transaction.commit(); // Commit the transaction
        } catch (Exception e) {
            if (transaction != null) {
                transaction.rollback(); // Rollback if any exception occurs
            }
            e.printStackTrace();
        }
    }

	@Override
	public Restaurant getRestaurant(int restaurantId) {

		Restaurant restaurant = null;

		Session session = sessionFactory.openSession();
		try {

			restaurant = session.get(Restaurant.class, restaurantId);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			session.close();
		}

		return restaurant;
	}

	@Override
	public List<Restaurant> getAllRestaurant() {
		List<Restaurant> restaurants = null;

		// Open a session
		Session session = sessionFactory.openSession();

		// Begin a transaction (optional for read-only operations but a good practice)
		Transaction transaction = session.beginTransaction();

		try {
			// HQL query to fetch all rows from the "Restaurant" entity
			String hql = "FROM Restaurant";

			// Create query
			Query<Restaurant> query = session.createQuery(hql, Restaurant.class);

			// Execute the query and get the results
			restaurants = query.list();

			// Commit the transaction
			transaction.commit();
		} catch (Exception e) {
			if (transaction != null)
				transaction.rollback();
			e.printStackTrace();
		} finally {
			session.close();
		}

		return restaurants;
	}

	@Override
	public boolean deleteRestaurant(int restaurantId) {
		int res = 0;
//		try {
//			connection = DBConnection.getConnection();
//			preparedStatement = connection.prepareStatement(DELETE_RESTAURANT_QUERY);
//			preparedStatement.setInt(1, restaurantId);
//			res = preparedStatement.executeUpdate();
//
//		} catch (Exception e) {
//			e.printStackTrace();
//		}
		return res == 1;
	}

	@Override
	public boolean upadateRestaurant(Restaurant restaurant) {
		
		Session session = sessionFactory.openSession(); 
		
		Transaction transaction = null;
		
		try {
	        transaction = session.beginTransaction();
	        session.saveOrUpdate(restaurant);
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

	public List<Restaurant> getAllRestaurantByUserId(int adminUserId) {
		List<Restaurant> list = null;
		Session session = sessionFactory.openSession();
//		List<Menu> menuList = new ArrayList<>();
		try {
			session = sessionFactory.openSession();
			session.beginTransaction();

			Query<Restaurant> query = session.createQuery("FROM Restaurant WHERE adminUserId = :adminUserId", Restaurant.class);
			query.setParameter("adminUserId", adminUserId);

			list = query.getResultList();

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
		return list;
	}

}
