package com.mapps.services.admin.impl;

import junit.framework.Assert;

import org.junit.Before;
import org.junit.Test;
import org.mockito.Mockito;

import com.mapps.authentificationhandler.AuthenticationHandler;
import com.mapps.authentificationhandler.exceptions.InvalidTokenException;
import com.mapps.exceptions.DeviceAlreadyExistException;
import com.mapps.exceptions.DeviceNotFoundException;
import com.mapps.exceptions.NullParameterException;
import com.mapps.exceptions.UserNotFoundException;
import com.mapps.model.Device;
import com.mapps.model.Role;
import com.mapps.model.User;
import com.mapps.persistence.DeviceDAO;
import com.mapps.persistence.TrainingDAO;
import com.mapps.persistence.UserDAO;
import com.mapps.services.admin.exceptions.AuthenticationException;
import com.mapps.services.admin.exceptions.DeviceAlreadyExistsException;
import com.mapps.services.admin.exceptions.InvalidDeviceException;
import com.mapps.services.admin.exceptions.InvalidDeviceRuntimeException;
import com.mapps.services.admin.exceptions.InvalidUserException;
import com.mapps.services.admin.exceptions.InvalidUserRuntimeException;
import com.mapps.services.admin.exceptions.UserAlreadyExistsException;
import com.mapps.services.admin.stub.AdminServiceStub;

import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

/**
 *
 *
 */
public class AdminServiceImplTest {
    AdminServiceStub adminService;
    UserDAO uDao;
    TrainingDAO tDao;
    DeviceDAO dDao;
    @Before
    public void setUp() throws Exception {
        adminService = new AdminServiceStub();
        uDao = mock(UserDAO.class);
        dDao = mock(DeviceDAO.class);
        tDao = mock(TrainingDAO.class);

        AuthenticationHandler auth = mock(AuthenticationHandler.class);
        when(auth.isUserInRole("validToken", Role.ADMINISTRATOR)).thenReturn(true);
        when(auth.isUserInRole("invalidToken", Role.ADMINISTRATOR)).thenReturn(false);
        when(auth.isUserInRole("",Role.ADMINISTRATOR)).thenThrow(new InvalidTokenException());

        adminService.setAuthenticationHandler(auth);
        adminService.setUserDAO(uDao);
        adminService.setDeviceDAO(dDao);
        adminService.setTrainingDAO(tDao);
    }

    @Test
    public void testCreateUser(){
        User validUser = mock(User.class);
        when(validUser.getUserName()).thenReturn("pepe");
        when(validUser.getPassword()).thenReturn("pepe");
        try {
            adminService.createUser(validUser, "validToken");
            Assert.assertTrue(true);
        } catch (AuthenticationException e) {
            Assert.fail();
        } catch (InvalidUserException e) {
            Assert.fail();
        } catch (UserAlreadyExistsException e) {
            Assert.fail();
        }
    }

    @Test
    public void testCreateUserWithoutPermissions(){
        User validUser = mock(User.class);
        when(validUser.getUserName()).thenReturn("pepe");
        when(validUser.getPassword()).thenReturn("pepe");
        try {
            adminService.createUser(validUser, "invalidToken");
            Assert.fail();
        } catch (AuthenticationException e) {
            Assert.assertTrue(true);
        } catch (InvalidUserException e) {
            Assert.fail();
        } catch (UserAlreadyExistsException e) {
            Assert.fail();
        }
    }

    @Test
    public void testCreateInvalidUser(){
        User validUser = mock(User.class);
        when(validUser.getUserName()).thenReturn("pepe");
        try {
            adminService.createUser(validUser, "validToken");
            Assert.fail();
        } catch (AuthenticationException e) {
            Assert.fail();
        } catch (InvalidUserException e) {
            Assert.assertTrue(true);
        } catch (UserAlreadyExistsException e) {
            Assert.fail();
        }
    }

    @Test
    public void testCreateNullUser(){
        try {
            adminService.createUser(null, "validToken");
            Assert.fail();
        } catch (AuthenticationException e) {
            Assert.fail();
        } catch (InvalidUserException e) {
            Assert.assertTrue(true);
        } catch (UserAlreadyExistsException e) {
            Assert.fail();
        }
    }

