package com.mapps.services.training.impl;

import com.mapps.authentificationhandler.AuthenticationHandler;
import com.mapps.authentificationhandler.exceptions.InvalidTokenException;
import com.mapps.exceptions.NullParameterException;
import com.mapps.exceptions.TrainingNotFoundException;
import com.mapps.model.*;
import com.mapps.persistence.AthleteDAO;
import com.mapps.persistence.DeviceDAO;
import com.mapps.persistence.SportDAO;
import com.mapps.persistence.TrainingDAO;
import com.mapps.services.institution.exceptions.InvalidInstitutionException;
import com.mapps.services.trainer.exceptions.AuthenticationException;
import com.mapps.services.trainer.exceptions.InvalidTrainingException;
import com.mapps.services.training.stub.TrainerServiceStub;
import org.junit.Before;
import org.junit.Test;
import junit.framework.Assert;

import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

/**
 *
 */
public class TrainerServiceImplTest {

    TrainerServiceStub trainerService;
    TrainingDAO trainingDAO;
    AthleteDAO athleteDAO;
    DeviceDAO deviceDAO;
    SportDAO sportDAO;

    @Before
    public void setUp()throws Exception{
        trainerService=new TrainerServiceStub();
        trainingDAO=mock(TrainingDAO.class);
        athleteDAO=mock(AthleteDAO.class);
        deviceDAO=mock(DeviceDAO.class);
        sportDAO=mock(SportDAO.class);
        AuthenticationHandler auth = mock(AuthenticationHandler.class);

        when(auth.isUserInRole("validToken", Role.ADMINISTRATOR)).thenReturn(true);
        when(auth.isUserInRole("invalidToken", Role.ADMINISTRATOR)).thenReturn(false);
        when(auth.isUserInRole("",Role.ADMINISTRATOR)).thenThrow(new InvalidTokenException());

        trainerService.setAuthenticationHandler(auth);
        trainerService.setTrainingDAO(trainingDAO);
        trainerService.setAthleteDAO(athleteDAO);
        trainerService.setDeviceDAO(deviceDAO);
        trainerService.setSportDAO(sportDAO);

    }

    @Test
    public void testStartTraining(){
        Training startTraining=mock(Training.class);
        Sport sport=mock(Sport.class);
        Athlete athlete=mock(Athlete.class);
        Device device=mock(Device.class);
        //Map<Athlete,Device> mapAthleteDevice=new HashMap<Athlete,Device>();
        //mapAthleteDevice.put(athlete,device);
        when(startTraining.getName()).thenReturn("startTraining");
        when(startTraining.getDate()).thenReturn(new Date());
        when(startTraining.getLatOrigin()).thenReturn(1500L);
        when(startTraining.getLongOrigin()).thenReturn(1700L);
        when(startTraining.getSport()).thenReturn(sport);
        //when(startTraining.getMapAthleteDevice()).thenReturn(mapAthleteDevice);

        try{
            when(trainingDAO.getTrainingByName("startTraining")).thenReturn(startTraining);
            trainerService.startTraining(startTraining, "validToken");
            verify(trainingDAO).updateTraining(startTraining);

        } catch (AuthenticationException e) {
            Assert.fail();
        } catch (TrainingNotFoundException e) {
            Assert.fail();
        }  catch (InvalidTrainingException e) {
            Assert.fail();
        } catch (NullParameterException e) {
            Assert.fail();
        }

    }

    @Test
    public void testStopTraining(){
        Training stopTraining=mock(Training.class);
        Sport sport=mock(Sport.class);
        when(stopTraining.getName()).thenReturn("stopTraining");
        when(stopTraining.getDate()).thenReturn(new Date());
        when(stopTraining.getLatOrigin()).thenReturn(1500L);
        when(stopTraining.getLongOrigin()).thenReturn(1700L);
        when(stopTraining.getSport()).thenReturn(sport);


        try{
            when(trainingDAO.getTrainingByName("stopTraining")).thenReturn(stopTraining);
            trainerService.stopTraining(stopTraining, "validToken");
            verify(trainingDAO).updateTraining(stopTraining);


        } catch (AuthenticationException e) {
            Assert.fail();
        } catch (TrainingNotFoundException e) {
            Assert.fail();
        }  catch (InvalidTrainingException e) {
            Assert.fail();
        } catch (NullParameterException e) {
            Assert.fail();
        }

    }


}
