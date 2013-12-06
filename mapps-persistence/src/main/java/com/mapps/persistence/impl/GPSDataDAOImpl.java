package com.mapps.persistence.impl;

import com.mapps.exceptions.GPSDataNotFoundException;
import com.mapps.exceptions.NullParameterException;
import com.mapps.model.GPSData;
import com.mapps.persistence.GPSDataDAO;
import org.apache.log4j.Logger;

import javax.ejb.Stateless;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;

/**
 *
 */
@Stateless(name="GPSDataDAO")
public class GPSDataDAOImpl implements GPSDataDAO{

    Logger logger= Logger.getLogger(GPSDataDAOImpl.class);
    @PersistenceContext(unitName = "mapps-persistence")
    EntityManager entityManager;

    @Override
    public void addGPSData(GPSData gPSData) throws NullParameterException {
        if(gPSData!=null){
        logger.info("a GPSData was added to the database");
        entityManager.persist(gPSData);
        }else{
            throw new NullParameterException();
        }
    }

    @Override
    public void deleteGPSData(Long gPSDataId) throws GPSDataNotFoundException {
        GPSData gPSDataAux=getGPSDataById(gPSDataId);
        if(gPSDataAux!=null){
            entityManager.remove(gPSDataAux);
            logger.info("a GPSData was removed from the database");
        }
    }

    @Override
    public void updateGPSData(GPSData gPSData) throws GPSDataNotFoundException, NullParameterException {
        if(gPSData!=null){
        GPSData gPSDataAux=getGPSDataById(gPSData.getId());
        if(gPSDataAux!=null){
            entityManager.merge(gPSData);
            logger.info("A GPSData was updated in the database");
        }
        }else{
            throw new NullParameterException();
        }
    }

    @Override
    public GPSData getGPSDataById(Long gPSDataId) throws GPSDataNotFoundException {
        GPSData gPSDataAux=entityManager.find(GPSData.class,gPSDataId);
        if(gPSDataAux!=null){
            return gPSDataAux;
        }else{
            throw new GPSDataNotFoundException();
        }
    }

}
