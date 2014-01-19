package com.mapps.services.user;


import javax.ejb.Local;

import com.mapps.model.Role;
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

    public boolean isAdministrator(String username) throws InvalidUserException;

    public Role userRoleOfToken(String token) throws InvalidUserException, AuthenticationException;

    public String getUserOfToken(String token) throws AuthenticationException;

    public String getInstitutionOfUser(String username) throws InvalidUserException;
}
