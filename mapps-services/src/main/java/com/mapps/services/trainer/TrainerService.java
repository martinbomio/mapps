package com.mapps.services.trainer;

import javax.ejb.Local;

import com.mapps.model.Athlete;
import com.mapps.model.Device;
import com.mapps.model.Sport;
import com.mapps.model.Training;

/**
 * Interface that defines the interactions of a trainer with the system.
 */
@Local
public interface TrainerService {

    void startTraining(Training training, String token);
    void stopTraining(Training training, String token);
    void addAthlete(Athlete athlete,String token);
    void addAthleteToTraining(Training training, Device device, Athlete athlete, String token);
    void modifyAthlete(Athlete athlete, String token);
    void deleteAthlete(Athlete athlete, String token);
    void addSport(Sport sport, String token);
}
