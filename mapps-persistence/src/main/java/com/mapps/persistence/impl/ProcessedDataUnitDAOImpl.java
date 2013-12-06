package com.mapps.persistence.impl;

import com.mapps.exceptions.NullParameterException;
import com.mapps.exceptions.ProcessedDataUnitNotFoundException;
import com.mapps.model.ProcessedDataUnit;
import com.mapps.persistence.ProcessedDataUnitDAO;
import org.apache.log4j.Logger;

import javax.ejb.Stateless;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;

/**
 *
 */
@Stateless(name="ProcessedDataUnitDAO")
public class ProcessedDataUnitDAOImpl implements ProcessedDataUnitDAO {

    Logger logger= Logger.getLogger(ProcessedDataUnitDAOImpl.class);
    @PersistenceContext(unitName = "mapps-persistence")
    EntityManager entityManager;

    @Override
    public void addProcessedDataUnit(ProcessedDataUnit processedDataUnit) throws NullParameterException {
        if(processedDataUnit!=null){
        logger.info("a ProcessedDataUnit was added to the database");
        entityManager.persist(processedDataUnit);
        }else{
            throw new NullParameterException();
        }
    }

    @Override
    public void deleteProcessedDataUnit(Long processedDataUnitId) throws ProcessedDataUnitNotFoundException {
        ProcessedDataUnit processedDataUnitAux=getProcessedDataUnitById(processedDataUnitId);
        if(processedDataUnitAux!=null){
            entityManager.remove(processedDataUnitAux);
            logger.info("a processedDataUnit was removed from the database");
        }
    }

    @Override
    public void updateProcessedDataUnit(ProcessedDataUnit processedDataUnit) throws ProcessedDataUnitNotFoundException, NullParameterException {
        if(processedDataUnit!=null){
        ProcessedDataUnit processedDataUnitAux=getProcessedDataUnitById(processedDataUnit.getId());
        if(processedDataUnitAux!=null){
            entityManager.merge(processedDataUnit);
            logger.info("A ProcessedDataUnit was updated in the database");
        }
        }else{
            throw new NullParameterException();
        }
    }

    @Override
    public ProcessedDataUnit getProcessedDataUnitById(Long processedDataUnitId) throws ProcessedDataUnitNotFoundException {
        ProcessedDataUnit processedDataUnitAux=entityManager.find(ProcessedDataUnit.class,processedDataUnitId);
        if(processedDataUnitAux!=null){
            return processedDataUnitAux;
        }else{
            throw new ProcessedDataUnitNotFoundException();
        }
    }
}
