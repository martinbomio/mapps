package com.mapps.persistence.impl;

import java.util.List;
import javax.ejb.Stateless;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.Query;

import org.apache.log4j.Logger;

import com.mapps.exceptions.NullParameterException;
import com.mapps.exceptions.RawDataUnitNotFoundException;
import com.mapps.model.Device;
import com.mapps.model.RawDataUnit;
import com.mapps.model.Training;
import com.mapps.persistence.RawDataUnitDAO;
import com.mapps.utils.Constants;

/**
 * .
 */
@Stateless(name="RawDataUnitDAO")
public class RawDataUnitDAOImpl implements RawDataUnitDAO {

    Logger logger= Logger.getLogger(RawDataUnitDAOImpl.class);
    @PersistenceContext(unitName = "mapps-persistence")
    protected EntityManager entityManager;

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

    @Override
    public boolean initialConditionsSatisfied(Training training, Device device) {
        String sql = "select r from RawDataUnit r join r.device d join r.training t where ( d=:device and t=:training )" +
                " order by r.date asc";
        Query query = entityManager.createQuery(sql);
        query.setParameter("device", device);
        query.setParameter("training", training);
        int numb = query.getResultList().size();

        return (numb >= Constants.INITIAL_CONDITIONS_NUMBER);
    }

    @Override
    public List<RawDataUnit> getInitialConditions(Training training, Device device) {
        String sql = "select r from RawDataUnit r join fetch r.device d join fetch r.training t where ( d=:device and t=:training ) " +
                "order by r.date asc";
        Query query = entityManager.createQuery(sql);
        query.setParameter("device", device);
        query.setParameter("training", training);
        query.setMaxResults(Constants.INITIAL_CONDITIONS_NUMBER);
        List<RawDataUnit> rawDataUnits = query.getResultList();
        return  rawDataUnits;
    }

    @Override
    public List<RawDataUnit> getRawDataFromAthleteOnTraining(Training training, Device device) {
        String sql = "select r from RawDataUnit r join fetch r.device d join fetch r.training t where ( d=:device and t=:training ) " +
                "order by r.date asc";
        Query query = entityManager.createQuery(sql);
        query.setParameter("device", device);
        query.setParameter("training", training);
        List<RawDataUnit> rawDataUnits = query.getResultList();
        updateToReadedRawDataUnit(rawDataUnits.get(rawDataUnits.size() - 1).getId());
        return rawDataUnits;
    }

    private void updateToReadedRawDataUnit(long lastID) {
        String hql = "update RawDataUnit set read = :read where id <= :lastID";
        Query query = entityManager.createQuery(hql);
        query.setParameter("read", true);
        query.setParameter("lastID", lastID);
        query.executeUpdate();
        return;
    }


}
