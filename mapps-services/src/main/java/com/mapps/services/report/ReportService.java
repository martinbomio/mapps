package com.mapps.services.report;

import java.util.List;
import java.util.Map;
import javax.ejb.Local;

import com.mapps.exceptions.InvalidReportException;
import com.mapps.model.Athlete;
import com.mapps.model.ProcessedDataUnit;
import com.mapps.model.PulseReport;
import com.mapps.model.Report;
import com.mapps.model.Training;
import com.mapps.services.report.exceptions.AuthenticationException;
import com.mapps.services.report.exceptions.NoPulseDataException;
import com.mapps.services.trainer.exceptions.InvalidAthleteException;
import com.mapps.services.trainer.exceptions.InvalidTrainingException;

/**
 *
 *
 */
@Local
public interface ReportService {

    Map<Athlete, List<ProcessedDataUnit>> getTrainingsReport(String trainingID, String token) throws InvalidTrainingException, AuthenticationException;

    List<ProcessedDataUnit> getAthleteStats(String trainingID, String AthleteCI, String token) throws AuthenticationException, InvalidTrainingException, InvalidAthleteException;

    List<Integer> getThresholds(Training training, String token);

    /**
     * After a training is finished, creates a report for each athelte on the training and
     * stores it on the database.
     *
     * @param trainingID the training ID
     * @param token      the identifier of the session.
     */
    void createTrainingReports(String trainingID, String token) throws AuthenticationException;

    void createTrainingPulseReports(String trainingID, String token) throws AuthenticationException;

    public Report getReport(String trainingName, String athleteId, String token) throws AuthenticationException, InvalidReportException;

    public List<Report> getReportsOfTraining(String trainingName, String token) throws AuthenticationException;

    public List<PulseReport> getPulseReportsOfTraining(String trainingName, String token) throws AuthenticationException;

    PulseReport getAthletePulseStats(String trainingID, String athleteCI, boolean reload, String token) throws AuthenticationException, NoPulseDataException;

    List<PulseReport> getPulseDataOfTraining(String trainingName, String token) throws AuthenticationException;
}
