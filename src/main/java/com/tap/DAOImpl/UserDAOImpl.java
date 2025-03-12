package com.tap.DAOImpl;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

import javax.persistence.TypedQuery;

import org.hibernate.Hibernate;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;

import com.tap.DAO.UserDAO;
import com.tap.model.User;

public class UserDAOImpl implements UserDAO {
    
    private SessionFactory sessionFactory;
    
    public UserDAOImpl(SessionFactory sessionFactory) {
        super();
        this.sessionFactory = sessionFactory;
    }
    
    
    public boolean usernameExists(String username) {
		Session session = null;
		session = sessionFactory.openSession();
		try {
	        String hql = "from User where username = :username";
	        TypedQuery<User> query = session.createQuery(hql);
	        query.setParameter("username", username);

	        List<User> resultList = query.getResultList();
	        return !resultList.isEmpty(); 
	    } finally {
	        session.close();
	    }
	}
    
    @Override
    public boolean saveUser(User user) {
        try (Session session = sessionFactory.openSession()) {
            Transaction transaction = session.beginTransaction();
            
            session.save(user);
            transaction.commit();
            
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public User getUser(String email, String password) {
        try (Session session = sessionFactory.openSession()) {
            String hql = "from User where email = :email AND password = :password";
            
            TypedQuery<User> query = session.createQuery(hql);
            query.setParameter("email", email);
            query.setParameter("password", password);
            User userr =  query.getSingleResult();
            Hibernate.initialize(userr.getAddresses());
            return userr;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    @Override
    public List<User> getAllUser() {
        List<User> allUser = new ArrayList<>();
        try (Session session = sessionFactory.openSession()) {
            String hql = "from User";
            TypedQuery<User> query = session.createQuery(hql, User.class);
            allUser = query.getResultList();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return allUser;
    }

    @Override
    public boolean deleteUser(int userId) {
        try (Session session = sessionFactory.openSession()) {
            Transaction transaction = session.beginTransaction();
            
            User user = session.get(User.class, userId);
            if (user != null) {
                session.delete(user);
                transaction.commit();
                return true;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

	@Override
	public boolean upadateUser(User user) {
		try (Session session = sessionFactory.openSession()) {
            Transaction transaction = session.beginTransaction();
            
            user.setLastLoginDate(LocalDateTime.now()); // Update last login time
            session.update(user); // Persist the changes
            
            transaction.commit();
            
            return true;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
	}
}
