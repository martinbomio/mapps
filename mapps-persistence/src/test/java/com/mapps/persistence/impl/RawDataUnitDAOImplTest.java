package com.mapps.persistence.impl;

import junit.framework.Assert;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import javax.ejb.embeddable.EJBContainer;

import org.junit.AfterClass;
import org.junit.Before;
import org.junit.BeforeClass;
import org.junit.Test;

import com.mapps.model.Device;
import com.mapps.model.GPSData;
import com.mapps.model.RawDataUnit;
import com.mapps.model.Training;
import com.mapps.persistence.AthleteDAO;
import com.mapps.persistence.DeviceDAO;
import com.mapps.persistence.RawDataUnitDAO;
import com.mapps.persistence.TrainingDAO;

import static org.junit.Assert.assertTrue;

/**
 * Test for RawDataUnitDAO
 */
public class RawDataUnitDAOImplTest {
    private static EJBContainer ejbContainer;
    private RawDataUnitDAO rawDataUnitDAO;
    private DeviceDAO deviceDAO;
    private TrainingDAO trainingDAO;
    private AthleteDAO athleteDAO;
    private Training training;

    @BeforeClass
    public static void startTheContainer() {

        ejbContainer = EJBContainer.createEJBContainer();
    }

    @Before
    public void lookupABean() throws Exception {

        Object dao = ejbContainer.getContext().lookup("java:global/mapps-persistence/RawDataUnitDAO");
        Object deviceDao = ejbContainer.getContext().lookup("java:global/mapps-persistence/DeviceDAO");
        Object trainingDao = ejbContainer.getContext().lookup("java:global/mapps-persistence/TrainingDAO");
        Object athleteDao = ejbContainer.getContext().lookup("java:global/mapps-persistence/AthleteDAO");
        assertTrue(dao instanceof RawDataUnitDAO);
        assertTrue(deviceDao instanceof DeviceDAO);
        assertTrue(trainingDao instanceof TrainingDAO);
        assertTrue(athleteDao instanceof AthleteDAO);
        rawDataUnitDAO = (RawDataUnitDAO) dao;
        this.deviceDAO = (DeviceDAO) deviceDao;
        this.trainingDAO = (TrainingDAO) trainingDao;
        this.athleteDAO = (AthleteDAO) athleteDao;
    }

    @AfterClass
    public static void stopTheContainer() {
        if (ejbContainer != null) {
            ejbContainer.close();
        }
    }

    @Test
    public void testInitialConditionsSatisfied() throws Exception {
        Device device = new Device("123", "456", 55, null);
        deviceDAO.addDevice(device);

        Training training = new Training("training1", new Date(), 1, 1L, 1L, 0, 0, null, null, null, null, null, null);
        trainingDAO.addTraining(training);

        addRawDataUnits(50, device, training);
        Assert.assertTrue(rawDataUnitDAO.initialConditionsSatisfied(training, device));
    }

    @Test
    public void testGetInitialConditions() throws Exception {
        Device device = new Device("123", "456789", 55, null);
        deviceDAO.addDevice(device);

        Training training = new Training("training2", new Date(), 1, 1L, 1L, 0, 0, null, null, null, null, null, null);
        trainingDAO.addTraining(training);

        addRawDataUnits(50, device, training);
        List<RawDataUnit> rawDataUnits = rawDataUnitDAO.getInitialConditions(training, device);
        Assert.assertEquals(rawDataUnits.size(), 45);
        Assert.assertEquals(rawDataUnits.get(0).getGpsData().get(0).getHDOP(), 1);
        Date first = rawDataUnits.get(0).getDate();
        Date last = rawDataUnits.get(rawDataUnits.size() - 1).getDate();
        Assert.assertTrue(first.getTime() < last.getTime());
    }

    private void addRawDataUnits(int numb, Device device, Training training) throws Exception {
        for (int i = 0; i < numb; i++) {
            GPSData gppsData = new GPSData(1L, 1L, 1, 1);
            List<GPSData> listGPS = new ArrayList<GPSData>();
            listGPS.add(gppsData);
            RawDataUnit data = new RawDataUnit(null, listGPS, null, device, 1L, new Date(), training);
            rawDataUnitDAO.addRawDataUnit(data);
        }
    }
}
