package com.mapps.services.trainer.impl;

import java.security.InvalidParameterException;
import java.util.*;
import javax.ejb.EJB;
import javax.ejb.Stateless;

import com.mapps.exceptions.*;
import com.mapps.services.trainer.exceptions.*;
import org.apache.log4j.Logger;

import com.mapps.authentificationhandler.AuthenticationHandler;
import com.mapps.authentificationhandler.exceptions.InvalidTokenException;
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

/**
 * Implementation of the TrainerService
 */
@Stateless(name = "TrainerService")
public class TrainerServiceImpl implements TrainerService {
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


    private boolean invalidTraining(Training training) {
        boolean aux = false;
        if (training.equals(null) || training.getName().equals(null) || training.getDate().equals(null) || training.getLatOrigin() == 0
                || training.getLongOrigin() == 0 || training.getSport().equals(null)) {
            aux = true;
        }
        return aux;
    }

    private boolean invalidAthlete(Athlete athlete) {
        boolean aux = false;
        if (athlete.equals(null) || athlete.getName().equals(null) || (athlete.getIdDocument()).equals(null)
                || athlete.getHeight() == 0 || athlete.getWeight() == 0) {
            aux = true;
        }
        return aux;
    }

    private boolean invalidDevice(Device device) {
        boolean aux = false;
        if (device.equals(null) || device.getDirHigh().equals(null) || device.getDirLow().equals(null)) {
            aux = true;
        }
        return aux;

    }

    @Override
    public void addTraining(Training training,String token) throws AuthenticationException, InvalidTrainingException {
        if(invalidTraining(training)){
            throw new AuthenticationException();
        }
        try {
            if (authenticationHandler.isUserInRole(token, Role.ADMINISTRATOR) ||
                    authenticationHandler.isUserInRole(token, Role.TRAINER)) {
                trainingDAO.addTraining(training);
            } else {
                logger.error("authentication error");
                throw new AuthenticationException();
            }

        } catch (InvalidTokenException e) {
            throw new AuthenticationException();
        } catch (TrainingAlreadyExistException e) {
            throw new InvalidTrainingException();
        } catch (NullParameterException e) {
            throw new InvalidTrainingException();
        }

    }
    @Override
    public List<String> getAllSportsNames(){
        List<String> aux=new ArrayList<String>();
        List<Sport> sports=sportDAO.getAllSports();
        for(int i=0;i<sports.size();i++){
            aux.add((sports.get(i)).getName());
        }
        return aux;  //To change body of implemented methods use File | Settings | File Templates.
    }
    @Override
    public List<String> getAllAthletesId(){
        List<String> aux=new ArrayList<String>();
        List<Athlete> athletesId=athleteDAO.getAllAthletes();
        for(int i=0;i<athletesId.size();i++){
            aux.add((athletesId.get(i)).getIdDocument());
        }
        return aux;
    }
    @Override
     public List<Athlete> getAllAthletes(){
        List<Athlete> aux=athleteDAO.getAllAthletes();
        return aux;
    }
    @Override
    public List<Athlete> getAllAthletesOfInstitution(String instName){
        List<Athlete> aux=athleteDAO.getAllAthletesByInstitution(instName);
        return aux;
    }

    @Override
    public List<String> getAllDevicesDirs() {
        List<String> aux=new ArrayList<String>();
        List<Device> devices=deviceDAO.getAllDevices();
        for(int i=0;i<devices.size();i++){
            aux.add((devices.get(i)).getDirLow());
        }
        return aux;
    }

    @Override
    public Sport getSportByName(String sportName) {
        Sport aux=null;
        if(sportName!=null){
            try {
                aux=sportDAO.getSportByName(sportName);
            } catch (SportNotFoundException e) {
                logger.error("sport not found");
            }
        }
        return aux;
    }
    @Override
    public Training getTrainingByName(String name) throws InvalidTrainingException {
        Training aux=null;
        if(name!=null){
            try {
                aux=trainingDAO.getTrainingByName(name);
            } catch (TrainingNotFoundException e) {
                throw new InvalidTrainingException();
            }
        }
        return aux;
    }

