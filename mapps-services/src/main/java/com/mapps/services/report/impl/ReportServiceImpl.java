package com.mapps.services.report.impl;

import com.mapps.model.Athlete;
import com.mapps.model.ProcessedDataUnit;
import com.mapps.model.Training;
import com.mapps.persistence.ReportDAO;
import com.mapps.persistence.TrainingDAO;
import com.mapps.services.report.ReportService;
import org.apache.log4j.Logger;

import javax.ejb.EJB;
import javax.ejb.Stateless;
import java.util.List;

/**
 *
 *
 */
@Stateless(name="ReportServiceImpl")
public class ReportServiceImpl implements ReportService{


    Logger logger = Logger.getLogger(ReportServiceImpl.class);
    @EJB(name="TrainingDAO")
    TrainingDAO trainingDAO;
    @EJB(name="ReportDAO")
    ReportDAO reportDAO;

    @Override
    public List<ProcessedDataUnit> getTrainingsReport(Training training, String token) {
        return null;  //To change body of implemented methods use File | Settings | File Templates.
    }

    @Override
    public List<ProcessedDataUnit> getAthleteStats(Training training,Athlete athlete, String token) {
        return null;  //To change body of implemented methods use File | Settings | File Templates.
    }

    @Override
    public List<Integer> getThresholds(Training training, String token) {
        return null;  //To change body of implemented methods use File | Settings | File Templates.
    }
}
