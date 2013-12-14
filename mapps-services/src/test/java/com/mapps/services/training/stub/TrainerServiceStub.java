package com.mapps.services.training.stub;

import com.mapps.authentificationhandler.AuthenticationHandler;
import com.mapps.persistence.AthleteDAO;
import com.mapps.persistence.DeviceDAO;
import com.mapps.persistence.SportDAO;
import com.mapps.persistence.TrainingDAO;
import com.mapps.services.trainer.impl.TrainerServiceImpl;

/**
 * .
 */
public class TrainerServiceStub extends TrainerServiceImpl{

    public void setAuthenticationHandler(AuthenticationHandler auth){
        this.authenticationHandler = auth;
    }
    public void setTrainingDAO(TrainingDAO trainingDAO){
        this.trainingDAO=trainingDAO;

    }
    public void setAthleteDAO(AthleteDAO athleteDAO){
        this.athleteDAO=athleteDAO;

    }
    public void setDeviceDAO(DeviceDAO deviceDAO){
        this.deviceDAO=deviceDAO;

    }
    public void setSportDAO(SportDAO sportDAO){

    }
    public SportDAO getSportDAO(){
        return this.sportDAO;

    }

}
