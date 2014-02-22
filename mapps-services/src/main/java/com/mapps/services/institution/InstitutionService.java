package com.mapps.services.institution;

import java.util.List;
import javax.ejb.Local;

import com.mapps.model.Device;
import com.mapps.model.Institution;
import com.mapps.model.Training;
import com.mapps.model.User;
import com.mapps.services.institution.exceptions.AuthenticationException;
import com.mapps.services.institution.exceptions.InvalidInstitutionException;
import com.mapps.services.user.exceptions.InvalidUserException;

/**
 * Defines methods that are involves the institutions. e.g. retrieving the user of an institution.
 * This services was separated as a independent service because it grew in importance and functionality.
 */
@Local
public interface InstitutionService {

    /**
     * Creates and persist an Institution into the system
     *
     * @param institution Institution to add in the system.
     * @param token       that represent the session.
     */
    void createInstitution(Institution institution, String token) throws AuthenticationException, InvalidInstitutionException;

    /**
     * Deletes an Institution from the system
     *
     * @param institution Institution to delete in the system.
     * @param token       that represent the session.
     */
    void deleteInstitution(Institution institution, String token) throws AuthenticationException, InvalidInstitutionException;

    /**
     * Updates an Institution
     *
     * @param institution Institution to update.
     * @param token       that represent the session.
     */
    void updateInstitution(Institution institution, String token) throws AuthenticationException, InvalidInstitutionException;

    /**
     * @return all the institutions of the system. Doesn't need a token because only ADMIN can call this service.
     */
    public List<Institution> getAllInstitutions();

    /**
     * Gets an institution by its name.
     *
     * @param name the name of the institution.
     * @return the institution which has the name passed by parameter.
     */
    public Institution getInstitutionByName(String name);

    /**
     * Gets the institution of a user.
     *
     * @param username the user username.
     * @return the institution of the user which has the username passed by parameter.
     * @throws InvalidUserException when the user doesn't have the necessary permission to perform this action.
     */
    public Institution getInstitutionOfUser(String username) throws InvalidUserException;

    /**
     * Gets a Institution by its id on the database.
     *
     * @param token the identifier of the session.
     * @param id    the id of the Institution.
     * @return the Institution with the id passed by parameter
     * @throws InvalidInstitutionException when there is no institution with the id passed by parameter.
     * @throws AuthenticationException     when the user doesn't have the necessary permission to perform this action.
     */
    Institution getInstitutionByID(String token, long id) throws InvalidInstitutionException, AuthenticationException;

    /**
     * Gets all devices of an Institution.
     *
     * @param token the identifier of the session.
     * @return all the devices of the institution of the user of the token.
     * @throws AuthenticationException when the user doesn't have the necessary permission to perform this action.
     */
    List<Device> getDeviceOfInstitution(String token) throws AuthenticationException;

    /**
     * Gets all the training that where program and are ready to start for a Institution.
     *
     * @param token the identifier of the session.
     * @return all the training ready to start of the Institution of the user of the tken.
     * @throws AuthenticationException when the user doesn't have the necessary permission to perform this action.
     */
    List<Training> getTraingsToStartOfInstitution(String token) throws AuthenticationException;

    /**
     * Gets all the users of the institution of the user of the token.
     *
     * @param token identifier of the session.
     * @return the users of the institution of the user of the token.
     * @throws AuthenticationException when the user doesn't have the necessary permission to perform this action.
     */
    List<User> getUsersOfInstitution(String token) throws AuthenticationException;

    /**
     * Gets the training that is started for a Institution. Only one training can be started for
     * a Institution.
     *
     * @param token the identifier of the session.
     * @return the training that is started for the institution of the user of the token.
     * @throws AuthenticationException when the user doesn't have the necessary permission to perform this action.
     */
    Training getStartedTrainingOfInstitution(String token) throws AuthenticationException;

    /**
     * Gets all the trainings that are finish for the institution of the user of the token.
     *
     * @param token the identifier of the session.
     * @return all the trainings that finished for the institution of the user of the token.
     * @throws AuthenticationException when the user doesn't have the necessary permission to perform this action.
     */
    List<Training> getFinishedTrainingsOfInstitution(String token) throws AuthenticationException;
}
