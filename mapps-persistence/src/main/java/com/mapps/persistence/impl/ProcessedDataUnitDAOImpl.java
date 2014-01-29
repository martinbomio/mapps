package com.mapps.persistence.impl;

import java.util.List;
import javax.ejb.Stateless;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.Query;

import org.apache.log4j.Logger;

import com.mapps.exceptions.NullParameterException;
import com.mapps.exceptions.ProcessedDataUnitNotFoundException;
import com.mapps.model.Athlete;
import com.mapps.model.Device;
import com.mapps.model.ProcessedDataUnit;
import com.mapps.model.Training;
import com.mapps.persistence.ProcessedDataUnitDAO;

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

    @Override
    public ProcessedDataUnit getLastProcessedDataUnit(Training training, Device device) throws NullParameterException {
        if (training == null || device == null){
            throw new NullParameterException();
        }
        String hql = "select p from ProcessedDataUnit p join p.rawDataUnit r where " +
                "(r.device =:device and r.training =:training) order by p.id desc";
        Query query = entityManager.createQuery(hql);
        query.setParameter("device", device);
        query.setParameter("training", training);
        List<ProcessedDataUnit> list = query.getResultList();
        if (list.size() == 0)
            return null;
        else
            return list.get(0);
    }

    @Override
    public List<ProcessedDataUnit> getProcessedDataUnitsFromAthleteInTraining(Training training, Athlete athlete) throws NullParameterException {
        if (training == null || athlete == null)
            throw new NullParameterException();
        String hql = "select p from ProcessedDataUnit p join p.rawDataUnit r join r.training t join t.mapAthleteDevice m" +
                " where (t = :training and index(m)=:athlete) order by p.elapsedTime asc";
        Query query = entityManager.createQuery(hql);
        query.setParameter("training", training);
        query.setParameter("athlete", athlete);
        List<ProcessedDataUnit> list = query.getResultList();
        return list;
    }
}
