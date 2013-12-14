package com.mapps.services.receiver.impl;

import java.util.Date;
import java.util.List;
import javax.ejb.EJB;
import javax.ws.rs.Consumes;
import javax.ws.rs.POST;
import javax.ws.rs.Path;

import org.apache.log4j.Logger;

import com.mapps.exceptions.DeviceNotFoundException;
import com.mapps.exceptions.NullParameterException;
import com.mapps.exceptions.TrainingNotFoundException;
import com.mapps.model.Device;
import com.mapps.model.RawDataUnit;
import com.mapps.model.Training;
import com.mapps.persistence.DeviceDAO;
import com.mapps.persistence.RawDataUnitDAO;
import com.mapps.persistence.TrainingDAO;
import com.mapps.services.receiver.ReceiverService;
import com.mapps.services.receiver.exceptions.InvalidDataException;
import com.mapps.services.receiver.exceptions.InvalidDataRuntimeException;
import com.mapps.services.receiver.exceptions.InvalidDeviceException;
import com.mapps.services.receiver.exceptions.InvalidRawDataUnitRuntimeException;
import com.mapps.services.receiver.exceptions.NoTrainingFoundException;
import com.mapps.services.util.Constants;

/**
 * Resful Service for receiving and persisting the data.
 */
@Path("/receiver/receive-data")
public class ReceiveRestfulService implements ReceiverService{
    Logger logger = Logger.getLogger(ReceiveRestfulService.class);
    @EJB(beanName = "TrainingDAO")
    TrainingDAO trainingDAO;
    @EJB(beanName = "RawDataUnitDAO")
    RawDataUnitDAO rawDataUnitDAO;
    @EJB(beanName = "DeviceDAO")
    DeviceDAO deviceDAO;

    @POST
    @Consumes("text/plain")
    public void persistData(String data) {
        if (data == null){
            logger.error("There is no data passed");
            throw new IllegalArgumentException();
        }
        System.out.print(data);
        logger.error("String DATA arrived: "+data);
        String[] split = data.split("@");
        String dirLow = split[0];
        logger.error("String dirLow arrived: "+dirLow);
        String sensorData = split[1];
        logger.error("String SensorData arrived: "+sensorData);
        try{
            Device device = getDevice(Constants.DIRHIGH, dirLow);
            List<Training> dbTrainings = trainingDAO.getTrainingOfDevice(device.getDirLow(), new Date());
            if (dbTrainings.size() == 0){
                throw new NoTrainingFoundException();
            }
            Training dbTraining = getRecentTraining(dbTrainings);
            if(trainingDAO.isTrainingStarted(dbTraining.getName()))
                handleData(sensorData, device, dbTraining);
            else
                logger.info("Training: "+dbTraining.getName()+" no started yet.");
        } catch (InvalidDeviceException e) {
            throw new InvalidDataRuntimeException();
        } catch (InvalidDataException e) {
            throw new InvalidDataRuntimeException();
        } catch (TrainingNotFoundException e) {
            throw new IllegalArgumentException();
        }
    }

    private Training getRecentTraining(List<Training> dbTrainings) {
        Date now = new Date();
        Training training = dbTrainings.get(0);
        long minTime = Long.MAX_VALUE;
        for (Training t : dbTrainings){
            long time = now.getTime() - t.getDate().getTime();
            if (time <= minTime){
                minTime = time;
                training = t;
            }
        }
        return training;
    }

    @Override
    public Device getDevice(String dirHigh, String dirLow) throws InvalidDeviceException {
        if (dirHigh == null || dirLow == null){
            logger.error("dirLow or dirHigh not set");
            throw new InvalidDeviceException();
        }
        try{
           return deviceDAO.getDeviceByDir(dirLow);
       } catch (DeviceNotFoundException e) {
           logger.error("Invalid Device. Device with dirLow: "+ dirLow + " not found.");
           throw new InvalidDeviceException();
       }
    }

    @Override
    public void handleData(String data, Device device, Training training) throws InvalidDataException, InvalidDeviceException {
        if (data == null || device == null || training == null){
            logger.error("Invalid parameters data or device");
            throw new IllegalArgumentException();
        }
        try{
            RawDataUnit rawDataUnit = new RawDataUnit(data);
            rawDataUnit.setDevice(device);
            rawDataUnit.setTimestamp(rawDataUnit.getDate().getTime() - training.getDate().getTime());
            rawDataUnitDAO.addRawDataUnit(rawDataUnit);
            if (rawDataUnitDAO.initialConditionsSatisfied(training, device)){
                List<RawDataUnit> initialCOnditions = rawDataUnitDAO.getInitialConditions(training,device);
                //TODO: CALL KALMAN FILTER
            }
        } catch (NullParameterException e) {
            logger.error("Invalid data unit structure to save");
            throw new InvalidRawDataUnitRuntimeException();
        }
    }
}
