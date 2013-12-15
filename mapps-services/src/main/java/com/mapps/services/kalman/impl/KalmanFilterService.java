package com.mapps.services.kalman.impl;

import java.util.List;
import javax.ejb.Asynchronous;
import javax.ejb.EJB;
import javax.ejb.Stateless;

import org.apache.log4j.Logger;

import com.mapps.exceptions.NullParameterException;
import com.mapps.filter.impl.KalmanFilter;
import com.mapps.model.Device;
import com.mapps.model.ProcessedDataUnit;
import com.mapps.model.RawDataUnit;
import com.mapps.model.Training;
import com.mapps.persistence.ProcessedDataUnitDAO;
import com.mapps.persistence.RawDataUnitDAO;
import com.mapps.services.kalman.FilterService;import com.mapps.services.kalman.impl.exception.InvalidProcessedDataUnit;

/**
 *
 */
@Stateless(name = "KalmanFilterService")
public class KalmanFilterService implements FilterService{
    Logger logger = Logger.getLogger(KalmanFilterService.class);

    @EJB(beanName = "RawDataUnitDAO")
    private RawDataUnitDAO rawDataUnitDAO;
    @EJB(beanName = "ProcessedDataUnitDAO")
    private ProcessedDataUnitDAO processedDataUnitDAO;

    @Asynchronous
    public void handleData(RawDataUnit rawDataUnit, Device device, Training training){
        if (!rawDataUnitDAO.initialConditionsSatisfied(training, device)){
            logger.info("Initial Conditions not satisfied yet");
        }
        List<RawDataUnit> initalConditions = rawDataUnitDAO.getInitialConditions(training, device);
        KalmanFilter kalmanFilter = new KalmanFilter.Builder(training, device, rawDataUnit)
                                                            .initialConditions(initalConditions).build();
        kalmanFilter.process();
        List<ProcessedDataUnit> processedDataUnits = kalmanFilter.getResults();
        try {
            saveProcessedData(processedDataUnits);
        } catch (NullParameterException e) {
            logger.error("Invalid processed data unit");
            throw new InvalidProcessedDataUnit();
        }
    }

    private void saveProcessedData(List<ProcessedDataUnit> processedDataUnits) throws NullParameterException {
        for (ProcessedDataUnit data : processedDataUnits){
            processedDataUnitDAO.addProcessedDataUnit(data);
        }
    }


}
