package com.mapps.persistence.impl;

import junit.framework.Assert;

import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import javax.ejb.embeddable.EJBContainer;
import javax.naming.NamingException;

import org.junit.AfterClass;
import org.junit.Before;
import org.junit.BeforeClass;
import org.junit.Test;

import com.mapps.model.Athlete;
import com.mapps.model.Device;
import com.mapps.model.Gender;
import com.mapps.model.Institution;
import com.mapps.model.ProcessedDataUnit;
import com.mapps.model.RawDataUnit;
import com.mapps.model.Training;
import com.mapps.persistence.AthleteDAO;
import com.mapps.persistence.DeviceDAO;
import com.mapps.persistence.InstitutionDAO;
import com.mapps.persistence.ProcessedDataUnitDAO;
import com.mapps.persistence.RawDataUnitDAO;
import com.mapps.persistence.TrainingDAO;

import static org.junit.Assert.assertTrue;

/**
 *Integration Test for ProcessedData unit DAO
 */
public class ProcessedDataUnitDAOImplIntegrationTest {
    private static EJBContainer ejbContainer;
    private ProcessedDataUnitDAO processedDAO;
    private TrainingDAO trainingDAO;
    private DeviceDAO deviceDAO;
    private InstitutionDAO institutionDAO;
    private AthleteDAO athleteDAO;
    private RawDataUnitDAO rawDataUnitDAO;

    @BeforeClass
    public static void startTheContainer(){

        ejbContainer= EJBContainer.createEJBContainer();
    }
    @Before
    public void lookupABean() throws NamingException {

        Object processed = ejbContainer.getContext().lookup("java:global/mapps-persistence/ProcessedDataUnitDAO");
        Object training = ejbContainer.getContext().lookup("java:global/mapps-persistence/TrainingDAO");
        Object device = ejbContainer.getContext().lookup("java:global/mapps-persistence/DeviceDAO");
        Object institution = ejbContainer.getContext().lookup("java:global/mapps-persistence/InstitutionDAO");
        Object athlete = ejbContainer.getContext().lookup("java:global/mapps-persistence/AthleteDAO");
        Object raw = ejbContainer.getContext().lookup("java:global/mapps-persistence/RawDataUnitDAO");

        assertTrue(processed instanceof ProcessedDataUnitDAO);
        assertTrue(training instanceof TrainingDAO);
        assertTrue(device instanceof DeviceDAO);
        assertTrue(institution instanceof InstitutionDAO);
        assertTrue(athlete instanceof AthleteDAO);
        assertTrue(raw instanceof RawDataUnitDAO);
        processedDAO = (ProcessedDataUnitDAO) processed;
        trainingDAO = (TrainingDAO) training;
        deviceDAO = (DeviceDAO) device;
        institutionDAO = (InstitutionDAO) institution;
        athleteDAO = (AthleteDAO) athlete;
        rawDataUnitDAO = (RawDataUnitDAO) raw;
    }

    @AfterClass
    public static void stopTheContainer(){
        if(ejbContainer!=null){
            ejbContainer.close();
        }
    }

    @Test
    public void testGetLastProcessedDataUnit() throws Exception{
        Institution institution = new Institution("CPC", "", "Uruguay");
        institutionDAO.addInstitution(institution);
        Device device = new Device("dirHigh", "dirLow", 1, institution);
        deviceDAO.addDevice(device);
        Athlete athlete = new Athlete("martin", "b", new Date(), Gender.MALE, "m@gmail.com", 1D, 1D, "aaa", institution);
        athleteDAO.addAthlete(athlete);
        Map<Athlete, Device> map = new HashMap<Athlete, Device>();
        map.put(athlete, device);
        Training training = new Training("training", new Date(), 1, 0L, 0L, 1, 1, map, null, null, null, institution);
        trainingDAO.addTraining(training);
        RawDataUnit rawData = new RawDataUnit(null, null, null, device, 1L, false, new Date(), training);
        rawDataUnitDAO.addRawDataUnit(rawData);

        ProcessedDataUnit pUnit = new ProcessedDataUnit(1D, 1D, 1D, 1D, 1D, 1D, device, rawData);
        processedDAO.addProcessedDataUnit(pUnit);

        ProcessedDataUnit last = processedDAO.getLastProcessedDataUnit(training, device);
        Assert.assertEquals(last.getAccelerationX(), 1D);
        Assert.assertEquals(last.getAccelerationY(), 1D);
        Assert.assertEquals(last.getVelocityX(), 1D);
        Assert.assertEquals(last.getVelocityY(), 1D);
        Assert.assertEquals(last.getPositionX(), 1D);
        Assert.assertEquals(last.getPositionY(), 1D);
    }
}