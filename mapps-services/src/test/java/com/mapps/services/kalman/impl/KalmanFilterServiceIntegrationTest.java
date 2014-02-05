package com.mapps.services.kalman.impl;

import junit.framework.Assert;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.junit.Before;
import org.junit.Test;
import org.mockito.ArgumentCaptor;
import org.mockito.Captor;
import org.mockito.Mockito;

import com.mapps.model.Device;
import com.mapps.model.KalmanState;
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
    private RawDataUnitDAO rawDao;
    private KalmanStateDAO sDAO;
    private Training training;
    private Device device;
    private ProcessedDataUnit lastProcesedDataUnit;

    @Before
    public void setup() throws Exception {
        this.rawDao = Mockito.mock(RawDataUnitDAO.class);
        this.pDAO = Mockito.mock(ProcessedDataUnitDAO.class);
        this.sDAO = Mockito.mock(KalmanStateDAO.class);
        ProcessedDataUnit pDataUnit = Mockito.mock(ProcessedDataUnit.class);
        this.training = Mockito.mock(Training.class);
        this.device = Mockito.mock(Device.class);
        when(rawDao.getInitialConditions(training, device)).thenReturn(getRawData("src/test/resources/testdata/initial_data.txt"));
        when(rawDao.initialConditionsSatisfied(training, device)).thenReturn(true);
        when(sDAO.getLastState(training, device)).thenReturn(null);
        when(pDAO.getLastProcessedDataUnit(training, device)).thenReturn(pDataUnit);
        this.kService = new KalmanFilterServiceStub();
        this.kService.setProcessedDataUnitDAO(pDAO);
        this.kService.setRawDataUnitDAO(rawDao);
        this.kService.setKalmanStateDAO(sDAO);
    }

    @Test
    public void testHandleData() throws Exception {
        when(training.getLatOrigin()).thenReturn(34523361L);
        when(training.getLongOrigin()).thenReturn(56025285L);
        RawDataUnit rData = new RawDataUnit("G:345255840/560288000/6/129:,I:-5844/-438/-120/-343/-97/4493:" +
                                                    "-5844/-438/-120/-350/-98/4509:,I:-5844/-438/-120/-344/-99/4525:-5844/-438/-119/-351/-103/4497:,I:" +
                                                    ",I:-5843/-438/-120/-336/-109/4507:-5843/-437/-120/-337/-95/4496:,\n");
        rData.setCorrect(true);
        kService.handleData(rData, device, training);

        File file = new File("src/test/resources/testdata/output.csv");
        BufferedReader br = new BufferedReader(new FileReader(file));
        int number = 0;
        while (br.readLine() != null) {
            number++;
        }
        try {
            Assert.assertEquals(number, 6);
        } finally {
            file.delete();
        }
    }

    @Test
    public void testMultipleHandleData() throws Exception {
        File stateAux = new File("src/test/resources/testdata/state.csv");
        kService.output_URL = "src/test/resources/testdata/output-multiple.csv";
        when(training.getLatOrigin()).thenReturn(34523278L);
        when(training.getLongOrigin()).thenReturn(56025311L);
        when(sDAO.getLastState(training, device)).thenReturn(createState());
        List<RawDataUnit> inputs = getRawData("src/test/resources/testdata/data.txt");
        int numbOfImuData = 0;
        for (RawDataUnit input : inputs) {
            numbOfImuData += input.getImuData().size();
            kService.multiple = true;
            kService.handleData(input, device, training);
            kService.multiple = false;
        }
        File file = new File("src/test/resources/testdata/output-multiple.csv");
        BufferedReader br = new BufferedReader(new FileReader(file));
        int number = 0;
        while (br.readLine() != null) {
            number++;
        }
        try{
        Assert.assertEquals(number, numbOfImuData);

        }finally {
            file.delete();
            stateAux.delete();
        }

    }

    @Test
    public void testMultipleHandleDataRealStates() throws Exception {
        kService.output_URL = "src/test/resources/testdata/output-real-state.csv";
        File aux = new File("src/test/resources/testdata/output-real-state.csv");
        File stateAux = new File("src/test/resources/testdata/state.csv");
        when(training.getLatOrigin()).thenReturn(34523268L);
        when(training.getLongOrigin()).thenReturn(56025302L);
        List<RawDataUnit> inputs = getRawData("src/test/resources/testdata/data.txt");
        int numbOfImuData = 0;
        int latest = 0;
        for (RawDataUnit input : inputs) {
            numbOfImuData += input.getImuData().size();
            kService.multiple = true;
            kService.handleData(input, device, training);
            kService.multiple = false;
            when(sDAO.getLastState(training, device)).thenReturn(loadLatestState(latest));
            when(pDAO.getLastProcessedDataUnit(training, device)).thenReturn(getLastProcesedDataUnit(input));
            latest++;
        }
        try {
            Assert.assertEquals(latest, 28);
        } finally {
            aux.delete();
            stateAux.delete();
        }
    }

    private KalmanState loadLatestState(int latest) throws Exception {
        FileInputStream fs = new FileInputStream("src/test/resources/testdata/state.csv");
        BufferedReader br = new BufferedReader(new InputStreamReader(fs));
        for (int i = 0; i < latest; ++i)
            br.readLine();
        String row = br.readLine();
        br.close();
        fs.close();
        return createStateFromCSVRow(row);
    }

    private KalmanState createStateFromCSVRow(String row) {
        String[] values = row.split("\t");
        double aXBias = Double.valueOf(values[0]);
        double aYBias = Double.valueOf(values[1]);
        double gpsError = Double.valueOf(values[2]);
        String prevState = values[3];
        String qMatrix = values[4];
        String rgi = values[5];
        double initialYaw = Double.parseDouble(values[6]);
        Date date = new Date(Long.valueOf(values[6]));
        KalmanState state = new KalmanState(prevState, qMatrix, rgi, gpsError, aXBias,
                                            aYBias, initialYaw, date, this.training, this.device);
        return state;
    }

    private KalmanState createState() throws Exception {
        KalmanState state = new KalmanState();
        File file = new File("src/test/resources/testdata/state.txt");
        BufferedReader br = new BufferedReader(new FileReader(file));
        state.setPreviousState(br.readLine());
        state.setqMatrix(br.readLine());
        state.setRgi(br.readLine());
        state.setGpsError(Double.valueOf(br.readLine()));
        state.setaXBias(Double.valueOf(br.readLine()));
        state.setAyBias(Double.valueOf(br.readLine()));
        state.setTraining(this.training);
        state.setDevice(this.device);
        br.close();
        return state;
    }

    public List<RawDataUnit> getRawData(String filePath) throws Exception {
        List<RawDataUnit> rawDataUnits = new ArrayList<RawDataUnit>();
        File file = new File(filePath);
        BufferedReader br = new BufferedReader(new FileReader(file));
        String line;
        while ((line = br.readLine()) != null) {
            String[] split = line.split("@");
            RawDataUnit rawDataUnit = new RawDataUnit(split[1]);
            rawDataUnit.setCorrect(true);
            rawDataUnits.add(rawDataUnit);
        }
        return rawDataUnits;
    }

    public ProcessedDataUnit getLastProcesedDataUnit(RawDataUnit last) throws IOException {
        BufferedReader br = new BufferedReader(new FileReader(new File("src/test/resources/testdata/output-real-state.csv")));
        String lastLine = "";
        String sCurrentLine;
        while ((sCurrentLine = br.readLine()) != null)
        {
            lastLine = sCurrentLine;
        }
        String[] split = lastLine.split("\t");
        Double aX = Double.parseDouble(split[0]);
        Double aY = Double.parseDouble(split[1]);
        Double vX = Double.parseDouble(split[2]);
        Double vY = Double.parseDouble(split[3]);
        Double pX = Double.parseDouble(split[4]);
        Double pY = Double.parseDouble(split[5]);
        Date date = new Date(Long.parseLong(split[6]));
        //ProcessedDataUnit processedDataUnit  = new ProcessedDataUnit(pX, aY, aX, vY, vX, pY, this.device, last, date);
        return null;
    }
}
