package com.mapps.services.report.impl;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import javax.ejb.EJB;
import javax.ejb.Stateless;

import com.mapps.exceptions.InvalidReportException;
import org.apache.log4j.Logger;

import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.mapps.authentificationhandler.AuthenticationHandler;
import com.mapps.authentificationhandler.exceptions.InvalidTokenException;
import com.mapps.exceptions.AthleteNotFoundException;
import com.mapps.exceptions.NullParameterException;
import com.mapps.exceptions.TrainingNotFoundException;
import com.mapps.model.Athlete;
import com.mapps.model.Permission;
import com.mapps.model.ProcessedDataUnit;
import com.mapps.model.Report;
import com.mapps.model.Role;
import com.mapps.model.Training;
import com.mapps.model.User;
import com.mapps.persistence.AthleteDAO;
import com.mapps.persistence.ProcessedDataUnitDAO;
import com.mapps.persistence.ReportDAO;
import com.mapps.persistence.TrainingDAO;
import com.mapps.services.report.ReportService;
import com.mapps.services.report.exceptions.AuthenticationException;
import com.mapps.services.trainer.exceptions.InvalidAthleteException;
import com.mapps.services.trainer.exceptions.InvalidTrainingException;

/**
 *
 *
 */
@Stateless(name = "ReportService")
public class ReportServiceImpl implements ReportService {


    Logger logger = Logger.getLogger(ReportServiceImpl.class);
    @EJB(name = "TrainingDAO")
    TrainingDAO trainingDAO;
    @EJB(name = "ReportDAO")
    ReportDAO reportDAO;
    @EJB(name = "AthleteDAO")
    AthleteDAO athleteDAO;
    @EJB(name = "ProcessedDataUnitDAO")
    ProcessedDataUnitDAO processedDataUnitDAO;
    @EJB(name = "AuthenticationHandler")
    AuthenticationHandler authenticationHandler;

    @Override
    public Map<Athlete, List<ProcessedDataUnit>> getTrainingsReport(String trainingID, String token) throws InvalidTrainingException, AuthenticationException {
        Map<Athlete, List<ProcessedDataUnit>> dataMap = Maps.newHashMap();
        try {
            Training training = trainingDAO.getTrainingByName(trainingID);
            for (Athlete athlete : training.getMapAthleteDevice().keySet()) {
                List<ProcessedDataUnit> dataUnits = getAthleteStats(trainingID, athlete.getIdDocument(), token);
                dataMap.put(athlete, dataUnits);
            }
            return dataMap;
        } catch (TrainingNotFoundException e) {
            logger.error("Invalid Training name");
            throw new InvalidTrainingException();
        } catch (InvalidAthleteException e) {
            logger.error("Invalid athelete");
            throw new IllegalStateException();
        }
    }

    @Override
    public List<ProcessedDataUnit> getAthleteStats(String trainingID, String athleteCI, String token) throws AuthenticationException, InvalidTrainingException, InvalidAthleteException {
        if (trainingID == null || athleteCI == null) {
            throw new IllegalArgumentException();
        }
        try {
            User user = authenticationHandler.getUserOfToken(token);
            Training training = trainingDAO.getTrainingByName(trainingID);
            Permission permission = training.getMapUserPermission().get(user);
            if (permission != Permission.CREATE && permission != Permission.READ) {
                logger.error("User has no permissions");
                throw new AuthenticationException();
            }
            Athlete athlete = athleteDAO.getAthleteByIdDocument(athleteCI);
            return processedDataUnitDAO.getProcessedDataUnitsFromAthleteInTraining(training, athlete);
        } catch (InvalidTokenException e) {
            logger.error("Invalid token");
            throw new AuthenticationException();
        } catch (TrainingNotFoundException e) {
            logger.error("Invalid Training");
            throw new InvalidTrainingException();
        } catch (AthleteNotFoundException e) {
            logger.error("Invalid Athlete");
            throw new InvalidAthleteException();
        } catch (NullParameterException e) {
            logger.error("Invalid parameters");
            throw new IllegalStateException();
        }
    }


    @Override
    public List<Integer> getThresholds(Training training, String token) {
        return null;  //To change body of implemented methods use File | Settings | File Templates.
    }
    @Override
    public Report getReport(String trainingName,String athleteId,String token) throws AuthenticationException, InvalidReportException {
         if(trainingName==null || athleteId==null || token==null){
             throw new AuthenticationException();
         }
        Report report=null;
        try {
            if (authenticationHandler.isUserInRole(token, Role.ADMINISTRATOR) ||
                    authenticationHandler.isUserInRole(token, Role.TRAINER)) {
               Athlete athlete=athleteDAO.getAthleteByIdDocument(athleteId);
               report = reportDAO.getReport(trainingName,athlete);
            }else{
                throw new AuthenticationException();
            }
            if(report==null){
              throw new InvalidReportException();
            }
            } catch (InvalidTokenException e) {
            throw new AuthenticationException();
        } catch (AthleteNotFoundException e) {
            throw new AuthenticationException();
        } catch (InvalidReportException e) {
            throw new InvalidReportException();
        }
        return report;
    }
    @Override
    public List<Report> getReportsOfTraining(String trainingName,String token) throws AuthenticationException {
        if(trainingName==null || token==null){
            throw new AuthenticationException();
        }
        List<Report> reports=new ArrayList<Report>();
        try {
            if (authenticationHandler.isUserInRole(token, Role.ADMINISTRATOR) ||
                    authenticationHandler.isUserInRole(token, Role.TRAINER)) {
              reports= reportDAO.getReportsOfTraining(trainingName);
            }
        } catch (InvalidTokenException e) {
            throw new AuthenticationException();
        }
       return reports;
    }


    @Override
    public void createTrainingReports(String trainingID, String token) throws AuthenticationException {
        if (trainingID == null || token == null) {
            throw new AuthenticationException();
        }
        try {
            if (authenticationHandler.isUserInRole(token, Role.ADMINISTRATOR) ||
                    authenticationHandler.isUserInRole(token, Role.TRAINER)) {
                Training training = trainingDAO.getTrainingByName(trainingID);
                for (Athlete athlete : training.getMapAthleteDevice().keySet()) {
                    List<ProcessedDataUnit> data = getAthleteStats(trainingID, athlete.getIdDocument(), token);
                    Report report = new Report.Builder().setAthlete(athlete)
                                                        .setTrainingName(trainingID)
                                                        .setData(data)
                                                        .build();
                    reportDAO.addReport(report);
                    if (training.getReports() == null){
                        List<Report> reports = Lists.newArrayList();
                        training.setReports(reports);
                    }
                    training.getReports().add(report);
                    trainingDAO.updateTraining(training);
                }
            } else {
                logger.error("User is not a trainer");
                throw new AuthenticationException();
            }
        } catch (InvalidTokenException e) {
            logger.error("Authentication exception");
            throw new AuthenticationException();
        } catch (TrainingNotFoundException e) {
            throw new IllegalStateException("Training not found", e);
        } catch (InvalidAthleteException e) {
            throw new IllegalStateException("Athlete not found", e);
        } catch (InvalidTrainingException e) {
            throw new IllegalStateException("Training not found", e);
        } catch (NullParameterException e) {
            throw new IllegalStateException("Wrong parameters on saving report", e);
        }
    }
}
