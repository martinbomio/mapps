package com.mapps.persistence;

import java.util.Date;
import java.util.List;
import javax.ejb.Local;

import com.mapps.exceptions.NullParameterException;
import com.mapps.exceptions.TrainingAlreadyExistException;
import com.mapps.exceptions.TrainingNotFoundException;
import com.mapps.model.Athlete;
import com.mapps.model.Training;
import com.mapps.model.User;

/**
 * TrainingDAO interface
 */
@Local
public interface TrainingDAO {

    /**
     * This method adds a Training to the database.
     * @param training - The Training added to the database
     * @throws TrainingAlreadyExistException
     */
    void addTraining(Training training) throws TrainingAlreadyExistException, NullParameterException;

    /**
     * This method deletes a Training from the database.
     * @param trainingId - The Training identification id to find the Training to delete
     * @throws TrainingNotFoundException - If the Training is not in the database
     */
    void deleteTraining(Long trainingId) throws TrainingNotFoundException;

    /**
     * This method updates a Training in the database.
     * @param training - The Training identification id to find the Training to update
     * @throws TrainingNotFoundException  - If the Training is not in the database
     */
    void updateTraining(Training training) throws TrainingNotFoundException, NullParameterException;

    /**
     * This method gets a Training from the database
     * @param trainingId - the Training identification id to find the Training in the database
     * @return - The Training in the database
     * @throws TrainingNotFoundException - If the Training is not in the database
     */
    Training getTrainingById (Long trainingId) throws TrainingNotFoundException;



    /**
     * This method gets a Training from the database
     * @param trainingDate - the Training identification date to find the Training in the database
     * @return - The Training in the database
     * @throws TrainingNotFoundException - If the Training is not in the database
     */
    Training getTrainingByDate (Long trainingDate) throws TrainingNotFoundException;

    /**
     * This method gets a Training from the database
     * @param trainingName - the Training identification date to find the Training in the database
     * @return - The Training in the database
     * @throws TrainingNotFoundException - If the Training is not in the database
     */
    public Training getTrainingByName(String trainingName) throws TrainingNotFoundException;

/**
 * This method returns true if the training has started
 * @param name - the Training identification date to find the Training in the database
 * @return - True if the training started
 * @throws TrainingNotFoundException - If the Training is not in the database
  */
    public boolean isTrainingStarted(String name) throws TrainingNotFoundException;

    /**
     * This method returns the training of a device and a date
     * @param dirLow - the Device identification date to find the Training in the database
     * @param date - the Date identification of the training
     * @return - the training of the device and the date
     * @throws TrainingNotFoundException - If the Training is not in the database
     * @throws TrainingNotFoundException - If the Training is not in the database
     */

    public List<Training> getTrainingOfDevice(String dirLow,Date date);


    /**
     * This method returns the training of a athlete
     * @param athlete - the Name identification to find the Athlete in the database
     * @return - the training of the athlete
     * @throws TrainingNotFoundException - If the Training is not in the database
     */

    public List<Training> getTrainingOfAthlete(Athlete athlete);

    /**
     * This method returns the training of a athlete
     * @param name - the Name identification to find the institution in the database
     * @return - the trainings of the institution
     */

    public List<Training> getTrainingOfInstitution(String name);

    /**
     * Gets all the trainings from the database
     * @return a list containing all the trainings
     */
    public List<Training> getAllTrainings();

    /**
     * Returns all the trainigs that the user can edit
     * @param user The user with create permissions on the trainings.
     * @return list containing the editable trainings.
     */
    public List<Training> getAllEditableTrainings(User user) throws NullParameterException;

}
