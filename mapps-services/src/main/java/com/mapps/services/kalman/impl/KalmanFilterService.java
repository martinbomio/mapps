package com.mapps.services.kalman.impl;

import java.util.List;
import javax.ejb.EJB;
import javax.ejb.Stateless;

import org.apache.log4j.Logger;

import com.mapps.exceptions.NullParameterException;
import com.mapps.filter.Filter;
import com.mapps.filter.impl.KalmanFilter;
import com.mapps.filter.impl.exceptions.InvalidCoordinatesException;
import com.mapps.model.Device;
import com.mapps.model.KalmanState;
import com.mapps.model.ProcessedDataUnit;
import com.mapps.model.RawDataUnit;
import com.mapps.model.Training;
import com.mapps.persistence.KalmanStateDAO;
import com.mapps.persistence.ProcessedDataUnitDAO;
import com.mapps.persistence.RawDataUnitDAO;
import com.mapps.services.kalman.FilterService;

/**
 *
 */
@Stateless(name = "KalmanFilterService")
public class KalmanFilterService implements FilterService{
    Logger logger = Logger.getLogger(KalmanFilterService.class);

    @EJB(beanName = "RawDataUnitDAO")
    protected RawDataUnitDAO rawDataUnitDAO;
    @EJB(beanName = "ProcessedDataUnitDAO")
    protected ProcessedDataUnitDAO processedDataUnitDAO;
    @EJB(beanName = "KalmanStateDAO")
    protected KalmanStateDAO kalmanStateDAO;

    public void handleData(RawDataUnit rawDataUnit, Device device, Training training){
        if (!rawDataUnitDAO.initialConditionsSatisfied(training, device)){
            logger.info("Initial Conditions not satisfied yet");
            return;
        }
        List<RawDataUnit> initalConditions = rawDataUnitDAO.getInitialConditions(training, device);
        Filter kalmanFilter = null;
        try {
            KalmanState lastState = kalmanStateDAO.getLastState(training, device);
            boolean isFirstIteration = lastState == null;
            ProcessedDataUnit lastXpost = processedDataUnitDAO.getLastProcessedDataUnit(training,device);
            kalmanFilter = new KalmanFilter.Builder(training, device, rawDataUnit)
                                           .initialConditions(initalConditions)
                                           .setLastXPos(lastXpost)
                                           .setIsFirstIteration(isFirstIteration)
                                           .build();
            kalmanFilter.process();
            List<ProcessedDataUnit> processedDataUnits = kalmanFilter.getResults();
            saveProcessedData(processedDataUnits);
        } catch (InvalidCoordinatesException e) {
            logger.error("Initial Latitud or Longitud are 0");
            return;
        } catch (NullParameterException e) {
            logger.error("Invalid processed data unit");
            return;
        }
    }

    private void saveProcessedData(List<ProcessedDataUnit> processedDataUnits) throws NullParameterException {
        for (ProcessedDataUnit data : processedDataUnits){
            processedDataUnitDAO.addProcessedDataUnit(data);
        }
    }


}
