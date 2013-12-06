package com.mapps.persistence;

import com.mapps.exceptions.IMUDataNotFoundException;
import com.mapps.exceptions.NullParameterException;
import com.mapps.model.IMUData;

import javax.ejb.Local;

/**
 * IMUDataDAO interface
 */
@Local
public interface IMUDataDAO {
    /**
     * This method adds a IMUData to the database.
     * @param iMUData - The IMUData to add to the database
     */
    void addIMUData(IMUData iMUData) throws NullParameterException;

    /**
     * This method deletes a IMUData from the database.
     * @param iMUDataId - The IMUData identification id to find the IMUData to delete
     * @throws IMUDataNotFoundException - If the IMUData is not in the database
     */
    void deleteIMUData(Long iMUDataId) throws IMUDataNotFoundException;

    /**
     * This method updates a IMUData in the database.
     * @param iMUData - The IMUData identification id to find the IMUData to update
     * @throws IMUDataNotFoundException  - If the IMUData is not in the database
     */
    void updateIMUData(IMUData iMUData) throws IMUDataNotFoundException, NullParameterException;

    /**
     * This method gets a IMUData from the database
     * @param iMUDataId - the IMUData identification id to find the IMUData in the database
     * @return - The IMUData in the database
     * @throws IMUDataNotFoundException - If the IMUData is not in the database
     */
    IMUData getIMUDataById (Long iMUDataId) throws IMUDataNotFoundException;
}
