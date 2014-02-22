package com.mapps.services.trainer;

import java.util.List;
import javax.ejb.Local;

import com.mapps.exceptions.NullParameterException;
import com.mapps.model.Athlete;
import com.mapps.model.Device;
import com.mapps.model.Institution;
import com.mapps.model.Sport;
import com.mapps.model.Training;
import com.mapps.services.trainer.exceptions.AuthenticationException;
import com.mapps.services.trainer.exceptions.InvalidAthleteException;
import com.mapps.services.trainer.exceptions.InvalidDeviceException;
import com.mapps.services.trainer.exceptions.InvalidParameterException;
import com.mapps.services.trainer.exceptions.InvalidSportException;
import com.mapps.services.trainer.exceptions.InvalidTrainingException;


/**
 * Interface that defines the interactions of a trainer with the system. The trainer is the actor of the system
 * that can perform most of the actions on the system.
 */
@Local
public interface TrainerService {
    /**
     * Starts the given training.
     *
     * @param training the training to be started.
     * @param token the identifier of the session.
     * @throws InvalidTrainingException when the training passed doesn't exists on the system.
     * @throws AuthenticationException when the user doesn't have the necessary permission to perform this action.
     */
    void startTraining(Training training, String token) throws InvalidTrainingException, AuthenticationException;

    /**
     * Ends a given training.
     *
     * @param training the training to be ended.
     * @param token
     * @throws InvalidTrainingException when the training passed doesn't exists on the system.
     * @throws AuthenticationException when the user doesn't have the necessary permission to perform this action.
     */
    void stopTraining(Training training, String token) throws InvalidTrainingException, AuthenticationException;

    /**
     * Adds an athlete to the system.
     *
     * @param athlete the athlete to be added.
     * @param token the identifier of the system.
     * @throws InvalidAthleteException when the athlete passed doesn't exists on the system.
     * @throws AuthenticationException when the user doesn't have the necessary permission to perform this action.
     */
    void addAthlete(Athlete athlete, String token) throws InvalidAthleteException, AuthenticationException;

    /**
     * Adds an athlete to a specific training.
     *
     * @param trainingName the identifier of the training.
     * @param dirDevice the low direction of a device.
     * @param idAthlete the identifier of the athlete.
     * @param token the identifier of the session.
     * @throws InvalidParameterException when one of the parameters passed is not valid.
     * @throws AuthenticationException when the user doesn't have the necessary permission to perform this action.
     */
    void addAthleteToTraining(String trainingName, String dirDevice, String idAthlete, String token) throws InvalidParameterException, AuthenticationException;

    /**
     * Modifies the given athlete on the system.
     *
     * @param athlete the athlete to be modified.
     * @param token the identifier of the session.
     * @throws InvalidAthleteException when the given athlete is not on the system.
     * @throws AuthenticationException when the user doesn't have the necessary permission to perform this action.
     */
    void modifyAthlete(Athlete athlete, String token) throws InvalidAthleteException, AuthenticationException;

    /**
     * Deletes an athlete of the system.
     *
     * @param athlete the athlete to be deleted.
     * @param token the identifier of the session.
     * @throws InvalidAthleteException when the given athlete is not on the system.
     * @throws AuthenticationException when the user doesn't have the necessary permission to perform this action.
     */
    void deleteAthlete(Athlete athlete, String token) throws InvalidAthleteException, AuthenticationException;

    /**
     * Adds a sport to the system.
     *
     * @param sport the sport to be added.
     * @param token the identifier of the system.
     * @throws InvalidSportException when the given sport is already on the system.
     * @throws AuthenticationException when the user doesn't have the necessary permission to perform this action.
     */
    void addSport(Sport sport, String token) throws InvalidSportException, AuthenticationException;

    /**
     * Programs a training to be started in the feature.
     *
     * @param training the training to be programmed.
     * @param token the identifier of the session.
     * @throws AuthenticationException when the user doesn't have the necessary permission to perform this action.
     * @throws InvalidTrainingException when the training to be programmed is not valid.
     */
    void addTraining(Training training, String token) throws AuthenticationException, InvalidTrainingException;

    /**
     * @param sportName the name of the sport
     * @return the sport with the given name.
     */
    Sport getSportByName(String sportName);

    /**
     * Gets an athlete of the system with the given identifier.
     *
     * @param idDocument the identifier of the athlete.
     * @return the athlete identified by idDocument
     * @throws InvalidAthleteException when there is no athlete with the given identifier.
     */
    Athlete getAthleteByIdDocument(String idDocument) throws InvalidAthleteException;

    /**
     * Gets the device of the given direction.
     *
     * @param dirDevice the direction of the xbee device.
     * @return the device with the given direction.
     * @throws InvalidDeviceException there is no device with the given identifier.
     */
    public Device getDeviceByDir(String dirDevice) throws InvalidDeviceException;

    /**
     * Gets the training of the given name.
     *
     * @param token the identifier of the session.
     * @param name the identifier of the training.
     * @return the training of the given identifier.
     * @throws InvalidTrainingException when there is no training in the system with the identifier given.
     * @throws AuthenticationException when the user doesn't have the necessary permission to perform this action.
     * @throws NullParameterException when one of the given parameters is not valid.
     */
    public Training getTrainingByName(String token, String name) throws InvalidTrainingException, AuthenticationException, NullParameterException;

    /**
     * @return all the athletes of the system.
     */
    public List<Athlete> getAllAthletes();

    /**
     * @param instName the name of the institution.
     * @return all athletes of the given institution.
     */
    public List<Athlete> getAllAthletesOfInstitution(String instName);

    /**
     * @param id the idrntifier of the device on the system.
     * @return the device in the system with the given identifier.
     * @throws InvalidDeviceException
     */
    public Device getDeviceById(long id) throws InvalidDeviceException;

    /**
     * Gets all the trainings that are editable for the user of the token.
     *
     * @param token the identifier of the session.
     * @return a list of trainings that are editable by the user of the token.
     * @throws AuthenticationException when the user doesn't have the necessary permission to perform this action.
     */
    List<Training> getAllEditableTrainings(String token) throws AuthenticationException;

    /**
     * Modifies a training of the system.
     *
     * @param training the training to be modified.
     * @param token the identifier of the session.
     * @throws InvalidTrainingException when the training passed is not in the system.
     * @throws AuthenticationException when the user doesn't have the necessary permission to perform this action.
     */
    public void modifyTraining(Training training,String token) throws InvalidTrainingException, AuthenticationException;

    /**
     * @param institution the institution of the user that is requesting the operation.
     * @return true if there is a training taking place for that institution, false otherwise.
     */
    public boolean thereIsAStartedTraining(Institution institution);
}
