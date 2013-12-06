package com.mapps.persistence.impl;

import java.util.List;
import javax.ejb.Stateless;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.Query;

import com.mapps.exceptions.NullParameterException;
import com.mapps.exceptions.SportAlreadyExistException;
import org.apache.log4j.Logger;

import com.mapps.exceptions.SportNotFoundException;
import com.mapps.model.Sport;
import com.mapps.persistence.SportDAO;

/**
 *
 */
@Stateless(name = "SportDAO")
public class SportDAOImpl implements SportDAO {

    Logger logger= Logger.getLogger(SportDAOImpl.class);
    @PersistenceContext(unitName="mapps-persistence")
    EntityManager entityManager;

    @Override
    public void addSport(Sport sport) throws SportAlreadyExistException, NullParameterException {
        if(sport!=null){
        if(isInDatabase(sport)){
            throw new SportAlreadyExistException();
        }
        logger.info("A sport was added to the database");
        entityManager.persist(sport);
        }else{
            throw new NullParameterException();
        }
    }


    private boolean isInDatabase(Sport sport) {
        boolean aux=true;
        Query query=entityManager.createQuery("from Sport as s where s.name=:name");
        query.setParameter("name",sport.getName());
        List<Sport> result=query.getResultList();
        if(result.size()==0){
            aux=false;
        }else{
            aux=true;
        }
        return aux;
    }

    @Override
    public void deleteSport(Long sportId) throws SportNotFoundException {
        logger.info("A Sport was deleted from the database");
        Sport sportAux =getSportById(sportId);
        if(sportAux!=null){
            entityManager.remove(sportAux);
        }
    }

    @Override
    public void updateSport(Sport sport) throws SportNotFoundException, NullParameterException {
        if(sport!=null){
        Sport sportAux=getSportByName(sport.getName());
        if(sportAux!=null){
            entityManager.merge(sport);
            logger.info("A Sport has been updated");
        }
        }else{
            throw new NullParameterException();
        }
    }

    @Override
    public Sport getSportById(Long sportId) throws SportNotFoundException {
         Sport sportAux= entityManager.find(Sport.class,sportId);
        if(sportAux!=null){
            logger.info("A Sport was fetched from the database");
            return sportAux;

        }else{
            logger.info("The sport is not in the database");
            throw new SportNotFoundException();
        }
    }

    @Override
    public Sport getSportByName(String name) throws SportNotFoundException {
        Query query = entityManager.createQuery("from Sport as s where s.name = :name").setParameter("name", name);
        List<Sport> sports = query.getResultList();
        if(sports.size() != 1){
            logger.info("The sport is not in the database");
            throw new SportNotFoundException();
        }
        return sports.get(0);
    }

    @Override
    public List<Sport> getAllSports() {
        Query query = entityManager.createQuery("from Sport");
        return query.getResultList();
    }
}
