package com.mapps.services.user.stub;

import com.mapps.authentificationhandler.AuthenticationHandler;
import com.mapps.persistence.UserDAO;
import com.mapps.services.user.impl.UserServiceImpl;

/**
 * Stub for testing.
 */
public class UserServiceStub extends UserServiceImpl {

    public void setAuthenticationHandler(AuthenticationHandler auth){
        this.authenticationHandler = auth;
    }
    public void setUserDao(UserDAO userDao){
        this.userDAO = userDao;
    }
}
