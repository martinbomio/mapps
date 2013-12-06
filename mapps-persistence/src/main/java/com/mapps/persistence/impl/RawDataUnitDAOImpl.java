package com.mapps.persistence.impl;

import com.mapps.exceptions.NullParameterException;
import com.mapps.exceptions.RawDataUnitNotFoundException;
import com.mapps.model.RawDataUnit;
import com.mapps.persistence.RawDataUnitDAO;
import org.apache.log4j.Logger;

import javax.ejb.Stateless;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;

/**
 * .
 */
@Stateless(name="RawDataUnitDAO")
public class RawDataUnitDAOImpl implements RawDataUnitDAO {

    Logger logger= Logger.getLogger(RawDataUnitDAOImpl.class);
    @PersistenceContext(unitName = "mapps-persistence")
    EntityManager entityManager;

    @Override
    public void addRawDataUnit(RawDataUnit rawDataUnit) throws NullParameterException {
        if(rawDataUnit!=null){
        logger.info("a RawDataUnit was added to the database");
        entityManager.persist(rawDataUnit);
        }else{
            throw new NullParameterException();
        }
    }

    @Override
    public void deleteRawDataUnit(Long rawDataUnitId) throws RawDataUnitNotFoundException {

        RawDataUnit rawDataUnitAux=getRawDataUnitById(rawDataUnitId);
        if(rawDataUnitAux!=null){
            entityManager.remove(rawDataUnitAux);
            logger.info("a rawDataUnit was removed from the database");
        }
    }

    @Override
    public void updateRawDataUnit(RawDataUnit rawDataUnit) throws RawDataUnitNotFoundException, NullParameterException {
        if(rawDataUnit!=null){
        RawDataUnit rawDataUnitAux=getRawDataUnitById(rawDataUnit.getId());
        if(rawDataUnitAux!=null){
            entityManager.merge(rawDataUnit);
            logger.info("A rawDataUnit was updated in the database");
        }
        }else{
            throw new NullParameterException();
        }
    }

    @Override
    public RawDataUnit getRawDataUnitById(Long rawDataUnitId) throws RawDataUnitNotFoundException {
        RawDataUnit rawDataUnitAux=entityManager.find(RawDataUnit.class,rawDataUnitId);
        if(rawDataUnitAux!=null){
            return rawDataUnitAux;
        }else{
            throw new RawDataUnitNotFoundException();
        }
    }
}
