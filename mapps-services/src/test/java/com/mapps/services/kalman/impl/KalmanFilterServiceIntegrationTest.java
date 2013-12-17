package com.mapps.services.kalman.impl;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.util.ArrayList;
import java.util.List;

import org.junit.Before;
import org.junit.Test;
import org.mockito.Mockito;

import com.mapps.model.Device;
import com.mapps.model.RawDataUnit;
import com.mapps.model.Training;
import com.mapps.persistence.ProcessedDataUnitDAO;
import com.mapps.persistence.RawDataUnitDAO;
import com.mapps.services.kalman.stub.KalmanFilterServiceStub;

import static org.mockito.Mockito.when;

/**
 * Tests the kalman filter service and the kalman filter implementation
 */
public class KalmanFilterServiceIntegrationTest {
    private KalmanFilterServiceStub kService;
    private Training training;
    private Device device;

    @Before
    public void setup() throws Exception{
        RawDataUnitDAO rawDao = Mockito.mock(RawDataUnitDAO.class);
        ProcessedDataUnitDAO pDAO = Mockito.mock(ProcessedDataUnitDAO.class);
        this.training = Mockito.mock(Training.class);
        this.device = Mockito.mock(Device.class);
        when(rawDao.getInitialConditions(training, device)).thenReturn(getInitialCOnditions());
        this.kService = new KalmanFilterServiceStub();
        this.kService.setProcessedDataUnitDAO(pDAO);
        this.kService.setRawDataUnitDAO(rawDao);
    }

    @Test
    public void testHandleData(){

    }

    public List<RawDataUnit> getInitialCOnditions() throws Exception{
        List<RawDataUnit> rawDataUnits = new ArrayList<RawDataUnit>();
        File file = new File("src/resources/data.txt");
        BufferedReader br = new BufferedReader(new FileReader(file));
        String line;
        while((line = br.readLine()) != null){
            RawDataUnit rawDataUnit = new RawDataUnit(line);
            rawDataUnits.add(rawDataUnit);
        }
    }
}
