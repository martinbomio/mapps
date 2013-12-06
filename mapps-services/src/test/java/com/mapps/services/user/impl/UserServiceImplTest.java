package com.mapps.services.user.impl;

import junit.framework.Assert;

import org.junit.Before;
import org.junit.Test;

import com.mapps.authentificationhandler.AuthenticationHandler;
import com.mapps.authentificationhandler.exceptions.InvalidTokenException;
import com.mapps.authentificationhandler.exceptions.InvalidUserException;
import com.mapps.exceptions.NullParameterException;
import com.mapps.exceptions.UserNotFoundException;
import com.mapps.model.Role;
import com.mapps.model.User;
import com.mapps.persistence.UserDAO;
import com.mapps.services.user.exceptions.AuthenticationException;
import com.mapps.services.user.stub.UserServiceStub;

import static org.mockito.Matchers.any;
import static org.mockito.Mockito.doReturn;
import static org.mockito.Mockito.doThrow;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

/**
 *
 *
 */
public class UserServiceImplTest {
    UserServiceStub userService;
    UserDAO userDAO;
    AuthenticationHandler auth;

    @Before
    public void setUp() throws Exception {
        userDAO = mock(UserDAO.class);
        userService = new UserServiceStub();
        auth = mock(AuthenticationHandler.class);
        userService.setAuthenticationHandler(auth);
        userService.setUserDao(userDAO);
        when(auth.getUserOfToken("invalidToken")).thenThrow(new InvalidTokenException());
    }

    @Test
    public void testLogin(){
        User user = mock(User.class);
        when(user.getUserName()).thenReturn("pepe");
        when(user.getPassword()).thenReturn("pepe");
        try {
            doReturn("validToken").when(auth).authenticate(any(User.class));
            String token = userService.login("pepe", "pepe");
            Assert.assertEquals(token, "validToken");
        } catch (AuthenticationException e) {
            Assert.fail();
        } catch (InvalidUserException e) {
            Assert.fail();
        }
    }
    @Test
    public void testInvalidLogin(){
        User user = mock(User.class);
        when(user.getUserName()).thenReturn("pepe");
        when(user.getPassword()).thenReturn("pepe");
        try {
            doThrow(new InvalidUserException()).when(auth).authenticate(any(User.class));
            String token = userService.login("pepe", "pepe");
            Assert.fail();
        } catch (AuthenticationException e) {
            Assert.assertTrue(true);
        } catch (InvalidUserException e) {
            Assert.fail();
        }
    }

    @Test
    public void testLoginInvalidParameters(){
        try {
            String token = userService.login(null, "pepe");
            Assert.fail();
        } catch (AuthenticationException e) {
            Assert.assertTrue(true);
        }
        try {
            String token = userService.login("pepe", null);
            Assert.fail();
        } catch (AuthenticationException e) {
            Assert.assertTrue(true);
        }
    }

    @Test
    public void testLogout() {
        String logout = userService.logout("token");
        Assert.assertEquals(logout,"");
    }

    @Test
    public void testUpdateUser(){
        User newuser = mock(User.class);
        when(newuser.getUserName()).thenReturn("pepe");
        User user = mock(User.class);
        when(user.getUserName()).thenReturn("admin");
        when(user.getRole()).thenReturn(Role.ADMINISTRATOR);
        try {
            when(auth.getUserOfToken("validToken")).thenReturn(user);
            userService.updateUser(newuser, "validToken");
            verify(userDAO).updateUser(newuser);
        } catch (com.mapps.services.user.exceptions.InvalidUserException e) {
            Assert.fail();
        } catch (AuthenticationException e) {
            Assert.fail();
        } catch (UserNotFoundException e) {
            Assert.fail();
        } catch (InvalidTokenException e) {
            Assert.fail();
        } catch (NullParameterException e) {
            Assert.fail();
        }
    }

    @Test
    public void testUpdateUserSameUser(){
        User user = mock(User.class);
        when(user.getUserName()).thenReturn("pepe");
        when(user.getRole()).thenReturn(Role.USER);
        try {
            when(auth.getUserOfToken("validToken")).thenReturn(user);
            userService.updateUser(user, "validToken");
            Assert.fail();
        } catch (com.mapps.services.user.exceptions.InvalidUserException e) {
            Assert.assertTrue(true);
        } catch (AuthenticationException e) {
            Assert.fail();
        } catch (InvalidTokenException e) {
            Assert.fail();
        }
    }

    @Test
    public void testUpdateUserTrainer(){
        User user = mock(User.class);
        when(user.getUserName()).thenReturn("pepe");
        when(user.getRole()).thenReturn(Role.TRAINER);
        try {
            when(auth.getUserOfToken("validToken")).thenReturn(user);
            userService.updateUser(user, "validToken");
            Assert.fail();
        } catch (com.mapps.services.user.exceptions.InvalidUserException e) {
            Assert.fail();
        } catch (AuthenticationException e) {
            Assert.assertTrue(true);
        } catch (InvalidTokenException e) {
            Assert.fail();
        }
    }

    @Test
    public void testUpdateUserWithoutPermissions(){
        User user = mock(User.class);
        when(user.getUserName()).thenReturn("pepe");
        try {
            userService.updateUser(user, "invalidToken");
            Assert.fail();
        } catch (com.mapps.services.user.exceptions.InvalidUserException e) {
            Assert.fail();
        } catch (AuthenticationException e) {
            Assert.assertTrue(true);
        }
    }
}
