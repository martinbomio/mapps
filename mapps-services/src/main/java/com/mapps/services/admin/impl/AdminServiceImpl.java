package com.mapps.services.admin.impl;

import java.util.Map;
import javax.ejb.EJB;
import javax.ejb.Stateless;

import org.apache.log4j.Logger;

import com.mapps.authentificationhandler.AuthenticationHandler;
import com.mapps.authentificationhandler.exceptions.InvalidTokenException;
import com.mapps.exceptions.DeviceAlreadyExistException;
import com.mapps.exceptions.DeviceNotFoundException;
import com.mapps.exceptions.NullParameterException;
import com.mapps.exceptions.TrainingNotFoundException;
import com.mapps.exceptions.UserAlreadyExistException;
import com.mapps.exceptions.UserNotFoundException;
import com.mapps.model.Device;
import com.mapps.model.Permission;
import com.mapps.model.Role;
import com.mapps.model.Training;
import com.mapps.model.User;
import com.mapps.persistence.DeviceDAO;
import com.mapps.persistence.TrainingDAO;
import com.mapps.persistence.UserDAO;
import com.mapps.services.admin.AdminService;
import com.mapps.services.admin.exceptions.AuthenticationException;
import com.mapps.services.admin.exceptions.DeviceAlreadyExistsException;
import com.mapps.services.admin.exceptions.InvalidDeviceException;
import com.mapps.services.admin.exceptions.InvalidDeviceRuntimeException;
import com.mapps.services.admin.exceptions.InvalidTrainingRuntimeException;
import com.mapps.services.admin.exceptions.InvalidUserException;
import com.mapps.services.admin.exceptions.InvalidUserRuntimeException;
import com.mapps.services.admin.exceptions.UserAlreadyExistsException;

/**
 * Implementation of AdminService
 */
@Stateless(name = "AdminService")
public class AdminServiceImpl implements AdminService{

    Logger logger = Logger.getLogger(AdminServiceImpl.class);

    @EJB(beanName = "UserDAO")
    protected UserDAO userDAO;
    @EJB(beanName = "DeviceDAO")
    protected DeviceDAO deviceDAO;
    @EJB(beanName = "TrainingDAO")
    protected TrainingDAO trainingDAO;
    @EJB(beanName = "AuthenticationHandler")
    protected AuthenticationHandler authenticationHandler;

    @Override
    public void createUser(User newUser, String token) throws AuthenticationException, InvalidUserException, UserAlreadyExistsException {
        if (newUser == null || newUser.getUserName() == null || newUser.getPassword() == null){
            logger.error("Invalid User");
            throw new InvalidUserException();
        }
        try{
            if (!authenticationHandler.isUserInRole(token,Role.ADMINISTRATOR)){
                logger.error("User not an administrator");
                throw new AuthenticationException();
            }
            newUser.setRole(Role.USER);
            userDAO.addUser(newUser);
        } catch (InvalidTokenException e) {
            logger.error("Invalid Token");
            throw new AuthenticationException();
        } catch (UserAlreadyExistException e) {
            logger.error("User Already exists");
            throw new UserAlreadyExistsException();
        } catch (NullParameterException e) {
            logger.error("Invalid User");
            throw new InvalidUserException();
        }
    }

    @Override
    public User getUserByUsername(String name) throws InvalidUserException {
        User aux=null;
        if(name!=null){
            try {
                aux=userDAO.getUserByUsername(name);
            }
            catch (UserNotFoundException e) {
              throw new InvalidUserException();
            }
        }
        return aux;
    }


    @Override
    public void deleteUser(User user, String token) throws AuthenticationException{
        if (user == null || user.getUserName() == null){
            logger.error("Invalid User");
            throw new InvalidUserRuntimeException();
        }
        try{
            if (!authenticationHandler.isUserInRole(token,Role.ADMINISTRATOR)){
                logger.error("User not an administrator");
                throw new AuthenticationException();
            }
            User dbUser = userDAO.getUserByUsername(user.getUserName());
            dbUser.setEnabled(false);
            userDAO.updateUser(dbUser);
        } catch (InvalidTokenException e) {
            logger.error("Invalid Token");
            throw new AuthenticationException();
        } catch (UserNotFoundException e) {
            logger.error("Invalid User");
            throw new InvalidUserRuntimeException();
        } catch (NullParameterException e) {
            logger.error("Invalid User");
            throw new InvalidUserRuntimeException();
        }
    }

