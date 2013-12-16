package com.mapps.services.trainer.impl;

import java.util.HashMap;
import java.util.Map;
import javax.ejb.EJB;
import javax.ejb.Stateless;

import org.apache.log4j.Logger;

import com.mapps.authentificationhandler.AuthenticationHandler;
import com.mapps.authentificationhandler.exceptions.InvalidTokenException;
import com.mapps.exceptions.AthleteAlreadyExistException;
import com.mapps.exceptions.AthleteNotFoundException;
import com.mapps.exceptions.NullParameterException;
import com.mapps.exceptions.SportAlreadyExistException;
import com.mapps.exceptions.TrainingNotFoundException;
import com.mapps.model.Athlete;
import com.mapps.model.Device;
import com.mapps.model.Role;
import com.mapps.model.Sport;
import com.mapps.model.Training;
import com.mapps.persistence.AthleteDAO;
import com.mapps.persistence.DeviceDAO;
import com.mapps.persistence.SportDAO;
import com.mapps.persistence.TrainingDAO;
import com.mapps.services.trainer.TrainerService;
import com.mapps.services.trainer.exceptions.AuthenticationException;
import com.mapps.services.trainer.exceptions.InvalidAthleteException;
import com.mapps.services.trainer.exceptions.InvalidSportException;
import com.mapps.services.trainer.exceptions.InvalidTrainingException;
import com.mapps.services.trainer.exceptions.InvalidParameterException;

/**
 * Implementation of the TrainerService
 */
@Stateless(name = "TrainerService")
public class TrainerServiceImpl implements TrainerService{
    Logger logger = Logger.getLogger(TrainerServiceImpl.class);
    @EJB(beanName = "TrainingDAO")
    protected TrainingDAO trainingDAO;
    @EJB(beanName = "AthleteDAO")
    protected AthleteDAO athleteDAO;
    @EJB(beanName = "DeviceDAO")
    protected DeviceDAO deviceDAO;
    @EJB(beanName = "AuthenticationHandler")
    protected AuthenticationHandler authenticationHandler;
    @EJB(beanName = "SportDAO")
    protected SportDAO sportDAO;


    private boolean invalidTraining(Training training){
        boolean aux=false;
        if(training.equals(null)||training.getName().equals(null)||training.getDate().equals(null)||training.getLatOrigin()==0
                ||training.getLongOrigin()==0||training.getSport().equals(null)){
            aux=true;
        }
        return aux;
    }
    private boolean invalidAthlete(Athlete athlete){
        boolean aux=false;
        if(athlete.equals(null)||athlete.getName().equals(null)||(athlete.getIdDocument()).equals(null)
                ||athlete.getHeight()==0||athlete.getWeight()==0){
            aux=true;
        }
        return aux;
    }
    private boolean invalidDevice(Device device){
        boolean aux=false;
        if(device.equals(null)||device.getDirHigh().equals(null)||device.getDirLow().equals(null)){
            aux=true;
        }
        return aux;

    }

    @Override
    public void startTraining(Training training, String token) throws InvalidTrainingException, AuthenticationException {
        if(invalidTraining(training)){
           logger.error("invalid training");
           throw new InvalidTrainingException();
        }
        try{
            if((authenticationHandler.isUserInRole(token, Role.ADMINISTRATOR))
                    ||(authenticationHandler.isUserInRole(token, Role.TRAINER))){
                Training trainingAux=trainingDAO.getTrainingByName(training.getName());
                training.setStarted(true);
                trainingDAO.updateTraining(trainingAux);

            }else{
            logger.error("authentication error");
            throw new AuthenticationException();
            }

        } catch (InvalidTokenException e) {
            logger.error("Invalid Token");
            throw new AuthenticationException();
        } catch (NullParameterException e) {
            logger.error("null training");
            throw new InvalidTrainingException();
        }  catch (TrainingNotFoundException e) {
            logger.error("training not found in database");
            throw new InvalidTrainingException();
        }

    }

    @Override
    public void stopTraining(Training training, String token) throws InvalidTrainingException, AuthenticationException {

        if(invalidTraining(training)){
            logger.error("invalid training");
            throw new InvalidTrainingException();
        }
        try{
            if((authenticationHandler.isUserInRole(token, Role.ADMINISTRATOR))
                    ||(authenticationHandler.isUserInRole(token, Role.TRAINER))){

                Training trainingAux=trainingDAO.getTrainingByName(training.getName());
                training.setStarted(false);
                trainingDAO.updateTraining(trainingAux);

            }else{
                logger.error("authentication error");
                throw new AuthenticationException();
            }



        } catch (InvalidTokenException e) {
            logger.error("Invalid Token");
            throw new AuthenticationException();
        } catch (NullParameterException e) {
            logger.error("null training");
            throw new InvalidTrainingException();
        }  catch (TrainingNotFoundException e) {
            logger.error("training not found in database");
            throw new InvalidTrainingException();
        }

    }

