package com.mapps.services.institution.impl;

import java.util.List;
import javax.ejb.EJB;
import javax.ejb.Stateless;

import org.apache.log4j.Logger;

import com.mapps.authentificationhandler.AuthenticationHandler;
import com.mapps.authentificationhandler.exceptions.InvalidTokenException;
import com.mapps.exceptions.InstitutionAlreadyExistException;
import com.mapps.exceptions.InstitutionNotFoundException;
import com.mapps.exceptions.NullParameterException;
import com.mapps.exceptions.UserNotFoundException;
import com.mapps.model.Device;
import com.mapps.model.Institution;
import com.mapps.model.Role;
import com.mapps.model.Training;
import com.mapps.model.User;
import com.mapps.persistence.DeviceDAO;
import com.mapps.persistence.InstitutionDAO;
import com.mapps.persistence.TrainingDAO;
import com.mapps.persistence.UserDAO;
import com.mapps.services.institution.InstitutionService;
import com.mapps.services.institution.exceptions.AuthenticationException;
import com.mapps.services.institution.exceptions.InvalidInstitutionException;
import com.mapps.services.user.exceptions.InvalidUserException;

/**
 *
 */
@Stateless(name="InstitutionService")
public class InstitutionServiceImpl implements InstitutionService {
    Logger logger = Logger.getLogger(InstitutionServiceImpl.class);

    @EJB(beanName = "InstitutionDAO")
    protected InstitutionDAO institutionDAO;
    @EJB(beanName = "AuthenticationHandler")
    protected AuthenticationHandler authenticationHandler;
    @EJB(beanName = "UserDAO")
    protected UserDAO userDAO;
    @EJB(beanName = "DeviceDAO")
    protected DeviceDAO deviceDAO;
    @EJB(beanName = "TrainingDAO")
    protected TrainingDAO trainingDAO;


    @Override
    public void createInstitution(Institution institution, String token) throws AuthenticationException, InvalidInstitutionException {
        if(institution==null||institution.getName()==null||institution.getCountry()==null){
            logger.error("invalid institution");
            throw new InvalidInstitutionException();
        }
        try {
            if((authenticationHandler.isUserInRole(token, Role.ADMINISTRATOR))||
                    (authenticationHandler.isUserInRole(token, Role.TRAINER))){
                institutionDAO.addInstitution(institution);
            }else{
                logger.error("authentication error");
                throw new AuthenticationException();
            }
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

    @Override
    public List<Institution> getAllInstitutions() {
        return institutionDAO.getAllInstitutions();
    }
    @Override
    public Institution getInstitutionByName(String name){
        Institution aux=null;
        if(name!=null){
            try {
                aux=institutionDAO.getInstitutionByName(name);
            } catch (InstitutionNotFoundException e) {
                logger.error("institution not found in database");
            }
        }
    return aux;
    }

    @Override
    public Institution getInstitutionOfUser(String username) throws InvalidUserException {
        try {
            User aux = userDAO.getUserByUsername(username);
            Institution instAux = aux.getInstitution();
            return instAux;
        } catch (UserNotFoundException e) {
            throw new InvalidUserException();
        }
    }

    @Override
    public Institution getInstitutionByID(String token, long id) throws InvalidInstitutionException, AuthenticationException {
        if (token == null){
            throw new AuthenticationException();
        }
        if (!authenticationHandler.validateToken(token)){
            throw new AuthenticationException();
        }
        try {
            return institutionDAO.getInstitutionById(id);
        } catch (InstitutionNotFoundException e) {
            logger.error("Institution nos found for id :"+ id);
            throw new InvalidInstitutionException();
        }
    }

    @Override
    public List<Device> getDeviceOfInstitution(String token) throws AuthenticationException {
        if (token == null){
            throw new AuthenticationException();
        }
        if(!authenticationHandler.validateToken(token)){
           throw new AuthenticationException();
        }
        try {
            User user = authenticationHandler.getUserOfToken(token);
            return deviceDAO.getAllDevicesByInstitution(user.getInstitution().getName());
        } catch (InvalidTokenException e) {
            logger.error("Invalid token");
            throw new AuthenticationException();
        }
    }

    @Override
    public List<Training> getTraingsToStartOfInstitution(String token) throws AuthenticationException {
        if (token == null){
            throw new AuthenticationException();
        }
        try {
            if (authenticationHandler.isUserInRole(token, Role.USER)){
                throw new AuthenticationException();
            }
            User user = authenticationHandler.getUserOfToken(token);
            return trainingDAO.getAllToStartOfInstitution(user.getInstitution());
        } catch (InvalidTokenException e) {
            logger.error("Invalid token");
            throw new AuthenticationException();
        }
    }

    @Override
    public List<User> getUsersOfInstitution(String token) throws AuthenticationException {
        if (token == null){
            throw new AuthenticationException();
        }
        try {
            if (!authenticationHandler.validateToken(token)){
                throw new AuthenticationException();
            }
            User user = authenticationHandler.getUserOfToken(token);
            return userDAO.getAllUsersByInstitution(user.getInstitution());
        } catch (InvalidTokenException e) {
            logger.error("Invalid token");
            throw new AuthenticationException();
        }
    }
}