    @Override
    public void changePermissions(Training training, User user, Permission permission, String token) throws AuthenticationException {
        if( user == null || training == null || permission == null || user.getUserName() == null){
            logger.info("Some of the parameters are not valid");
            throw new IllegalArgumentException();
        }
        try{
            if (!authenticationHandler.isUserInRole(token,Role.ADMINISTRATOR)){
                logger.error("User not an administrator");
                throw new AuthenticationException();
            }
            Training dbTraining = trainingDAO.getTrainingByName(training.getName());
            User dbUser = userDAO.getUserByUsername(user.getUserName());
            Map<User,Permission> permissionsForUsers = dbTraining.getMapUserPermission();
            permissionsForUsers.put(dbUser,permission);
        } catch (InvalidTokenException e) {
            logger.error("Invalid token");
            throw new AuthenticationException();
        } catch (TrainingNotFoundException e) {
            logger.info("Invalid training");
            throw new InvalidTrainingRuntimeException();
        } catch (UserNotFoundException e) {
            logger.info("Invalid user");
            throw new InvalidUserRuntimeException();
        }
    }

    @Override
    public void changeRole(User user, Role role, String token) throws AuthenticationException {
        if (user == null || user.getUserName() == null){
            logger.error("Invalid User");
            throw new InvalidUserRuntimeException();
        }
        try{
            if (!authenticationHandler.isUserInRole(token,Role.ADMINISTRATOR)){
                logger.error("User not an administrator");
                throw new AuthenticationException();
            }
            User dbUser = userDAO.getUserByUsername(user.getUserName());
            dbUser.setRole(role);
            userDAO.updateUser(dbUser);
        } catch (UserNotFoundException e) {
            logger.error("Invalid User");
            throw new InvalidUserRuntimeException();
        } catch (InvalidTokenException e) {
            logger.error("Invalid token");
            throw  new AuthenticationException();
        } catch (NullParameterException e) {
            logger.error("Invalid User");
            throw new InvalidUserRuntimeException();
        }
    }

    @Override
    public void addDevice(Device device, String token) throws InvalidDeviceException, AuthenticationException,
                                                                DeviceAlreadyExistsException {
        if( device == null ){
            logger.error("Invalid device");
            throw new InvalidDeviceException();
        }
        try{
            if (!authenticationHandler.isUserInRole(token,Role.ADMINISTRATOR)){
                logger.error("User not an administrator");
                throw new AuthenticationException();
            }
            deviceDAO.addDevice(device);
        } catch (InvalidTokenException e) {
            logger.error("Invalid token");
            throw new AuthenticationException();
        } catch (DeviceAlreadyExistException e) {
            logger.error("Device already exists");
            throw new DeviceAlreadyExistsException();
        } catch (NullParameterException e) {
            logger.error("Invalid device");
            throw new InvalidDeviceException();
        }
    }

    @Override
    public void disableDevice(Device device, String token) throws AuthenticationException{
        if ( device == null){
            logger.info("Invalid device");
            throw new InvalidDeviceRuntimeException();
        }
        try{
            if (!authenticationHandler.isUserInRole(token,Role.ADMINISTRATOR)){
                logger.error("User not an administrator");
                throw new AuthenticationException();
            }
            Device dbDevice = deviceDAO.getDeviceByDir(device.getDirLow());
            dbDevice.setAvailable(false);
            deviceDAO.updateDevice(dbDevice);
        } catch (InvalidTokenException e) {
            logger.error("Invalid token");
            throw new AuthenticationException();
        } catch (DeviceNotFoundException e) {
            logger.error("Invalid device");
            throw new InvalidDeviceRuntimeException();
        } catch (NullParameterException e) {
            logger.info("Invalid device");
            throw new InvalidDeviceRuntimeException();
        }
    }
    @Override
    public void modifyDevice(Device device, String token) throws InvalidDeviceException, AuthenticationException {
        if (device == null || device.getDirLow() == null) {
            throw new InvalidDeviceException();
        }
        try {
            if (authenticationHandler.isUserInRole(token, Role.ADMINISTRATOR) ||
                    authenticationHandler.isUserInRole(token, Role.TRAINER)) {
                deviceDAO.updateDevice(device);
            } else {
                throw new AuthenticationException();
            }
        } catch (InvalidTokenException e) {
            throw new AuthenticationException();
        } catch (DeviceNotFoundException e) {
            throw new InvalidDeviceException();
        } catch (NullParameterException e) {
            throw new InvalidDeviceException();
        }
    }

}
