package com.mapps.persistence;

import javax.ejb.Local;

import com.mapps.exceptions.NullParameterException;
import com.mapps.exceptions.PulseDataNotFoundException;
import com.mapps.model.PulseData;

/**
 * PulseDataDAO interface
 */
@Local
public interface PulseDataDAO {
    /**
     * This method adds a PulseData to the database.
     * @param pulseData - The PulseData to add to the database
     */
    void addPulseData(PulseData pulseData) throws NullParameterException;

    /**
     * This method deletes a PulseData from the database.
     * @param pulseDataId - The PulseData identification id to find the PulseData to delete
     * @throws PulseDataNotFoundException - If the PulseData is not in the database
     */
    void deletePulseData(Long pulseDataId) throws PulseDataNotFoundException;

    /**
     * This method updates a PulseData in the database.
     * @param pulseData - The PulseData identification id to find the PulseData to update
     * @throws PulseDataNotFoundException  - If the PulseData is not in the database
     */
    void updatePulseData(PulseData pulseData) throws PulseDataNotFoundException, NullParameterException;

    /**
     * This method gets a PulseData from the database
     * @param pulseDataId - the PulseData identification id to find the PulseData in the database
     * @return - The PulseData in the database
     * @throws PulseDataNotFoundException - If the PulseData is not in the database
     */
    PulseData getPulseDataById (Long pulseDataId) throws PulseDataNotFoundException;
}