    @Override
    public Device getDeviceByDir(String dirDevice) throws InvalidDeviceException {
        Device aux=null;
        if(dirDevice!=null){
            try {
                aux=deviceDAO.getDeviceByDir(dirDevice);
            }  catch (DeviceNotFoundException e) {
                logger.error("device not found");
                throw new InvalidDeviceException();
            }
        }
        return aux;
    }
    @Override
    public Athlete getAthleteByIdDocument(String idDocument) throws InvalidAthleteException {
        Athlete aux=null;
        if(idDocument!=null){
            try {
                aux=athleteDAO.getAthleteByIdDocument(idDocument);
            } catch (AthleteNotFoundException e) {
               throw new InvalidAthleteException();
            }
        }
        return aux;
    }

    @Override
    public void startTraining(Training training, String token) throws InvalidTrainingException, AuthenticationException {
        if (invalidTraining(training)) {
            logger.error("invalid training");
            throw new InvalidTrainingException();
        }
        try {
            if ((authenticationHandler.isUserInRole(token, Role.ADMINISTRATOR))
                    || (authenticationHandler.isUserInRole(token, Role.TRAINER))) {
                Training trainingAux = trainingDAO.getTrainingByName(training.getName());
                //Date date=new Date();
                //training.setDate(date);
                training.setStarted(true);
                trainingDAO.updateTraining(trainingAux);

            } else {
                logger.error("authentication error");
                throw new AuthenticationException();
            }

        } catch (InvalidTokenException e) {
            logger.error("Invalid Token");
            throw new AuthenticationException();
        } catch (NullParameterException e) {
            logger.error("null training");
            throw new InvalidTrainingException();
        } catch (TrainingNotFoundException e) {
            logger.error("training not found in database");
            throw new InvalidTrainingException();
        }

    }

    @Override
    public void stopTraining(Training training, String token) throws InvalidTrainingException, AuthenticationException {

        if (invalidTraining(training)) {
            logger.error("invalid training");
            throw new InvalidTrainingException();
        }
        try {
            if ((authenticationHandler.isUserInRole(token, Role.ADMINISTRATOR))
                    || (authenticationHandler.isUserInRole(token, Role.TRAINER))) {

                Training trainingAux = trainingDAO.getTrainingByName(training.getName());
                training.setStarted(false);
                trainingDAO.updateTraining(trainingAux);

            } else {
                logger.error("authentication error");
                throw new AuthenticationException();
            }


        } catch (InvalidTokenException e) {
            logger.error("Invalid Token");
            throw new AuthenticationException();
        } catch (NullParameterException e) {
            logger.error("null training");
            throw new InvalidTrainingException();
        } catch (TrainingNotFoundException e) {
            logger.error("training not found in database");
            throw new InvalidTrainingException();
        }

    }
    @Override
    public void modifyDevice(Device device, String token) throws InvalidDeviceException, AuthenticationException {
        if (invalidDevice(device)) {
            throw new InvalidDeviceException();
        }
        try {
            if (authenticationHandler.isUserInRole(token, Role.ADMINISTRATOR) ||
                    authenticationHandler.isUserInRole(token, Role.TRAINER)) {
                deviceDAO.updateDevice(device);

            } else {
                throw new AuthenticationException();
            }
        } catch (InvalidTokenException e) {
            throw new AuthenticationException();
        } catch (DeviceNotFoundException e) {
            throw new InvalidDeviceException();
        } catch (NullParameterException e) {
            throw new InvalidDeviceException();
        }


    }

    @Override
    public void addDevice(Device device,String token) throws InvalidDeviceException, AuthenticationException {
       if(invalidDevice(device)){
           logger.error("invalid device");
           throw new InvalidDeviceException();
       }
     try{
        if (authenticationHandler.isUserInRole(token, Role.ADMINISTRATOR) ||
                authenticationHandler.isUserInRole(token, Role.TRAINER)) {
            deviceDAO.addDevice(device);
        } else {
            logger.error("authentication error");
            throw new AuthenticationException();
        }
    } catch (InvalidTokenException e) {
         logger.error("Invalid Token");
         throw new AuthenticationException();
     } catch (DeviceAlreadyExistException e) {
         logger.error("Athlete already exist");
         throw new InvalidDeviceException();
     } catch (NullParameterException e) {
         logger.error("Athlete is null");
         throw new InvalidDeviceException();
     }


    }

