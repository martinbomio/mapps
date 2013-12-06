package com.mapps.persistence;

import com.mapps.exceptions.NullParameterException;
import com.mapps.exceptions.TrainingAlreadyExistException;
import com.mapps.exceptions.TrainingNotFoundException;
import com.mapps.model.Athlete;
import com.mapps.model.Device;
import com.mapps.model.Training;

import javax.ejb.Local;
import java.util.Date;

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
     * This method returns a training of a device and a date
     * @param dirLow - the Device identification date to find the Training in the database
     * @param date - the Date identification of the training
     * @return - the training of the device and the date
     * @throws TrainingNotFoundException - If the Training is not in the database
     * @throws TrainingNotFoundException - If the Training is not in the database
     */

    public Training getTrainingOfDevice(String dirLow,Date date) throws TrainingNotFoundException;
}
