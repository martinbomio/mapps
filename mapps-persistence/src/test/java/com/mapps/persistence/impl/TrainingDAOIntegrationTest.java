package com.mapps.persistence.impl;

import java.util.Date;
import java.util.HashMap;
import javax.ejb.embeddable.EJBContainer;
import javax.naming.NamingException;

import org.junit.AfterClass;
import org.junit.Assert;
import org.junit.Before;
import org.junit.BeforeClass;
import org.junit.Test;

import com.mapps.exceptions.AthleteAlreadyExistException;
import com.mapps.exceptions.DeviceAlreadyExistException;
import com.mapps.exceptions.DeviceNotFoundException;
import com.mapps.exceptions.InstitutionAlreadyExistException;
import com.mapps.exceptions.NullParameterException;
import com.mapps.exceptions.TrainingAlreadyExistException;
import com.mapps.exceptions.TrainingNotFoundException;
import com.mapps.model.Athlete;
import com.mapps.model.Device;
import com.mapps.model.Institution;
import com.mapps.model.Training;
import com.mapps.persistence.AthleteDAO;
import com.mapps.persistence.DeviceDAO;
import com.mapps.persistence.InstitutionDAO;
import com.mapps.persistence.TrainingDAO;

import static org.junit.Assert.assertTrue;


/**
 *
 */
public class TrainingDAOIntegrationTest {

    private static EJBContainer ejbContainer;
    private Training testTraining;
    private Device testDevice;
    private Athlete testAthlete;
    private Institution testInstitution;

    private AthleteDAO athleteDAO;
    private DeviceDAO deviceDAO;
    private TrainingDAO trainingDAO;
    private InstitutionDAO institutionDAO;

    @BeforeClass
    public static void startTheContainer(){
        ejbContainer=EJBContainer.createEJBContainer();
    }
    @Before
    public void lookupABean() throws NamingException {

        Object object=ejbContainer.getContext().lookup("java:global/mapps-persistence/TrainingDAO");
        Object object2=ejbContainer.getContext().lookup("java:global/mapps-persistence/AthleteDAO");
        Object object3=ejbContainer.getContext().lookup("java:global/mapps-persistence/DeviceDAO");
        Object object4=ejbContainer.getContext().lookup("java:global/mapps-persistence/InstitutionDAO");

        assertTrue(object instanceof TrainingDAO);
        assertTrue(object2 instanceof AthleteDAO);
        assertTrue(object3 instanceof DeviceDAO);
        assertTrue(object4 instanceof InstitutionDAO);

        trainingDAO=(TrainingDAO)object;
        athleteDAO=(AthleteDAO)object2;
        deviceDAO=(DeviceDAO)object3;
        institutionDAO=(InstitutionDAO)object4;
    }
    @AfterClass
    public static void stopTheContainer(){
        if(ejbContainer!=null){
            ejbContainer.close();
        }
    }

    @Test
    public void testAddTraining() throws NullParameterException, TrainingAlreadyExistException, TrainingNotFoundException {
        testTraining=new Training("hola",null,0,0,0,0,0,null,null,null,null);
        trainingDAO.addTraining(testTraining);
        Training returnedTraining = trainingDAO.getTrainingByName(testTraining.getName());
        Assert.assertEquals(testTraining.getName(), returnedTraining.getName());
    }

    @Test
    public void testDeleteTraining() throws NullParameterException, TrainingAlreadyExistException, TrainingNotFoundException {
        testTraining=new Training("hola2",null,0,0,0,0,0,null,null,null,null);
        trainingDAO.addTraining(testTraining);
        Training returnedTraining = trainingDAO.getTrainingByName(testTraining.getName());

        trainingDAO.deleteTraining(returnedTraining.getId());
        try{
        Training testAux = trainingDAO.getTrainingByName(testTraining.getName());
        }catch(TrainingNotFoundException e){
            Assert.assertTrue(true);
        }


    }
    @Test
    public void updateTraining() throws NullParameterException, TrainingAlreadyExistException, TrainingNotFoundException {
        testTraining=new Training("hola3",null,0,0,0,0,0,null,null,null,null);
        trainingDAO.addTraining(testTraining);
        Training returnedTraining = trainingDAO.getTrainingByName(testTraining.getName());
        returnedTraining.setMaxBPM(5);
        trainingDAO.updateTraining(returnedTraining);
        Training testAux = trainingDAO.getTrainingByName(testTraining.getName());

        Assert.assertEquals(testAux.getMaxBPM(),5);


    }

    @Test
    public void testGetTrainingOfDevice() throws InstitutionAlreadyExistException, NullParameterException, AthleteAlreadyExistException, DeviceAlreadyExistException, TrainingAlreadyExistException, DeviceNotFoundException, TrainingNotFoundException {
        Date dNow = new Date( );
        testInstitution=new Institution("hola3",null,"URUGUAY");
        testAthlete=new Athlete(null, null, null,null,
                null,1.5, 1.2,"44475992",testInstitution);
        testDevice=new Device("0013A200","40813E2A",55,testInstitution);
        HashMap<Athlete,Device> mapAthleteDevice=new HashMap<Athlete,Device>();
        mapAthleteDevice.put(testAthlete,testDevice);
        testTraining=new Training("hola4",dNow,0,0,0,0,0,mapAthleteDevice,null,null,null);

        institutionDAO.addInstitution(testInstitution);
        athleteDAO.addAthlete(testAthlete);
        deviceDAO.addDevice(testDevice);
        trainingDAO.addTraining(testTraining);

        Device returnedDevice = deviceDAO.getDeviceByDir(testDevice.getDirLow());
        Training testAux= trainingDAO.getTrainingOfDevice(returnedDevice.getDirLow(),dNow);

            Assert.assertEquals(testAux.getName(),"hola4");


    }

}
