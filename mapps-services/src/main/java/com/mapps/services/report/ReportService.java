package com.mapps.services.report;

import java.util.List;
import java.util.Map;
import javax.ejb.Local;

import com.mapps.model.Athlete;
import com.mapps.model.ProcessedDataUnit;
import com.mapps.model.Training;
import com.mapps.services.report.exceptions.AuthenticationException;
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
}
