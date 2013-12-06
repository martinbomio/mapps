package com.mapps.persistence;

import com.mapps.exceptions.NullParameterException;
import com.mapps.exceptions.ProcessedDataUnitNotFoundException;
import com.mapps.model.ProcessedDataUnit;

import javax.ejb.Local;

/**
 * ProcessedDataUnitDAO interface
 */
@Local
public interface ProcessedDataUnitDAO {

    /**
     * This method adds a ProcessedDataUnit to the database.
     * @param processedDataUnit - The ProcessedDataUnit to add to the database
     */
    void addProcessedDataUnit(ProcessedDataUnit processedDataUnit) throws NullParameterException;

    /**
     * This method deletes a ProcessedDataUnit from the database.
     * @param processedDataUnitId - The ProcessedDataUnit identification id to find the ProcessedDataUnit to delete
     * @throws ProcessedDataUnitNotFoundException - If the ProcessedDataUnit is not in the database
     */
    void deleteProcessedDataUnit(Long processedDataUnitId) throws ProcessedDataUnitNotFoundException;

    /**
     * This method updates a ProcessedDataUnit in the database.
     * @param processedDataUnit - The ProcessedDataUnit identification id to find the ProcessedDataUnit to update
     * @throws ProcessedDataUnitNotFoundException  - If the ProcessedDataUnit is not in the database
     */
    void updateProcessedDataUnit(ProcessedDataUnit processedDataUnit) throws ProcessedDataUnitNotFoundException, NullParameterException;

    /**
     * This method gets a ProcessedDataUnit from the database
     * @param processedDataUnitId - the ProcessedDataUnit identification id to find the ProcessedDataUnit in the database
     * @return - The ProcessedDataUnit in the database
     * @throws ProcessedDataUnitNotFoundException - If the ProcessedDataUnit is not in the database
     */
    ProcessedDataUnit getProcessedDataUnitById (Long processedDataUnitId) throws ProcessedDataUnitNotFoundException;
}
