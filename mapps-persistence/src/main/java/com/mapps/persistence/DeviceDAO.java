package com.mapps.persistence;

import com.mapps.exceptions.DeviceAlreadyExistException;
import com.mapps.exceptions.DeviceNotFoundException;
import com.mapps.exceptions.NullParameterException;
import com.mapps.model.Device;

import javax.ejb.Local;
import java.util.List;

/**
 * SportDAO interface
 */
@Local
public interface DeviceDAO {

    /**
     * This method adds a Device to the database.
     * @param device - The Device to add to the database
     */
    void addDevice(Device device) throws DeviceAlreadyExistException, NullParameterException;



    /**
     * This method deletes a Device from the database.
     * @param deviceId - The Device identification id to find the Device to delete
     * @throws DeviceNotFoundException - If the Sport is not in the database
     */
    void deleteDevice(Long deviceId) throws DeviceNotFoundException;

    /**
     * This method updates a Device in the database.
     * @param device - The Device identification id to find the Device to update
     * @throws DeviceNotFoundException  - If the Device is not in the database
     */
    void updateDevice(Device device) throws DeviceNotFoundException, NullParameterException;

    /**
     * This method gets a Device from the database
     * @param deviceId - the Device identification id to find the Device in the database
     * @return - The Device in the database
     * @throws DeviceNotFoundException - If the Sport is not in the database
     */
    Device getDeviceById (Long deviceId) throws DeviceNotFoundException;
    /**
     * This method gets a Device from the database
     * @param dirLow - the Device identification id to find the Device in the database
     * @return - The Device in the database
     * @throws DeviceNotFoundException - If the Sport is not in the database
     */
    Device getDeviceByDir (String dirLow) throws DeviceNotFoundException;

    /**
     * Method that gets all the Devices of one institution
     * @param institutionName
     * @return all the Devices of one institution
     */
    List<Device> getAllDevicesByInstitution(String institutionName);
    public List<Device> getAllDevices();
}
