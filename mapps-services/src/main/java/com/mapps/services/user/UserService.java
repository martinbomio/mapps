package com.mapps.services.user;


import java.util.List;
import javax.ejb.Local;

import com.mapps.model.Sport;
import com.mapps.model.User;
import com.mapps.services.user.exceptions.AuthenticationException;
import com.mapps.services.user.exceptions.InvalidUserException;

/**
 * Defines the services for handling user interactions with the system.
 */
@Local
public interface UserService {
    /**
     * Authentificates a user of the system to interact with the system
     *
     * @param username name of the user in the system.
     * @param password password of the user in the system.
     * @return token that represent the session.
     */
    String login(String username, String password) throws AuthenticationException;

    /**
     * Log out a user from the system, destroying its session.
     *
     * @param token identifier of the session.
     * @return the closed session identifier.
     */
    String logout(String token);

    /**
     * Updates the information of a user
     *
     * @param user  new user information
     * @param token indentifier of the ssesion
     * @throws com.mapps.services.user.exceptions.InvalidUserException
     *          if the user could not be updated.
     */
    void updateUser(User user, String token) throws InvalidUserException, AuthenticationException;

    /**
     * Checks if the user with the given username is administrator.
     * @param username the username of the user.
     * @return true if the user is an administrator, false otherwise.
     * @throws InvalidUserException if there is no user with the given username.
     */
    public boolean isAdministrator(String username) throws InvalidUserException;

    /**
     * Gets the user of the given token.
     *
     * @param token the identifier of the session.
     * @return the user of the token.
     * @throws AuthenticationException when the user doesn't have the necessary permission to perform this action.
     */
    public User getUserOfToken(String token) throws AuthenticationException;

    /**
     * @return a list containing all the sport of the system.
     */
    List<Sport> getAllSports();
}