    @Override
    public void addAthlete(Athlete athlete, String token) throws InvalidAthleteException, AuthenticationException {
        if (invalidAthlete(athlete)) {
            logger.error("invalid athlete");
            throw new InvalidAthleteException();
        }
        try {
            if (authenticationHandler.isUserInRole(token, Role.ADMINISTRATOR) ||
                    authenticationHandler.isUserInRole(token, Role.TRAINER)) {
                athleteDAO.addAthlete(athlete);
            } else {
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
    public void addAthleteToTraining(String trainingName, String dirDevice, String idAthlete, String token) throws
            AuthenticationException, InvalidParException {

        Athlete athlete= null;
        try {
            athlete = athleteDAO.getAthleteByIdDocument(idAthlete);
        } catch (AthleteNotFoundException e) {
            throw new InvalidParException();
        }

        Device device= null;
        try {
            device = deviceDAO.getDeviceByDir(dirDevice);
        } catch (DeviceNotFoundException e) {
            throw new InvalidParException();
        }

        Training training= null;
        try {
            training = trainingDAO.getTrainingByName(trainingName);
        } catch (TrainingNotFoundException e) {
            throw new InvalidParException();
        }


        if (invalidTraining(training) || invalidAthlete(athlete) || invalidDevice(device)) {
            logger.error("invalid parameter");
            throw new InvalidParException();
        }


        try {
            if (authenticationHandler.isUserInRole(token, Role.ADMINISTRATOR) ||
                    authenticationHandler.isUserInRole(token, Role.TRAINER)) {
                if (training.getMapAthleteDevice().equals(null)) {
                    Map<Athlete, Device> mapAthleteDevice = new HashMap<Athlete, Device>();
                    mapAthleteDevice.put(athlete, device);
                    training.setMapAthleteDevice(mapAthleteDevice);
                    trainingDAO.updateTraining(training);
                } else {
                    Map<Athlete, Device> aux = training.getMapAthleteDevice();
                    aux.put(athlete, device);
                    training.setMapAthleteDevice(aux);
                    trainingDAO.updateTraining(training);
                }


            } else {
                logger.error("authentication error");
                throw new AuthenticationException();
            }
        } catch (InvalidTokenException e) {
            throw new AuthenticationException();
        } catch (NullParameterException e) {
            throw new InvalidParException();
        } catch (TrainingNotFoundException e) {
            throw new InvalidParException();
        }
    }

    @Override
    public void modifyAthlete(Athlete athlete, String token) throws InvalidAthleteException, AuthenticationException {
        if (invalidAthlete(athlete)) {
            throw new InvalidAthleteException();
        }
        try {
            if (authenticationHandler.isUserInRole(token, Role.ADMINISTRATOR) ||
                    authenticationHandler.isUserInRole(token, Role.TRAINER)) {
                athleteDAO.updateAthlete(athlete);

            } else {
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
        if (invalidAthlete(athlete)) {
            throw new InvalidAthleteException();
        }
        try {
            if (authenticationHandler.isUserInRole(token, Role.ADMINISTRATOR) ||
                    authenticationHandler.isUserInRole(token, Role.TRAINER)) {
                athlete.setEnabled(false);
                athleteDAO.updateAthlete(athlete);

            } else {
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
        if (sport.equals(null) || sport.getName().equals(null)) {
            throw new InvalidSportException();
        }
        try {
            if (authenticationHandler.isUserInRole(token, Role.ADMINISTRATOR) ||
                    authenticationHandler.isUserInRole(token, Role.TRAINER)) {
                sportDAO.addSport(sport);
            } else {
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
