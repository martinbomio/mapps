package com.mapps.persistence.impl;

import java.util.List;
import javax.ejb.Stateless;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.Query;

import com.mapps.exceptions.InstitutionAlreadyExistException;
import com.mapps.exceptions.NullParameterException;
import org.apache.log4j.Logger;

import com.mapps.exceptions.InstitutionNotFoundException;
import com.mapps.model.Institution;
import com.mapps.persistence.InstitutionDAO;

/**
 *
 */
@Stateless(name = "InstitutionDAO")
public class InstitutionDAOImpl implements InstitutionDAO {

    Logger logger = Logger.getLogger(InstitutionDAOImpl.class);
    @PersistenceContext(unitName="mapps-persistence")
    EntityManager entityManager;

    @Override
    public void addInstitution(Institution institution) throws InstitutionAlreadyExistException, NullParameterException {
        if(institution!=null){
        if(isInDatabase(institution)){
           throw new InstitutionAlreadyExistException();
       }
        logger.info("A Institution was added to the database");
        entityManager.persist(institution);
        }else{
            throw new NullParameterException();
        }
    }
    private List<Institution> getByName(Institution institution){
        Query query = entityManager.createQuery("from Institution as i where i.name = :name")
                .setParameter("name", institution.getName());
        List<Institution> institutions = query.getResultList();
        return institutions;
    }

    private boolean isInDatabase(Institution institution) {
        boolean aux=true;
        List<Institution> institutions=getByName(institution);

        if (institutions.size() == 0){
            aux=false;
        }else{
            aux=true;
        }
        return aux;

    }

    @Override
    public void deleteInstitution(Long institutionId) throws InstitutionNotFoundException {
        Institution institution=getInstitutionById(institutionId);
        if(institution!=null){
            entityManager.remove(institution);
            logger.info("A Institution was removed from the database");
        }
    }

    @Override
    public void updateInstitution(Institution institution) throws InstitutionNotFoundException, NullParameterException {
        if(institution!=null){
        Institution instAux=getInstitutionByName(institution.getName());
        if(instAux!=null){
            entityManager.merge(institution);
            logger.info("A Institution was updated in the database");
        }
        }else{
            throw new NullParameterException();
        }
    }

    @Override
    public Institution getInstitutionById(Long institutionId) throws InstitutionNotFoundException {
        Institution instAux=entityManager.find(Institution.class, institutionId);
        if(instAux!=null){
            logger.info("A Institution was fetched from the database");
            return instAux;
        }else{
            logger.error("The Institution is not in the database");
            throw new InstitutionNotFoundException();
        }
    }

    @Override
    public Institution getInstitutionByName(String name) throws InstitutionNotFoundException {
        Query query = entityManager.createQuery("from Institution as i where i.name = :name")
                .setParameter("name", name);
        List<Institution> institutions = query.getResultList();
        if (institutions.size() != 1){
            logger.error("The Institution is not in the database");
            throw new InstitutionNotFoundException();
        }
        return institutions.get(0);
    }

    @Override
    public List<Institution> getAllInstitutions() {
        Query query = entityManager.createQuery("from Institution");
        return query.getResultList();
    }
}
