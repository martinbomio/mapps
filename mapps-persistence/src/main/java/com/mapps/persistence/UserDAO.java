package com.mapps.persistence;

import com.mapps.exceptions.NullParameterException;
import com.mapps.exceptions.UserAlreadyExistException;
import com.mapps.exceptions.UserNotFoundException;
import com.mapps.model.User;

import javax.ejb.Local;
import java.util.List;

/**
 * UserDAO interface
 */
@Local
public interface UserDAO {
    /**
     * This method adds a User to the database.
     * @param user - The User to add to the database
     */
    void addUser(User user) throws UserAlreadyExistException, NullParameterException;

    /**
     * This method deletes a User from the database.
     * @param userId - The User identification id to find the User to delete
     * @throws UserNotFoundException - If the User is not in the database
     */
    void deleteUser(Long userId) throws UserNotFoundException;

    /**
     * This method updates a User in the database.
     * @param user - The User identification id to find the User to update
     * @throws UserNotFoundException  - If the User is not in the database
     */
    void updateUser(User user) throws UserNotFoundException, NullParameterException;

    /**
     * This method gets a User from the database
     * @param userId - the User identification id to find the User in the database
     * @return - The User in the database
     * @throws UserNotFoundException - If the User is not in the database
     */
    User getUserById (Long userId) throws UserNotFoundException;

    /**
     * Method that searches a user by his name in the database
     * @param username name of the user
     * @return user with username
     * @throws UserNotFoundException If the user is not in the database
     */
    User getUserByUsername(String username) throws UserNotFoundException;

    /**
     * Method that gets all the users
     * @return all the users
     */
    List<User> getAllUsers();

    /**
     * Method that gets all the users by institution
     * @return all the users of one institution
     */
    public List<User> getAllUsersByInstitution(String institutionName);


}
