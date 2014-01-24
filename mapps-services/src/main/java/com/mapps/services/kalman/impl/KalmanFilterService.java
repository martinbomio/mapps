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
import com.mapps.model.GPSData;
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
        checkGPSCorrect(rawDataUnit);
        Filter kalmanFilter = null;
        try {
            KalmanState lastState = kalmanStateDAO.getLastState(training, device);
            boolean isFirstIteration = lastState == null;
            List<RawDataUnit> initalConditions = null;
            if (isFirstIteration){
                initalConditions = rawDataUnitDAO.getInitialConditions(training, device);
            }
            ProcessedDataUnit lastXpost = processedDataUnitDAO.getLastProcessedDataUnit(training,device);
            kalmanFilter = new KalmanFilter.Builder(training, device, rawDataUnit)
                                           .initialConditions(initalConditions)
                                           .setLastXPos(lastXpost)
                                           .setIsFirstIteration(isFirstIteration)
                                           .setState(lastState)
                                           .build();
            kalmanFilter.process();
            saveKalmanState(kalmanFilter.getNewState());
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

    private void checkGPSCorrect(RawDataUnit rawDataUnit) {
        GPSData gpsData = rawDataUnit.getGpsData().get(0);
        if (gpsData.getLatitude() == 0 || gpsData.getLongitude() == 0){
            logger.error("Latitud or Longitud are 0");
            rawDataUnit.setCorrect(false);
        }
        if (String.valueOf(gpsData.getLatitude()).length() != 9 || String.valueOf(gpsData.getLongitude()).length() != 9){
            logger.info("Wrong gps Data, using previous one");
            rawDataUnit.setCorrect(false);
        }
    }

    public void saveProcessedData(List<ProcessedDataUnit> processedDataUnits) throws NullParameterException {
        for (ProcessedDataUnit data : processedDataUnits){
            processedDataUnitDAO.addProcessedDataUnit(data);
        }
    }

    /**
     * This method was created for testing
     * @param state
     * @throws NullParameterException
     */
    public void saveKalmanState(KalmanState state) throws NullParameterException {
        kalmanStateDAO.addKalmanState(state);
    }


}
