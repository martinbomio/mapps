package com.mapps.persistence.impl;

import com.mapps.exceptions.IMUDataNotFoundException;
import com.mapps.exceptions.NullParameterException;
import com.mapps.model.IMUData;
import com.mapps.persistence.IMUDataDAO;
import org.apache.log4j.Logger;

import javax.ejb.Stateless;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;

/**
 *
 */
@Stateless(name="IMUDataDAO")
public class IMUDataDAOImpl implements IMUDataDAO {

    Logger logger= Logger.getLogger(IMUDataDAOImpl.class);
    @PersistenceContext(unitName = "mapps-persistence")
    EntityManager entityManager;

    @Override
    public void addIMUData(IMUData iMUData) throws NullParameterException {
        if(iMUData!=null) {
        logger.info("a IMUData was added to the database");
        entityManager.persist(iMUData);
        }else{
           throw new NullParameterException();
        }
    }

    @Override
    public void deleteIMUData(Long iMUDataId) throws IMUDataNotFoundException {
        IMUData iMUDataAux=getIMUDataById(iMUDataId);
        if(iMUDataAux!=null){
            entityManager.remove(iMUDataAux);
            logger.info("a IMUData was removed from the database");
        }
    }

    @Override
    public void updateIMUData(IMUData iMUData) throws IMUDataNotFoundException, NullParameterException {
        if(iMUData!=null) {
        IMUData iMUDataAux=getIMUDataById(iMUData.getId());
        if(iMUDataAux!=null){
            entityManager.merge(iMUData);
            logger.info("A IMUData was updated in the database");
        }
        }else{
            throw new NullParameterException();
        }
    }

    @Override
    public IMUData getIMUDataById(Long iMUDataId) throws IMUDataNotFoundException {
        IMUData iMUDataAux=entityManager.find(IMUData.class,iMUDataId);
        if(iMUDataAux!=null){
            return iMUDataAux;
        }else{
            throw new IMUDataNotFoundException();
        }
    }
}
