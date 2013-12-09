package com.mapps.persistence;

import com.mapps.exceptions.GPSDataNotFoundException;
import com.mapps.exceptions.NullParameterException;
import com.mapps.model.GPSData;

import javax.ejb.Local;

/**
 * .
 */
@Local
public interface GPSDataDAO {
    /**
     * This method adds a GPSData to the database.
     * @param gPSData - The GPSData to add to the database
     */
    void addGPSData(GPSData gPSData) throws NullParameterException;

    /**
     * This method deletes a GPSData from the database.
     * @param gPSDataId - The GPSData identification id to find the GPSData to delete
     * @throws GPSDataNotFoundException - If the GPSData is not in the database
     */
    void deleteGPSData(Long gPSDataId) throws GPSDataNotFoundException;

    /**
     * This method updates a GPSData in the database.
     * @param gPSData - The GPSData identification id to find the GPSData to update
     * @throws GPSDataNotFoundException  - If the GPSData is not in the database
     */
    void updateGPSData(GPSData gPSData) throws GPSDataNotFoundException, NullParameterException;

    /**
     * This method gets a GPSData from the database
     * @param gPSDataId - the GPSData identification id to find the GPSData in the database
     * @return - The GPSData in the database
     * @throws GPSDataNotFoundException - If the GPSData is not in the database
     */
    GPSData getGPSDataById (Long gPSDataId) throws GPSDataNotFoundException;
}