    @Test
    public void testDeleteUser(){
        User deleteUser = mock(User.class);
        when(deleteUser.getUserName()).thenReturn("delete");
        try {
            when(uDao.getUserByUsername("delete")).thenReturn(deleteUser);
            adminService.deleteUser(deleteUser,"validToken");
            verify(uDao).updateUser(deleteUser);
        } catch (AuthenticationException e) {
            Assert.fail();
        } catch (UserNotFoundException e) {
            Assert.fail();
        } catch (NullParameterException e) {
            Assert.fail();
        }

    }

    @Test
    public void testDeleteUserWithoutPermissions(){
        User deleteUser = mock(User.class);
        when(deleteUser.getUserName()).thenReturn("delete");
        try {
            when(uDao.getUserByUsername("delete")).thenReturn(deleteUser);
            adminService.deleteUser(deleteUser,"invalidToken");
            Assert.fail();
        } catch (AuthenticationException e) {
            Assert.assertTrue(true);
        } catch (UserNotFoundException e) {
            Assert.fail();
        }
    }

    @Test(expected = InvalidUserRuntimeException.class)
    public void testDeleteInvalidUser(){
        User deleteUser = mock(User.class);
        when(deleteUser.getUserName()).thenReturn("delete");
        try {
            when(uDao.getUserByUsername("delete")).thenThrow(new UserNotFoundException());
            adminService.deleteUser(deleteUser,"validToken");
            Assert.fail();
        } catch (AuthenticationException e) {
            Assert.fail();
        } catch (UserNotFoundException e) {
            Assert.fail();
        }
    }

    @Test
    public void testDeleteUserInvalidToken(){
        User deleteUser = mock(User.class);
        when(deleteUser.getUserName()).thenReturn("delete");
        try {
            when(uDao.getUserByUsername("delete")).thenThrow(new UserNotFoundException());
            adminService.deleteUser(deleteUser,"");
            Assert.fail();
        } catch (AuthenticationException e) {
            Assert.assertTrue(true);
        } catch (UserNotFoundException e) {
            Assert.fail();
        }
    }

    public void testChangePermissions() throws Exception {

    }

    @Test
    public void testChangeRole(){
        User user = mock(User.class);
        when(user.getUserName()).thenReturn("newRole");
        try {
            when(uDao.getUserByUsername("newRole")).thenReturn(user);
            adminService.changeRole(user, Role.TRAINER, "validToken");
            verify(uDao).updateUser(user);
        } catch (AuthenticationException e) {
            Assert.fail();
        } catch (UserNotFoundException e) {
            Assert.fail();
        } catch (NullParameterException e) {
            Assert.fail();
        }
    }

    @Test
    public void testChangeRoleWithoutPermissions(){
        User user = mock(User.class);
        when(user.getUserName()).thenReturn("newRole");
        try {
            when(uDao.getUserByUsername("newRole")).thenReturn(user);
            adminService.changeRole(user, Role.TRAINER, "invalidToken");
            Assert.fail();
        } catch (AuthenticationException e) {
            Assert.assertTrue(true);
        } catch (UserNotFoundException e) {
            Assert.fail();
        }
    }

    @Test
    public void testChangeRoleInvalidToken(){
        User user = mock(User.class);
        when(user.getUserName()).thenReturn("newRole");
        try {
            when(uDao.getUserByUsername("newRole")).thenReturn(user);
            adminService.changeRole(user, Role.TRAINER, "");
            Assert.fail();
        } catch (AuthenticationException e) {
            Assert.assertTrue(true);
        } catch (UserNotFoundException e) {
            Assert.fail();
        }
    }

    @Test(expected = InvalidUserRuntimeException.class)
    public void testChangeRoleInvalidUser(){
        User user = mock(User.class);
        when(user.getUserName()).thenReturn("newRole");
        try {
            when(uDao.getUserByUsername("newRole")).thenThrow(new UserNotFoundException());
            adminService.changeRole(user, Role.TRAINER, "validToken");
            Assert.fail();
        } catch (AuthenticationException e) {
            Assert.fail();
        } catch (UserNotFoundException e) {
            Assert.fail();
        }
    }

