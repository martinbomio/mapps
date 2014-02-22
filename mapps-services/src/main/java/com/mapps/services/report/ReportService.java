package com.mapps.services.report;

import java.util.List;
import javax.ejb.Local;

import com.mapps.exceptions.InvalidReportException;
import com.mapps.model.Athlete;
import com.mapps.model.PulseReport;
import com.mapps.model.Report;
import com.mapps.model.Training;
import com.mapps.services.report.exceptions.AuthenticationException;
import com.mapps.services.report.exceptions.NoPulseDataException;

/**
 * Services defined to handle all operation with the processed data. This involves
 * the real-time data and the data of already finished trainings.
 */
@Local
public interface ReportService {

    /**
     * After a training has finished, creates a report for each athlete on the training and
     * stores it on the database.
     *
     * @param trainingID the identifier of the training.
     * @param token      the identifier of the session.
     * @throws AuthenticationException when the user doesn't have the necessary permission to perform this action.
     */
    void createTrainingReports(String trainingID, String token) throws AuthenticationException;

    /**
     * After a training has finished, creates a report for each athlete on the training and
     * stores it on the database.
     *
     * @param trainingID the identifier of the training.
     * @param token the identifier of the session
     * @throws AuthenticationException when the user doesn't have the necessary permission to perform this action.
     */
    void createTrainingPulseReports(String trainingID, String token) throws AuthenticationException;

    /**
     * Gets a report of an athlete on an already finished training.
     *
     * @param trainingName the identifier of the training.
     * @param athleteId the identifier of the athlete on the training.
     * @param token the identifier of the session.
     * @return the report of the athlete on the training specified.
     * @throws AuthenticationException when the user doesn't have the necessary permission to perform this action.
     * @throws InvalidReportException when there is no report for the athlete on the training or when there is no
     * athlete or training with the identifiers passed.
     */
    public Report getReport(String trainingName, String athleteId, String token) throws AuthenticationException, InvalidReportException;

    /**
     * Gets a pulse report of an athlete on an already finished training. The pulse report has the
     * information of the pulse of an athlete.
     *
     * @param trainingName the identifier of the training.
     * @param athleteId the identifier of the athlete on the training.
     * @param token the identifier of the session.
     * @return the pulse report of the athlete on the training specified.
     * @throws AuthenticationException when the user doesn't have the necessary permission to perform this action.
     * @throws InvalidReportException when there is no report for the athlete on the training or when there is no
     * athlete or training with the identifiers passed.
     */
    public PulseReport getPulseReport(String trainingName, String athleteId, String token) throws AuthenticationException;

    /**
     * Gets all the reports of a training. This means the individual reports of all athletes on a
     * training.
     *
     * @param trainingName the identifier of the training.
     * @param token the identifier of the session.
     * @return all the reports of the training ifentfied by trainingName.
     * @throws AuthenticationException when the user doesn't have the necessary permission to perform this action.
     */
    public List<Report> getReportsOfTraining(String trainingName, String token) throws AuthenticationException;

    /**
     * Gets all the pulse reports of a training. This means the individual reports of all athletes on a
     * training.
     *
     * @param trainingName the identifier of the training.
     * @param token the identifier of the session.
     * @return all the pulse reports of the training ifentfied by trainingName.
     * @throws AuthenticationException when the user doesn't have the necessary permission to perform this action.
     */
    public List<PulseReport> getPulseReportsOfTraining(String trainingName, String token) throws AuthenticationException;

    /**
     * Gets a pulse report of an athlete on a training that is taking place,
     * this means that the data is real-time data.
     *
     * @param training the training that is taking place.
     * @param athlete the athlete of the training.
     * @param reload flag that determines if the data passed is only the one that haven't been read
     *               or it is all the data of the on curse training.
     * @param token the identifier of the session.
     * @return the pulse report of the athlete on the training.
     * @throws AuthenticationException when the user doesn't have the necessary permission to perform this action.
     * @throws NoPulseDataException when there is no pulse data for the athelete on the training yet.
     */
    PulseReport getAthletePulseStats(Training training, Athlete athlete, boolean reload, String token) throws AuthenticationException, NoPulseDataException;

    /**
     * Gets all the pulse reports of a training that is taking place,
     * this means that the data is real-time data.
     *
     * @param trainingName the identifier of the training that is taking place.
     * @param token the identifier of the session.
     * @return all the pulse reports for a training.
     * @throws AuthenticationException when there is no pulse data for the athelete on the training yet.
     */
    List<PulseReport> getPulseDataOfTraining(String trainingName, String token) throws AuthenticationException;
}
