package com.mapps.persistence.impl;

import java.util.List;
import javax.ejb.Stateless;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.Query;

import org.apache.log4j.Logger;

import com.mapps.exceptions.NullParameterException;
import com.mapps.model.Device;
import com.mapps.model.KalmanState;
import com.mapps.model.Training;
import com.mapps.persistence.KalmanStateDAO;

/**
 * Implementation of KalmanStateDAO
 */
@Stateless(name = "KalmanStateDAO")
public class KalmanStateDAOImpl implements KalmanStateDAO{
    Logger logger = Logger.getLogger(KalmanStateDAOImpl.class);

    @PersistenceContext(unitName = "mapps-persistence")
    protected EntityManager entityManager;

    @Override
    public KalmanState getLastState(Training training, Device device) throws NullParameterException {
        if (training == null || device == null){
            throw new NullParameterException();
        }
        Query query = entityManager.createQuery("from KalmanState k where (k.training=:training and k.device =:device) " +
                                                        "order by t.date desc");
        query.setParameter("training", training);
        query.setParameter("device", device);
        List<KalmanState> list = query.getResultList();
        if(list.size() == 0)
            return null;
        else
            return list.get(0);
    }

    @Override
    public void addKalmanState(KalmanState state) throws NullParameterException{
        if (state == null){
            throw new NullParameterException();
        }
        logger.info("A new Kalman State was persisted");
        entityManager.persist(state);
    }
}
