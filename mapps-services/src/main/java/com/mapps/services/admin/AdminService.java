package com.mapps.services.admin;

import java.util.List;
import javax.ejb.Local;

import com.mapps.model.Device;
import com.mapps.model.Permission;
import com.mapps.model.Role;
import com.mapps.model.Training;
import com.mapps.model.User;
import com.mapps.services.admin.exceptions.AuthenticationException;
import com.mapps.services.admin.exceptions.DeviceAlreadyExistsException;
import com.mapps.services.admin.exceptions.InvalidDeviceException;
import com.mapps.services.admin.exceptions.InvalidUserException;
import com.mapps.services.admin.exceptions.UserAlreadyExistsException;

/**
 * Defines the operation of the Administrator with the system.
 */
@Local
public interface AdminService {
    /**
     * Creates a user of the system. The user is created with USER privileges.
     *
     * @param newUser the user to add.
     * @param token   identifier of the session.
     * @throws AuthenticationException when the caller has not ADMIN permissions
     * @throws InvalidUserException    when the user to add is not valid.
     */
    void createUser(User newUser, String token) throws AuthenticationException, InvalidUserException, UserAlreadyExistsException;

    /**
     * Deletes a user from the system.
     *
     * @param user  the user that want to be deleted.
     * @param token identifier of the session.
     * @throws AuthenticationException when the caller has not ADMIN privileges.
     */
    void deleteUser(User user, String token) throws AuthenticationException;

    /**
     * Change the permissions of a user to a training. The permissions are: CREATE, READ.
     *
     * @param training   the training.
     * @param user       the user for whom the permissions will be changed.
     * @param permission the new permissions.
     * @param token      the identifier of the session
     * @throws AuthenticationException when the caller has not ADMIN privileges.
     */
    void changePermissions(Training training, User user, Permission permission, String token) throws AuthenticationException;

    /**
     * CHange the privileges of a user to the system. Roles are: ADMINISTRATOR, TRAINER, USER.
     *
     * @param user  the user for whom the role will be changed.
     * @param role  the new role.
     * @param token the identifier of the session.
     * @throws AuthenticationException when the caller has not ADMIN privileges.
     */
    void changeRole(User user, Role role, String token) throws AuthenticationException;

    /**
     * Add a new Device to the system.
     *
     * @param device the device to be added.
     * @param token  the identifier of the session.
     * @throws InvalidDeviceException       when the device to add is not a valid one.
     * @throws AuthenticationException      when the caller has not ADMIN privileges.
     * @throws DeviceAlreadyExistsException thrown when the device is already on the database.
     */
    void addDevice(Device device, String token) throws InvalidDeviceException, AuthenticationException,
            DeviceAlreadyExistsException;

    /**
     * Disable a device from the System. This happens when the device is broken.
     *
     * @param device the device to be disabled.
     * @param token  the identifier of the session.
     * @throws AuthenticationException when the caller has not ADMIN privileges.
     */
    void disableDevice(Device device, String token) throws AuthenticationException;

    /**
     * Gets a User from the database by its username.
     *
     * @param name the username.
     * @return The User with the username specified.
     * @throws InvalidUserException when there is no user with the username specified.
     */
    User getUserByUsername(String name) throws InvalidUserException;

    /**
     * Modifies a Device that already exists on the system.
     *
     * @param device the device to be changes.
     * @param token  the identifier of the session.
     * @throws InvalidDeviceException  when the device to modify isn' on the database.
     * @throws AuthenticationException when the caller has no privileges to perform this action.
     */
    void modifyDevice(Device device, String token) throws InvalidDeviceException, AuthenticationException;

    /**
     * @return all the devices of the system. Doesn't need a token because only the admin can call the service.
     */
    List<Device> getAllDevices();

    /**
     * @param token the identifier of the session.
     * @return all the users from the system.
     * @throws AuthenticationException
     */
    List<User> getAllUsers(String token) throws AuthenticationException;
}
