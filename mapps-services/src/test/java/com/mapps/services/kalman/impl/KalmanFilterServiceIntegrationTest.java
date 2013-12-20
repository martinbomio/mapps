package com.mapps.services.kalman.impl;

import junit.framework.Assert;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.util.ArrayList;
import java.util.List;

import org.junit.Before;
import org.junit.Test;
import org.mockito.ArgumentCaptor;
import org.mockito.Captor;
import org.mockito.Mockito;

import com.mapps.model.Device;
import com.mapps.model.ProcessedDataUnit;
import com.mapps.model.RawDataUnit;
import com.mapps.model.Training;
import com.mapps.persistence.KalmanStateDAO;
import com.mapps.persistence.ProcessedDataUnitDAO;
import com.mapps.persistence.RawDataUnitDAO;
import com.mapps.services.kalman.stub.KalmanFilterServiceStub;

import static org.mockito.Mockito.when;

/**
 * Tests the kalman filter service and the kalman filter implementation
 */
public class KalmanFilterServiceIntegrationTest {
    @Captor
    ArgumentCaptor<List<ProcessedDataUnit>> captor;
    private KalmanFilterServiceStub kService;
    private ProcessedDataUnitDAO pDAO;
    private Training training;
    private Device device;

    @Before
    public void setup() throws Exception{
        RawDataUnitDAO rawDao = Mockito.mock(RawDataUnitDAO.class);
        this.pDAO = Mockito.mock(ProcessedDataUnitDAO.class);
        KalmanStateDAO sDAO = Mockito.mock(KalmanStateDAO.class);
        ProcessedDataUnit pDataUnit = Mockito.mock(ProcessedDataUnit.class);
        this.training = Mockito.mock(Training.class);
        this.device = Mockito.mock(Device.class);
        when(rawDao.getInitialConditions(training, device)).thenReturn(getRawData("src/test/resources/testdata/initial_data.txt"));
        when(rawDao.initialConditionsSatisfied(training,device)).thenReturn(true);
        when(sDAO.getLastState(training, device)).thenReturn(null);
        when(pDAO.getLastProcessedDataUnit(training,device)).thenReturn(pDataUnit);
        this.kService = new KalmanFilterServiceStub();
        this.kService.setProcessedDataUnitDAO(pDAO);
        this.kService.setRawDataUnitDAO(rawDao);
        this.kService.setKalmanStateDAO(sDAO);
    }

    @Test
    public void testHandleData() throws Exception{
        when(training.getLatOrigin()).thenReturn(34523361L);
        when(training.getLongOrigin()).thenReturn(56025285L);
        RawDataUnit rData = new RawDataUnit("G:345255840/560288000/6/129:,I:-5844/-438/-120/-343/-97/4493:" +
                                             "-5844/-438/-120/-350/-98/4509:,I:-5844/-438/-120/-344/-99/4525:-5844/-438/-119/-351/-103/4497:,I:" +
                                             ",I:-5843/-438/-120/-336/-109/4507:-5843/-437/-120/-337/-95/4496:,\n");
        rData.setCorrect(true);
        kService.handleData(rData, device,training);

        File file = new File("src/test/resources/testdata/output.txt");
        BufferedReader br = new BufferedReader(new FileReader(file));
        int number = 0;
        while(br.readLine() != null){
            number++;
        }
        Assert.assertEquals(number, 6);
    }

    @Test
    public void testMultipleHandleData(){
        when(training.getLatOrigin()).thenReturn(34523361L);
        when(training.getLongOrigin()).thenReturn(56025285L);
    }

    public List<RawDataUnit> getRawData(String filePath) throws Exception{
        List<RawDataUnit> rawDataUnits = new ArrayList<RawDataUnit>();
        File file = new File(filePath);
        BufferedReader br = new BufferedReader(new FileReader(file));
        String line;
        while((line = br.readLine()) != null){
            String[] split = line.split("@");
            RawDataUnit rawDataUnit = new RawDataUnit(split[1]);
            rawDataUnit.isCorrect();
            rawDataUnits.add(rawDataUnit);
        }
        return rawDataUnits;
    }
}
