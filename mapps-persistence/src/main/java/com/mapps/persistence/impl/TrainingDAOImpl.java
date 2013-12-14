package com.mapps.persistence.impl;

import com.mapps.exceptions.NullParameterException;
import com.mapps.exceptions.TrainingAlreadyExistException;
import com.mapps.exceptions.TrainingNotFoundException;
import com.mapps.model.Athlete;
import com.mapps.model.Device;
import com.mapps.model.Training;
import com.mapps.persistence.TrainingDAO;
import org.apache.log4j.Logger;


import javax.ejb.Stateless;

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.Query;
import java.util.Date;
import java.util.List;

/**
 *
 */
@Stateless(name = "TrainingDAO")
public class TrainingDAOImpl implements TrainingDAO {

    Logger logger = Logger.getLogger(TrainingDAOImpl.class);
    @PersistenceContext(unitName="mapps-persistence")
    EntityManager entityManager;

    @Override
    public void addTraining(Training training) throws TrainingAlreadyExistException, NullParameterException {
        if(training!=null){
        if(isInDatabase(training)){
            throw new TrainingAlreadyExistException();
        }
        logger.info("A Training was added to the database");
        entityManager.persist(training);
        }else{
            throw new NullParameterException();
        }
    }

    private List<Training> getByName(Training training){
        Query query=entityManager.createQuery("from Training as t where t.name=:name").setParameter("name",training.getName());
        List<Training> results=query.getResultList();
        return results;
    }
    private boolean isInDatabase(Training training){
        boolean aux=true;
        List<Training> results=getByName(training);
        if (results.size() == 0){
            aux=false;
        }else{
            aux=true;
        }
        return aux;
    }

    @Override
    public void deleteTraining(Long trainingId) throws TrainingNotFoundException {
        Training training=getTrainingById(trainingId);
        if(training!=null){
            entityManager.remove(training);
            logger.info("A Training was removed from the database");
        }
    }

    @Override
    public void updateTraining(Training training) throws TrainingNotFoundException, NullParameterException {
        if(training!=null){
        Training trainingAux=getTrainingByName(training.getName());
        if(trainingAux!=null){
            entityManager.merge(training);
            logger.info("A Training was updated in the database");
        }
        }else{
            throw new NullParameterException();
        }
    }

    @Override
    public Training getTrainingById(Long trainingId) throws TrainingNotFoundException {
        Training TrainingAux=entityManager.find(Training.class, trainingId);
        if(TrainingAux!=null){
            return TrainingAux;
        }else{
            logger.error("The Training is not in the database");
            throw new TrainingNotFoundException();
        }
    }
    @Override
    public boolean isTrainingStarted(String name) throws TrainingNotFoundException {
        boolean started=false;
        Training aux=getTrainingByName(name);
        if(aux.isStarted()){
            started=true;
        }
        return started;

    }
    @Override
    public Training getTrainingByDate(Long trainingDate) throws TrainingNotFoundException {
        Query query=entityManager.createQuery("from Training as t where t.date=:date");
        query.setParameter("date",trainingDate);
        List<Training> results=query.getResultList();
        if(results.size()!=1) {
            throw new TrainingNotFoundException();
        }
            return results.get(0);


    }
    @Override
    public Training getTrainingByName(String trainingName) throws TrainingNotFoundException {
        Query query=entityManager.createQuery("from Training as t where t.name=:name");
        query.setParameter("name",trainingName);
        List<Training> results=query.getResultList();
        if(results.size()!=1) {
            throw new TrainingNotFoundException();
        }
        return results.get(0);
    }

    @Override
    public List<Training> getTrainingOfDevice(String dirLow,Date date) {
        Query query=entityManager.createQuery("select t from Training t join t.mapAthleteDevice m " +
                "where (m.dirLow = :key and t.date=:date)");
        query.setParameter("key",dirLow);
        query.setParameter("date",date);
        List<Training> results=query.getResultList();
/*        if(results.size()!=1) {
            throw new TrainingNotFoundException();
        }
        return results.get(0);*/
        return results;

        }

    @Override
    public List<Training> getTrainingOfAthlete(Athlete athlete) {
        Query query=entityManager.createQuery("select t from Training t join t.mapAthleteDevice m where index(m)=:key" );
        query.setParameter("key",athlete);
        List<Training> results=query.getResultList();
        return results;
    }

    @Override
    public List<Training> getTrainingOfInstitution(String name) {
        Query query =entityManager.createQuery("select t from Training t join t.institution i where i.name=:name");
        query.setParameter("name",name);
        List<Training> results=query.getResultList();
        return results;
    }
}
