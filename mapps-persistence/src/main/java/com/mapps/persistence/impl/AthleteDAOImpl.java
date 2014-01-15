package com.mapps.persistence.impl;

import java.util.List;
import javax.ejb.Stateless;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.Query;

import com.mapps.exceptions.NullParameterException;
import org.apache.log4j.Logger;

import com.mapps.exceptions.AthleteAlreadyExistException;
import com.mapps.exceptions.AthleteNotFoundException;
import com.mapps.model.Athlete;
import com.mapps.persistence.AthleteDAO;

/**
 *
 */
@Stateless(name="AthleteDAO")
public class AthleteDAOImpl implements AthleteDAO{

    Logger logger= Logger.getLogger(AthleteDAOImpl.class);
    @PersistenceContext(unitName = "mapps-persistence")
    EntityManager entityManager;

    @Override
    public void addAthlete(Athlete athlete) throws AthleteAlreadyExistException, NullParameterException {
        if(athlete!=null){


        if(isInDatabase(athlete)){
            throw new AthleteAlreadyExistException();
        }
        logger.info("a athlete was added to the database");
        entityManager.persist(athlete);
        }else{
            throw new NullParameterException();
        }
    }

    private List<Athlete> getByIdDocument(Athlete athlete){
        Query query=entityManager.createQuery("from Athlete where idDocument = :document");
        query.setParameter("document",athlete.getIdDocument());
        List<Athlete> results=query.getResultList();
        return results;
    }

    private boolean isInDatabase(Athlete athlete)  {
        boolean aux=true;
        List<Athlete> results=getByIdDocument(athlete);
        if (results.size() == 0){
                aux=false;
        }else{
                aux=true;
        }
        return aux;
    }

    @Override
    public void deleteAthlete(Long athleteId) throws AthleteNotFoundException {
        Athlete athAux=getAthleteById(athleteId);
        if(athAux!=null){
            entityManager.remove(athAux);
            logger.info("a Athlete was removed from the database");
        }
    }

    @Override
    public void updateAthlete(Athlete athlete) throws AthleteNotFoundException, NullParameterException {
        if(athlete!=null){
        Athlete athAux=getAthleteById(athlete.getId());
        if(athAux!=null){
            entityManager.merge(athlete);
            logger.info("A Athlete was updated in the database");
        }
        }else{
            throw new NullParameterException();
        }
    }

    @Override
    public Athlete getAthleteById(Long athleteId) throws AthleteNotFoundException {
        Athlete athAux=entityManager.find(Athlete.class,athleteId);
        if(athAux!=null){
            return athAux;
        }else{
            throw new AthleteNotFoundException();
        }
    }

    @Override
    public Athlete getAthleteByName(String name) throws AthleteNotFoundException {
       Query query=entityManager.createQuery("from Athlete as a where a.name = :name");
       query.setParameter("name",name);
        List<Athlete> results = query.getResultList();
        if (results.size() != 1){
            throw new AthleteNotFoundException();
        }
        return results.get(0);

    }

    @Override
    public Athlete getAthleteByIdDocument(String idDocument) throws AthleteNotFoundException {
        Query query=entityManager.createQuery("from Athlete where idDocument = :document");
        query.setParameter("document",idDocument);
        List<Athlete> results=query.getResultList();
        if (results.size() != 1){
            throw new AthleteNotFoundException();
        }
        return results.get(0);

    }

    @Override
    public List<Athlete> getAllAthletesByInstitution(String institutionName) {

        Query query=entityManager.createQuery("select a from Athlete as a INNER JOIN a.institution as i WHERE i.name =:name");
        query.setParameter("name",institutionName);
        List<Athlete> results=query.getResultList();
        return results;
    }
    @Override
    public List<Athlete> getAllAthletes(){
        Query query = entityManager.createQuery("from Athlete");
        return query.getResultList();
    }


}

