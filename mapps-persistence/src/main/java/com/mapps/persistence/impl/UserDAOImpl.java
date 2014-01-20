package com.mapps.persistence.impl;

import java.util.List;
import javax.ejb.Stateless;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.Query;

import org.apache.log4j.Logger;

import com.mapps.exceptions.NullParameterException;
import com.mapps.exceptions.UserAlreadyExistException;
import com.mapps.exceptions.UserNotFoundException;
import com.mapps.model.User;
import com.mapps.persistence.UserDAO;

/**
 *
 */
@Stateless(name = "UserDAO")
public class UserDAOImpl implements UserDAO {

    Logger logger = Logger.getLogger(UserDAOImpl.class);
    @PersistenceContext(unitName = "mapps-persistence")
    EntityManager entityManager;


    @Override
    public void addUser(User user) throws UserAlreadyExistException, NullParameterException {
        if (user != null) {
            if (isInDatabase(user)) {
                throw new UserAlreadyExistException();
            }
            logger.info("a user was added to the database");
            entityManager.persist(user);
        } else {
            throw new NullParameterException();
        }
    }

    private List<User> getByUsername(User user) {
        Query query = entityManager.createQuery("from User as u where u.userName = :name ");
        query.setParameter("name", user.getUserName());
        List<User> results = query.getResultList();
        return results;
    }

    public boolean isInDatabase(User user) {
        boolean aux = true;
        List<User> results = getByUsername(user);
        if (results.size() == 0) {
            aux = false;
        } else {
            aux = true;
        }
        return aux;

    }

    @Override
    public void deleteUser(Long userId) throws UserNotFoundException {
        User userAux = getUserById(userId);
        if (userAux != null) {
            entityManager.remove(userAux);
            logger.info("a user was removed from the database");
        }
    }

    @Override
    public void updateUser(User user) throws UserNotFoundException, NullParameterException {
        if (user != null) {
            User userAux = getUserByUsername(user.getName());
            if (userAux != null) {
                entityManager.merge(user);
                logger.info("A user was updated in the database");
            }
        } else {
            throw new NullParameterException();
        }
    }

    @Override
    public User getUserById(Long userId) throws UserNotFoundException {
        User userAux = entityManager.find(User.class, userId);
        if (userAux != null) {
            return userAux;
        } else {
            throw new UserNotFoundException();
        }
    }

    @Override
    public User getUserByUsername(String username) throws UserNotFoundException {
        Query query = entityManager.createQuery("from User as u where u.userName = :name ");
        query.setParameter("name", username);
        List<User> results = query.getResultList();
        if (results.size() != 1) {
            throw new UserNotFoundException();
        }
        return results.get(0);
    }

    @Override
    public List<User> getAllUsers() {
        Query query = entityManager.createQuery("from User u where u.enabled = :enabled ");
        query.setParameter("enabled", true);
        List<User> allUsers = query.getResultList();
        return allUsers;
    }

    @Override
    public List<User> getAllUsersByInstitution(String institutionName) {

        Query query = entityManager.createQuery("select u from User as u INNER JOIN u.institution as i WHERE i.name =:name");
        query.setParameter("name", institutionName);
        List<User> results = query.getResultList();
        return results;
    }


}
