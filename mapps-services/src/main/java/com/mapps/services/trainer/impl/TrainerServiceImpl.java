package com.mapps.services.trainer.impl;

import javax.ejb.EJB;
import javax.ejb.Stateless;

import com.mapps.authentificationhandler.AuthenticationHandler;
import com.mapps.authentificationhandler.exceptions.InvalidTokenException;

import com.mapps.exceptions.AthleteAlreadyExistException;
import com.mapps.exceptions.NullParameterException;
import com.mapps.exceptions.TrainingNotFoundException;
import com.mapps.model.*;

import com.mapps.persistence.SportDAO;
import com.mapps.services.trainer.exceptions.AuthenticationException;
import com.mapps.services.trainer.exceptions.InvalidAthleteException;
import com.mapps.services.trainer.exceptions.InvalidTrainingException;
import org.apache.log4j.Logger;

import com.mapps.persistence.AthleteDAO;
import com.mapps.persistence.DeviceDAO;
import com.mapps.persistence.TrainingDAO;
import com.mapps.services.trainer.TrainerService;

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
    public void addAthleteToTraining(Training training, Device device, Athlete athlete, String token) {
           if(invalidTraining(training)||invalidAthlete(athlete)||invalidDevice(device)){


           }
    }

    @Override
    public void modifyAthlete(Athlete athlete, String token) {

    }

    @Override
    public void deleteAthlete(Athlete athlete, String token) {

    }

    @Override
    public void addSport(Sport sport, String token) {

    }
}
