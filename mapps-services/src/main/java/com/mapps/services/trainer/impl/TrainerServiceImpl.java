package com.mapps.services.trainer.impl;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.ejb.EJB;
import javax.ejb.Stateless;

import org.apache.log4j.Logger;

import com.mapps.authentificationhandler.AuthenticationHandler;
import com.mapps.authentificationhandler.exceptions.InvalidTokenException;
import com.mapps.exceptions.AthleteAlreadyExistException;
import com.mapps.exceptions.AthleteNotFoundException;
import com.mapps.exceptions.DeviceNotFoundException;
import com.mapps.exceptions.NullParameterException;
import com.mapps.exceptions.SportAlreadyExistException;
import com.mapps.exceptions.SportNotFoundException;
import com.mapps.exceptions.TrainingAlreadyExistException;
import com.mapps.exceptions.TrainingNotFoundException;
import com.mapps.model.Athlete;
import com.mapps.model.Device;
import com.mapps.model.Role;
import com.mapps.model.Sport;
import com.mapps.model.Training;
import com.mapps.model.User;
import com.mapps.persistence.AthleteDAO;
import com.mapps.persistence.DeviceDAO;
import com.mapps.persistence.SportDAO;
import com.mapps.persistence.TrainingDAO;
import com.mapps.services.trainer.TrainerService;
import com.mapps.services.trainer.exceptions.AuthenticationException;
import com.mapps.services.trainer.exceptions.InvalidAthleteException;
import com.mapps.services.trainer.exceptions.InvalidDeviceException;
import com.mapps.services.trainer.exceptions.InvalidParException;
import com.mapps.services.trainer.exceptions.InvalidSportException;
import com.mapps.services.trainer.exceptions.InvalidTrainingException;

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
        if (training == null || training.getName() == null || training.getDate() == null || training.getLatOrigin() == 0
                || training.getLongOrigin() == 0 || training.getSport() == null) {
            aux = true;
        }
        return aux;
    }

    private boolean invalidAthlete(Athlete athlete) {
        boolean aux = false;
        if (athlete == null || athlete.getName() == null || athlete.getIdDocument() == null
                || athlete.getHeight() == 0 || athlete.getWeight() == 0) {
            aux = true;
        }
        return aux;
    }

    private boolean invalidDevice(Device device) {
        boolean aux = false;
        if (device == null || device.getDirHigh() == null || device.getDirLow() == null) {
            aux = true;
        }
        return aux;

    }

    @Override
    public void addTraining(Training training, String token) throws AuthenticationException, InvalidTrainingException {
        if (invalidTraining(training)) {
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
    public List<Athlete> getAllAthletes() {
        List<Athlete> aux = athleteDAO.getAllAthletes();
        return aux;
    }

    @Override
    public List<Athlete> getAllAthletesOfInstitution(String instName) {
        List<Athlete> aux = athleteDAO.getAllAthletesByInstitution(instName);
        return aux;
    }

    @Override
    public Sport getSportByName(String sportName) {
        Sport aux = null;
        if (sportName != null) {
            try {
                aux = sportDAO.getSportByName(sportName);
            } catch (SportNotFoundException e) {
                logger.error("sport not found");
            }
        }
        return aux;
    }

    @Override
    public Training getTrainingByName(String name) throws InvalidTrainingException {
        Training aux = null;
        if (name != null) {
            try {
                aux = trainingDAO.getTrainingByName(name);
            } catch (TrainingNotFoundException e) {
                throw new InvalidTrainingException();
            }
        }
        return aux;
    }


    @Override
    public Device getDeviceByDir(String dirDevice) throws InvalidDeviceException {
        Device aux = null;
        if (dirDevice != null) {
            try {
                aux = deviceDAO.getDeviceByDir(dirDevice);
            } catch (DeviceNotFoundException e) {
                logger.error("device not found");
                throw new InvalidDeviceException();
            }
        }
        return aux;
    }

    @Override
    public Device getDeviceById(long id) throws InvalidDeviceException {
        Device aux = null;

        try {
            aux = deviceDAO.getDeviceById(id);
        } catch (DeviceNotFoundException e) {
            logger.error("device not found");
            throw new InvalidDeviceException();
        }

        return aux;
    }

    @Override
    public List<Training> getAllEditableTrainings(String token) throws AuthenticationException {
        if (token == null) {
            throw new AuthenticationException();
        }
        try {
            if (authenticationHandler.isUserInRole(token, Role.ADMINISTRATOR)){
                return trainingDAO.getAllTrainings();
            }else if (authenticationHandler.isUserInRole(token, Role.TRAINER)){
                User user = authenticationHandler.getUserOfToken(token);
                return trainingDAO.getAllEditableTrainings(user);
            }else {
                logger.error("Authentication error, user has no privilages");
                throw new AuthenticationException();
            }
        } catch (InvalidTokenException e) {
            logger.error("Invalid token");
            throw new AuthenticationException();
        } catch (NullParameterException e) {
            logger.error("Invalid token");
            throw new AuthenticationException();
        }
    }

    @Override
    public Athlete getAthleteByIdDocument(String idDocument) throws InvalidAthleteException {
        Athlete aux = null;
        if (idDocument != null) {
            try {
                aux = athleteDAO.getAthleteByIdDocument(idDocument);
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
                Date date = new Date();
                training.setDate(date);
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
        try {
            Athlete athlete = athleteDAO.getAthleteByIdDocument(idAthlete);
            Device device = deviceDAO.getDeviceByDir(dirDevice);
            Training training = trainingDAO.getTrainingByName(trainingName);
            if (invalidTraining(training) || invalidAthlete(athlete) || invalidDevice(device)) {
                logger.error("invalid parameter");
                throw new InvalidParException();
            }
            if (authenticationHandler.isUserInRole(token, Role.ADMINISTRATOR) ||
                    authenticationHandler.isUserInRole(token, Role.TRAINER)) {
                if (training.getMapAthleteDevice() == null) {
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
        } catch (AthleteNotFoundException e) {
            throw new InvalidParException();
        } catch (DeviceNotFoundException e) {
            throw new InvalidParException();
        }
    }

    @Override
    public void modifyTraining(Training training,String token) throws InvalidTrainingException, AuthenticationException {
          if(invalidTraining(training)){
              throw new InvalidTrainingException();
          }
        try {
            if (authenticationHandler.isUserInRole(token, Role.ADMINISTRATOR) ||
                    authenticationHandler.isUserInRole(token, Role.TRAINER)) {
               trainingDAO.updateTraining(training);
            }
        } catch (InvalidTokenException e) {
            throw new AuthenticationException();
        } catch (NullParameterException e) {
            throw new InvalidTrainingException();
        } catch (TrainingNotFoundException e) {
            throw new InvalidTrainingException();
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
        if (sport == null || sport.getName() == null) {
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
