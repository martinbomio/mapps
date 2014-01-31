package com.mapps.services.user.impl;

import java.util.List;
import javax.ejb.EJB;
import javax.ejb.Stateless;

import org.apache.log4j.Logger;

import com.mapps.authentificationhandler.AuthenticationHandler;
import com.mapps.authentificationhandler.exceptions.InvalidTokenException;
import com.mapps.exceptions.NullParameterException;
import com.mapps.exceptions.UserNotFoundException;
import com.mapps.model.Role;
import com.mapps.model.Sport;
import com.mapps.model.User;
import com.mapps.persistence.SportDAO;
import com.mapps.persistence.UserDAO;
import com.mapps.services.user.UserService;
import com.mapps.services.user.exceptions.AuthenticationException;
import com.mapps.services.user.exceptions.InvalidUserException;

/**
 * An implementation of the UserService.
 */
@Stateless(name = "UserService")
public class UserServiceImpl implements UserService {
    Logger logger = Logger.getLogger(UserServiceImpl.class);
    @EJB(beanName = "AuthenticationHandler")
    protected AuthenticationHandler authenticationHandler;
    @EJB(beanName = "UserDAO")
    protected UserDAO userDAO;
    @EJB(beanName = "SportDAO")
    protected SportDAO sportDAO;

    @Override
    public String login(String username, String password) throws AuthenticationException {
        if (username == null || password == null) {
            logger.error("Username or password null");
            throw new AuthenticationException();
        }
        User user = new User(null, null, null, null, username, username, password, null, null, null);
        String token;
        try {
            token = authenticationHandler.authenticate(user);
        } catch (com.mapps.authentificationhandler.exceptions.InvalidUserException e) {
            logger.error("Username or password not valid");
            throw new AuthenticationException();
        }
        return token;
    }

    @Override
    public String logout(String token) {
        return "";
    }

    @Override
    public void updateUser(User user, String token) throws InvalidUserException, AuthenticationException {
        if (user == null) {
            logger.error("Not valid user to update");
            throw new InvalidUserException();
        }
        try {
            User actualUser = authenticationHandler.getUserOfToken(token);
            if (actualUser.getRole() == Role.USER) {
                if (actualUser.equals(user)) {
                    logger.error("The user that you want to update is the same");
                    throw new InvalidUserException();
                }
                if (!actualUser.getUserName().equals(user.getUserName())) {
                    logger.error("Cannot change username");
                    throw new InvalidUserException();
                }
                userDAO.updateUser(user);
            } else if (actualUser.getRole() == Role.ADMINISTRATOR ||actualUser.getRole() == Role.TRAINER) {
                userDAO.updateUser(user);
            } else {
                throw new AuthenticationException();
            }
        } catch (InvalidTokenException e) {
            logger.error("Invalid token");
            throw new AuthenticationException();
        } catch (UserNotFoundException e) {
            logger.error("User not found");
            throw new InvalidUserException();
        } catch (NullParameterException e) {
            logger.error("Not valid user to update");
            throw new InvalidUserException();
        }
    }

    @Override
    public boolean isAdministrator(String username) throws InvalidUserException {
        if (username == null) {
            logger.error("Not valid user to update");
            throw new InvalidUserException();
        }
        try {
            User aux = userDAO.getUserByUsername(username);
            return aux.getRole().equals(Role.ADMINISTRATOR);
        } catch (UserNotFoundException e) {
            logger.error("user not found");
            throw new InvalidUserException();
        }
    }


    @Override
    public User getUserOfToken(String token) throws AuthenticationException {
        try {
            return authenticationHandler.getUserOfToken(token);
        } catch (InvalidTokenException e) {
            throw new AuthenticationException();
        }
    }

    @Override
    public Role userRoleOfToken(String token) throws AuthenticationException {
        if (token == null) {
            logger.error("Invalid token");
            throw new AuthenticationException();
        }
        try {
            User aux = authenticationHandler.getUserOfToken(token);
            Role role = aux.getRole();
            return role;
        } catch (InvalidTokenException e) {
            logger.error("Invalid token");
            throw new AuthenticationException();
        }
    }

    @Override
    public List<Sport> getAllSports() {
        return sportDAO.getAllSports();
    }
}