    @Test
    public void testAddDevice(){
        Device device = mock(Device.class);
        try {
            adminService.addDevice(device, "validToken");
            verify(dDao).addDevice(device);
        } catch (InvalidDeviceException e) {
            Assert.fail();
        } catch (AuthenticationException e) {
            Assert.fail();
        } catch (DeviceAlreadyExistException e) {
            Assert.fail();
        } catch (DeviceAlreadyExistsException e) {
            Assert.fail();
        } catch (NullParameterException e) {
            Assert.fail();
        }
    }

    @Test
    public void testAddInvalidDevice(){
        try {
            adminService.addDevice(null, "validToken");
            Assert.fail();
        } catch (InvalidDeviceException e) {
            Assert.assertTrue(true);
        } catch (AuthenticationException e) {
            Assert.fail();
        } catch (DeviceAlreadyExistsException e) {
            Assert.fail();
        }
    }

    @Test
    public void testAddDeviceAlreadyExists(){
        Device device = mock(Device.class);
        try {
            Mockito.doThrow(new DeviceAlreadyExistException()).when(dDao).addDevice(device);
            adminService.addDevice(device, "validToken");
            Assert.fail();
        } catch (InvalidDeviceException e) {
            Assert.assertTrue(true);
        } catch (AuthenticationException e) {
            Assert.fail();
        } catch (DeviceAlreadyExistsException e) {
            Assert.assertTrue(true);
        } catch (DeviceAlreadyExistException e) {
            Assert.fail();
        } catch (NullParameterException e) {
            Assert.fail();
        }
    }

    @Test
    public void testAddDeviceWithoutPermissions(){
        Device device = mock(Device.class);
        try {
            adminService.addDevice(device, "invalidToken");
            Assert.fail();
        } catch (InvalidDeviceException e) {
            Assert.fail();
        } catch (AuthenticationException e) {
            Assert.assertTrue(true);
        } catch (DeviceAlreadyExistsException e) {
            Assert.fail();
        }
    }

    @Test
    public void testAddDeviceInvalidToken(){
        Device device = mock(Device.class);
        try {
            adminService.addDevice(device, "" );
            Assert.fail();
        } catch (InvalidDeviceException e) {
            Assert.fail();
        } catch (AuthenticationException e) {
            Assert.assertTrue(true);
        } catch (DeviceAlreadyExistsException e) {
            Assert.fail();
        }
    }

    @Test
    public void testDisableDevice(){
        Device device = mock(Device.class);
        when(device.getDirLow()).thenReturn("123L");
        try {
            when(dDao.getDeviceByDir("123L")).thenReturn(device);
            adminService.disableDevice(device, "validToken");
            verify(dDao).updateDevice(device);
        } catch (AuthenticationException e) {
            Assert.fail();
        } catch (DeviceNotFoundException e) {
            Assert.fail();
        } catch (NullParameterException e) {
            Assert.fail();
        }
    }

    @Test
    public void testDisableDeviceWithoutPermissions(){
        Device device = mock(Device.class);
        when(device.getDirLow()).thenReturn("123L");
        try {
            when(dDao.getDeviceByDir("123L")).thenReturn(device);
            adminService.disableDevice(device,"invalidToken");
            Assert.fail();
        } catch (AuthenticationException e) {
            Assert.assertTrue(true);
        } catch (DeviceNotFoundException e) {
            Assert.fail();
        }
    }

    @Test
    public void testDisableDeviceInvalidToken(){
        Device device = mock(Device.class);
        when(device.getDirLow()).thenReturn("123L");
        try {
            when(dDao.getDeviceByDir("123L")).thenReturn(device);
            adminService.disableDevice(device,"");
            Assert.fail();
        } catch (AuthenticationException e) {
            Assert.assertTrue(true);
        } catch (DeviceNotFoundException e) {
            Assert.fail();
        }
    }

    @Test(expected = InvalidDeviceRuntimeException.class)
    public void testDisableInvalidDevice(){
        Device device = mock(Device.class);
        when(device.getDirLow()).thenReturn("123L");
        try {
            when(dDao.getDeviceByDir("123L")).thenThrow(new DeviceNotFoundException());
            adminService.disableDevice(device,"validToken");
            Assert.fail();
        } catch (AuthenticationException e) {
            Assert.fail();
        } catch (DeviceNotFoundException e) {
            Assert.fail();
        }
    }
}
