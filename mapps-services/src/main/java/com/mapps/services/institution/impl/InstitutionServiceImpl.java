package com.mapps.services.institution.impl;

import javax.ejb.EJB;
import javax.ejb.Stateless;

import com.mapps.authentificationhandler.AuthenticationHandler;
import com.mapps.authentificationhandler.exceptions.InvalidTokenException;
import com.mapps.exceptions.InstitutionAlreadyExistException;
import com.mapps.exceptions.InstitutionNotFoundException;
import com.mapps.exceptions.NullParameterException;
import com.mapps.model.Institution;
import com.mapps.model.Role;
import com.mapps.persistence.InstitutionDAO;
import com.mapps.services.institution.InstitutionService;
import com.mapps.services.institution.exceptions.AuthenticationException;
import com.mapps.services.institution.exceptions.InvalidInstitutionException;
import org.apache.log4j.Logger;

/**
 *
 */
@Stateless(name="InstitutionService")
public class InstitutionServiceImpl implements InstitutionService {
    Logger logger = Logger.getLogger(InstitutionServiceImpl.class);

    @EJB(name = "InstitutionDAO")
    protected InstitutionDAO institutionDAO;
    @EJB(beanName = "AuthenticationHandler")
    protected AuthenticationHandler authenticationHandler;


    @Override
    public void createInstitution(Institution institution, String token) throws AuthenticationException, InvalidInstitutionException {
        if(institution==null||institution.getName()==null||institution.getCountry()==null){
            logger.error("invalid institution");
            throw new InvalidInstitutionException();
        }
        try {
            if(!(authenticationHandler.isUserInRole(token, Role.ADMINISTRATOR))||
                    !(authenticationHandler.isUserInRole(token, Role.TRAINER))){
                logger.error("authentication error");
                throw new AuthenticationException();
            }
            institutionDAO.addInstitution(institution);

        } catch (InvalidTokenException e) {
            logger.error("Invalid Token");
            throw new AuthenticationException();
        }catch (InstitutionAlreadyExistException e2){
            logger.error("institution already exist");
            throw new InvalidInstitutionException();
        } catch (NullParameterException e3) {
            logger.error("invalid institution");
            throw new InvalidInstitutionException();
        }
    }

    @Override
    public void deleteInstitution(Institution institution, String token) throws AuthenticationException, InvalidInstitutionException{
        if(institution==null||institution.getName()==null||institution.getCountry()==null){
            logger.error("invalid institution");
            throw new InvalidInstitutionException();
        }
        try{
        if(!(authenticationHandler.isUserInRole(token, Role.ADMINISTRATOR))){
            logger.error("authentication error");
            throw new AuthenticationException();
        }
        Institution instAux=institutionDAO.getInstitutionByName(institution.getName());
        instAux.setEnabled(false);
        institutionDAO.updateInstitution(instAux);

        }catch (InvalidTokenException e) {
            logger.error("Invalid Token");
            throw new AuthenticationException();

        }catch (NullParameterException e) {
            logger.error("null institution");
            throw new InvalidInstitutionException();

        } catch (InstitutionNotFoundException e) {
            logger.error("institution not found in database");
            throw new InvalidInstitutionException();
        }
    }

    @Override
    public void updateInstitution(Institution institution, String token) throws AuthenticationException, InvalidInstitutionException{
        if(institution==null||institution.getName()==null||institution.getCountry()==null){
            logger.error("invalid institution");
            throw new InvalidInstitutionException();
        }
        try{
        if(!(authenticationHandler.isUserInRole(token, Role.ADMINISTRATOR))){
            logger.error("authentication error");
            throw new AuthenticationException();
        }
        institutionDAO.updateInstitution(institution);

        } catch (InvalidTokenException e) {
            logger.error("Invalid Token");
            throw new AuthenticationException();
        } catch (NullParameterException e) {
            logger.error("null institution");
            throw new InvalidInstitutionException();
        } catch (InstitutionNotFoundException e) {
            logger.error("institution not found in database");
            throw new InvalidInstitutionException();
        }
    }
}
