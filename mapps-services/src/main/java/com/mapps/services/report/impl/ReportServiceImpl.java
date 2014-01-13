package com.mapps.services.report.impl;

import java.util.List;
import javax.ejb.EJB;
import javax.ejb.Stateless;

import org.apache.log4j.Logger;

import com.mapps.authentificationhandler.AuthenticationHandler;
import com.mapps.authentificationhandler.exceptions.InvalidTokenException;
import com.mapps.exceptions.AthleteNotFoundException;
import com.mapps.exceptions.NullParameterException;
import com.mapps.exceptions.TrainingNotFoundException;
import com.mapps.model.Athlete;
import com.mapps.model.ProcessedDataUnit;
import com.mapps.model.Role;
import com.mapps.model.Training;
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
    public List<ProcessedDataUnit> getTrainingsReport(Training training, String token) {
        return null;  //To change body of implemented methods use File | Settings | File Templates.
    }

    @Override
    public List<ProcessedDataUnit> getAthleteStats(String trainingID, String athleteCI, String token) throws AuthenticationException, InvalidTrainingException, InvalidAthleteException {
        if (trainingID == null || athleteCI == null) {
            throw new IllegalArgumentException();
        }
        try {
            if (!authenticationHandler.isUserInRole(token, Role.TRAINER)) {
                logger.error("User not a trainer");
                throw new AuthenticationException();
            }
            Training training = trainingDAO.getTrainingByName(trainingID);
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
}
