package com.mapps.services.report;

import java.util.List;
import javax.ejb.Local;

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

    List<ProcessedDataUnit> getTrainingsReport(Training training, String token);

    List<ProcessedDataUnit> getAthleteStats(String trainingID, String AthleteCI, String token) throws AuthenticationException, InvalidTrainingException, InvalidAthleteException;

    List<Integer> getThresholds(Training training, String token);
}
