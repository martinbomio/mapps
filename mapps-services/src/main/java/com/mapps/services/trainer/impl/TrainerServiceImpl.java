package com.mapps.services.trainer.impl;

import javax.ejb.EJB;
import javax.ejb.Stateless;

import org.apache.log4j.Logger;

import com.mapps.model.Athlete;
import com.mapps.model.Device;
import com.mapps.model.Sport;
import com.mapps.model.Training;
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

    @Override
    public void startTraining(Training training, String token) {

    }

    @Override
    public void stopTraining(Training training, String token) {

    }

    @Override
    public void addAthlete(Athlete athlete, String token) {

    }

    @Override
    public void addAthleteToTraining(Training training, Device device, Athlete athlete, String token) {

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
