package com.mapps.services.trainer;

import javax.ejb.Local;

import com.mapps.model.Athlete;
import com.mapps.model.Device;
import com.mapps.model.Sport;
import com.mapps.model.Training;
import com.mapps.services.trainer.exceptions.*;

/**
 * Interface that defines the interactions of a trainer with the system.
 */
@Local
public interface TrainerService {

    void startTraining(Training training, String token) throws InvalidTrainingException, AuthenticationException;
    void stopTraining(Training training, String token) throws InvalidTrainingException, AuthenticationException;
    void addAthlete(Athlete athlete,String token) throws InvalidAthleteException, AuthenticationException;
    void addAthleteToTraining(Training training, Device device, Athlete athlete, String token) throws invalidParameterException, AuthenticationException;
    void modifyAthlete(Athlete athlete, String token) throws InvalidAthleteException, AuthenticationException;
    void deleteAthlete(Athlete athlete, String token) throws InvalidAthleteException, AuthenticationException;
    void addSport(Sport sport, String token) throws InvalidSportException, AuthenticationException;
}
