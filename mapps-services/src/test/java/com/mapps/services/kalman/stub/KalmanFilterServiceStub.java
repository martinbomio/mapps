package com.mapps.services.kalman.stub;

import com.mapps.persistence.ProcessedDataUnitDAO;
import com.mapps.persistence.RawDataUnitDAO;
import com.mapps.services.kalman.impl.KalmanFilterService;

/**
 *
 *
 */
public class KalmanFilterServiceStub extends KalmanFilterService{

    public void setRawDataUnitDAO(RawDataUnitDAO rdao){
        this.rawDataUnitDAO = rdao;
    }

    public void setProcessedDataUnitDAO(ProcessedDataUnitDAO pdao){
        this.processedDataUnitDAO = pdao;
    }

}
