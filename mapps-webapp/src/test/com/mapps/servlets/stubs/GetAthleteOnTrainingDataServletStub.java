package com.mapps.servlets.stubs;

import com.mapps.services.report.ReportService;
import com.mapps.services.trainer.TrainerService;
import com.mapps.servlets.GetAthleteOnTrainingDataServlet;

/**
 *
 *
 */
public class GetAthleteOnTrainingDataServletStub extends GetAthleteOnTrainingDataServlet {
    public void setReportService(ReportService report){
        this.reportService = report;
    }
    public void setTrainerService(TrainerService trainerService){
        this.trainerService = trainerService;
    }
}