    @Override
    public void addAthlete(Athlete athlete, String token) throws InvalidAthleteException, AuthenticationException {
        if(invalidAthlete(athlete)){
            logger.error("invalid athlete");
            throw new InvalidAthleteException();
        }
        try{
        if(authenticationHandler.isUserInRole(token,Role.ADMINISTRATOR)||
                authenticationHandler.isUserInRole(token,Role.TRAINER)){
            athleteDAO.addAthlete(athlete);
        } else{
            logger.error("authentication error");
            throw new AuthenticationException();
        }

        } catch (InvalidTokenException e) {
            logger.error("Invalid Token");
            throw new AuthenticationException();
        } catch (AthleteAlreadyExistException e) {
            logger.error("Athlete already exist");
            throw new InvalidAthleteException();
        } catch (NullParameterException e) {
            logger.error("Athlete is null");
            throw new InvalidAthleteException();
        }


    }

    @Override
    public void addAthleteToTraining(Training training, Device device, Athlete athlete, String token) throws AuthenticationException, InvalidParameterException {
           if(invalidTraining(training)||invalidAthlete(athlete)||invalidDevice(device)){
               logger.error("invalid parameter");
               throw new InvalidParameterException();
           }


        try {
            if(authenticationHandler.isUserInRole(token,Role.ADMINISTRATOR)||
                    authenticationHandler.isUserInRole(token,Role.TRAINER)){
                if(training.getMapAthleteDevice().equals(null)){
                    Map<Athlete,Device> mapAthleteDevice=new HashMap<Athlete,Device>();
                    mapAthleteDevice.put(athlete,device);
                    training.setMapAthleteDevice(mapAthleteDevice);
                    trainingDAO.updateTraining(training);
                }else{
                    Map<Athlete,Device> aux=training.getMapAthleteDevice();
                    aux.put(athlete,device);
                    training.setMapAthleteDevice(aux);
                    trainingDAO.updateTraining(training);
                }


            }else{
                logger.error("authentication error");
                throw new AuthenticationException();
            }
        } catch (InvalidTokenException e) {
             throw new AuthenticationException();
        } catch (NullParameterException e) {
            throw new InvalidParameterException();
        } catch (TrainingNotFoundException e) {
            throw new InvalidParameterException();
        }
    }

    @Override
    public void modifyAthlete(Athlete athlete, String token) throws InvalidAthleteException, AuthenticationException {
        if(invalidAthlete(athlete)){
            throw new InvalidAthleteException();
        }
        try {
            if(authenticationHandler.isUserInRole(token,Role.ADMINISTRATOR)||
                    authenticationHandler.isUserInRole(token,Role.TRAINER)){
                athleteDAO.updateAthlete(athlete);

            }else{
                throw new AuthenticationException();
            }
        } catch (InvalidTokenException e) {
            throw new AuthenticationException();
        } catch (AthleteNotFoundException e) {
            throw new InvalidAthleteException();
        } catch (NullParameterException e) {
            throw new InvalidAthleteException();
        }


    }

    @Override
    public void deleteAthlete(Athlete athlete, String token) throws InvalidAthleteException, AuthenticationException {
        if(invalidAthlete(athlete)){
            throw new InvalidAthleteException();
        }
        try {
            if(authenticationHandler.isUserInRole(token,Role.ADMINISTRATOR)||
                    authenticationHandler.isUserInRole(token,Role.TRAINER)){
                athlete.setEnabled(false);
                athleteDAO.updateAthlete(athlete);

            }else{
                throw new AuthenticationException();
            }
        } catch (InvalidTokenException e) {
            throw new AuthenticationException();
        } catch (AthleteNotFoundException e) {
            throw new InvalidAthleteException();
        } catch (NullParameterException e) {
            throw new InvalidAthleteException();
        }

    }

    @Override
    public void addSport(Sport sport, String token) throws InvalidSportException, AuthenticationException {
        if(sport.equals(null)||sport.getName().equals(null)){
            throw new InvalidSportException();
        }
        try {
            if(authenticationHandler.isUserInRole(token,Role.ADMINISTRATOR)||
                    authenticationHandler.isUserInRole(token,Role.TRAINER)){
                sportDAO.addSport(sport);
            }else{
                throw new AuthenticationException();
            }
        } catch (InvalidTokenException e) {
            throw new AuthenticationException();
        } catch (SportAlreadyExistException e) {
            throw new InvalidSportException();
        } catch (NullParameterException e) {
            throw new InvalidSportException();
        }

    }
}
