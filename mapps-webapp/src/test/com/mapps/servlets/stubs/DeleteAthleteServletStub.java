package com.mapps.servlets.stubs;

import com.mapps.services.trainer.TrainerService;
import com.mapps.servlets.DeleteAthleteServlet;

/**
 *
 *
 */
public class DeleteAthleteServletStub extends DeleteAthleteServlet{
    public void setTrainerService(TrainerService trainerService){
        this.trainerService = trainerService;
    }
}
