package com.mapps.services.report;

import com.mapps.model.Athlete;
import com.mapps.model.ProcessedDataUnit;
import com.mapps.model.Training;

import javax.ejb.Local;
import java.util.List;

/**
 *
 *
 */
@Local
public interface ReportService {

  List<ProcessedDataUnit> getTrainingsReport(Training training, String token);

  List<ProcessedDataUnit> getAthleteStats(Training training,Athlete athlete,String token);

  List<Integer> getThresholds(Training training, String token);
}
