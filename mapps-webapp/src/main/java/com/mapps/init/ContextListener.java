package com.mapps.init;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.URI;
import java.net.URISyntaxException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;
import javax.ejb.EJB;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;

import org.apache.log4j.Logger;

import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.mapps.exceptions.GPSDataNotFoundException;
import com.mapps.exceptions.IMUDataNotFoundException;
import com.mapps.exceptions.InstitutionAlreadyExistException;
import com.mapps.exceptions.NullParameterException;
import com.mapps.exceptions.RawDataUnitNotFoundException;
import com.mapps.exceptions.UserAlreadyExistException;
import com.mapps.model.Device;
import com.mapps.model.GPSData;
import com.mapps.model.Gender;
import com.mapps.model.IMUData;
import com.mapps.model.Institution;
import com.mapps.model.ProcessedDataUnit;
import com.mapps.model.PulseData;
import com.mapps.model.RawDataUnit;
import com.mapps.model.Role;
import com.mapps.model.Training;
import com.mapps.model.User;
import com.mapps.persistence.AthleteDAO;
import com.mapps.persistence.DeviceDAO;
import com.mapps.persistence.GPSDataDAO;
import com.mapps.persistence.IMUDataDAO;
import com.mapps.persistence.InstitutionDAO;
import com.mapps.persistence.ProcessedDataUnitDAO;
import com.mapps.persistence.RawDataUnitDAO;
import com.mapps.persistence.ReportDAO;
import com.mapps.persistence.SportDAO;
import com.mapps.persistence.TrainingDAO;
import com.mapps.persistence.UserDAO;
import com.mapps.utils.Constants;

/**
 *
 *
 */
public class ContextListener implements ServletContextListener {
    Logger logger = Logger.getLogger(ContextListener.class);
    @EJB(beanName = "UserDAO")
    UserDAO userDAO;
    @EJB(beanName = "InstitutionDAO")
    InstitutionDAO institutionDAO;
    @EJB(beanName = "SportDAO")
    SportDAO sportDAO;
    @EJB(beanName = "AthleteDAO")
    AthleteDAO athleteDAO;
    @EJB(beanName = "DeviceDAO")
    DeviceDAO deviceDAO;
    @EJB(beanName = "ReportDAO")
    ReportDAO reportDAO;
    @EJB(beanName = "TrainingDAO")
    TrainingDAO trainingDAO;
    @EJB(beanName = "IMUDataDAO")
    IMUDataDAO imuDataDAO;
    @EJB(beanName = "GPSDataDAO")
    GPSDataDAO gpsDataDAO;
    @EJB(beanName = "RawDataUnitDAO")
    RawDataUnitDAO rawDataUnitDAO;
    @EJB(beanName = "ProcessedDataUnitDAO")
    ProcessedDataUnitDAO processedDataUnitDAO;


    @Override
    public void contextInitialized(ServletContextEvent servletContextEvent) {
        createDefault(servletContextEvent);
    }

    @Override
    public void contextDestroyed(ServletContextEvent servletContextEvent) {

    }

    private void createDefault(ServletContextEvent servletContextEvent) {
        Institution inst = new Institution("Mapps-Administration", "Institucion MAPPS", "Uruguay");
        User user = new User("Administrator", "Administrator", new Date(), Gender.MALE, "admin@mapps.com", "admin", "admin", inst, Role.ADMINISTRATOR, "0.000.000-0");

        try {
            inst.setImageURI(new URI(Constants.DEFAULT_INSTITUTION_IMAGE));
            institutionDAO.addInstitution(inst);
            user.setImageURI(new URI(Constants.DEFAULT_USER_IMAGE));
            userDAO.addUser(user);
//            List<IMUData> imuDatas = loadImuData(servletContextEvent);
//            List<GPSData> gpsDatas = loadGPSData(servletContextEvent);
//            loadAndSaveRawDataUnit(device1, training, imuDatas, gpsDatas, servletContextEvent);
//            loadAndSaveProcessedDataUnits(device1, servletContextEvent);

        } catch (InstitutionAlreadyExistException e) {
            logger.error("Institution already exists");
        } catch (NullParameterException e) {
            throw new IllegalArgumentException();
        } catch (UserAlreadyExistException e) {
            logger.error("User already exists");
        } catch (URISyntaxException e) {
            logger.error("Image error");
//        } catch (ParseException e) {
//            e.printStackTrace();  //To change body of catch statement use File | Settings | File Templates.
//        } catch (IOException e) {
//            e.printStackTrace();  //To change body of catch statement use File | Settings | File Templates.
//        } catch (GPSDataNotFoundException e) {
//            e.printStackTrace();  //To change body of catch statement use File | Settings | File Templates.
//        } catch (RawDataUnitNotFoundException e) {
//            e.printStackTrace();  //To change body of catch statement use File | Settings | File Templates.
//        } catch (IMUDataNotFoundException e) {
//            e.printStackTrace();  //To change body of catch statement use File | Settings | File Templates.
        }
    }

    public List<IMUData> loadImuData(ServletContextEvent event) throws IOException, NullParameterException, URISyntaxException {
        InputStream input = event.getServletContext().getResourceAsStream("WEB-INF/resources/initial-data/IMUData.csv");
        BufferedReader br = new BufferedReader(new InputStreamReader(input));
        String line;
        List<IMUData> imuDatas = Lists.newArrayList();
        while ((line = br.readLine()) != null) {
            String[] data = line.split(";");
            int aX = Integer.parseInt(data[1]);
            int aY = Integer.parseInt(data[2]);
            int aZ = Integer.parseInt(data[3]);
            int pitch = Integer.parseInt(data[4]);
            int roll = Integer.parseInt(data[5]);
            int yaw = Integer.parseInt(data[6]);
            IMUData imuData = new IMUData(aX, aY, aZ, yaw, pitch, roll);
            imuDatas.add(imuData);
        }
        return imuDatas;
    }

    public List<GPSData> loadGPSData(ServletContextEvent event) throws IOException, NullParameterException {
        InputStream input = event.getServletContext().getResourceAsStream("WEB-INF/resources/initial-data/GPSData.csv");
        BufferedReader br = new BufferedReader(new InputStreamReader(input));
        String line;
        List<GPSData> gpsDatas = Lists.newArrayList();
        while ((line = br.readLine()) != null) {
            String[] data = line.split(";");
            long latitude = Long.parseLong(data[2]);
            long longitude = Long.parseLong(data[3]);
            int nSat = Integer.parseInt(data[4]);
            int hdop = Integer.parseInt(data[1]);
            GPSData gpsData = new GPSData(latitude, longitude, nSat, hdop);
            gpsDatas.add(gpsData);
        }
        return gpsDatas;
    }

    public void loadAndSaveRawDataUnit(Device device,
                                       Training training,
                                       List<IMUData> imuDatas,
                                       List<GPSData> gpsDatas,
                                       ServletContextEvent event) throws IOException, IMUDataNotFoundException, GPSDataNotFoundException, ParseException, NullParameterException {
        Map<Integer, List<IMUData>> mapImu = getMapIMU(imuDatas, event);
        Map<Integer, List<GPSData>> mapGPS = getMapGPS(gpsDatas, event);
        SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        InputStream input = event.getServletContext().getResourceAsStream("WEB-INF/resources/initial-data/RawDataUnit.csv");
        BufferedReader br = new BufferedReader(new InputStreamReader(input));
        String line;
        while ((line = br.readLine()) != null) {
            String[] data = line.split(";");
            long timestamp = Long.parseLong(data[4]);
            Date date = formatter.parse(data[2]);
            List<GPSData> gpsData = mapGPS.get(Integer.parseInt(data[0]));
            List<IMUData> imuData = mapImu.get(Integer.parseInt(data[0]));
            List<PulseData> pulseData = Lists.newArrayList();
            RawDataUnit rawDataUnit = new RawDataUnit(imuData, gpsData, pulseData, device, timestamp, date, training);
            rawDataUnitDAO.addRawDataUnit(rawDataUnit);
        }

    }

    public void loadAndSaveProcessedDataUnits(Device device, ServletContextEvent event) throws IOException, ParseException, RawDataUnitNotFoundException, NullParameterException {
        InputStream input = event.getServletContext().getResourceAsStream("WEB-INF/resources/initial-data/ProcessedDataUnits.csv");
        BufferedReader br = new BufferedReader(new InputStreamReader(input));
        String line;
        while ((line = br.readLine()) != null) {
            String[] data = line.split(";");
            double aX = Double.parseDouble(data[1]);
            double aY = Double.parseDouble(data[2]);
            double pX = Double.parseDouble(data[4]);
            double pY = Double.parseDouble(data[5]);
            double vX = Double.parseDouble(data[6]);
            double vY = Double.parseDouble(data[7]);
            long elapsed = Long.parseLong(data[3]);
            RawDataUnit rawDataUnit = rawDataUnitDAO.getRawDataUnitById(Long.parseLong(data[9]));
            ProcessedDataUnit processedDataUnit = new ProcessedDataUnit(pX, aY, aX, vY, vX, pY, device, rawDataUnit, elapsed);
            processedDataUnitDAO.addProcessedDataUnit(processedDataUnit);
        }
        br.close();
    }

    public Map<Integer, List<IMUData>> getMapIMU(List<IMUData> imuDatas, ServletContextEvent event) throws IOException, IMUDataNotFoundException {
        InputStream input = event.getServletContext().getResourceAsStream("WEB-INF/resources/initial-data/RawDataUnit_IMUData.csv");
        BufferedReader brIMU = new BufferedReader(new InputStreamReader(input));
        String imuLine;
        Map<Integer, List<IMUData>> mapImu = Maps.newHashMap();
        while ((imuLine = brIMU.readLine()) != null) {
            String[] data = imuLine.split(";");
            IMUData imuData = imuDatas.get(Integer.parseInt(data[1])-1);
            Integer pos = Integer.parseInt(data[0]);
            if (mapImu.get(pos) == null) {
                mapImu.put(pos, new ArrayList<IMUData>());
            }
            mapImu.get(pos).add(imuData);
        }
        brIMU.close();
        return mapImu;
    }

    public Map<Integer, List<GPSData>> getMapGPS(List<GPSData> gpsDatas, ServletContextEvent event) throws IOException, GPSDataNotFoundException {
        InputStream input = event.getServletContext().getResourceAsStream("WEB-INF/resources/initial-data/RawDataUnit_GPSData.csv");
        BufferedReader brIMU = new BufferedReader(new InputStreamReader(input));
        String imuLine;
        Map<Integer, List<GPSData>> mapImu = Maps.newHashMap();
        while ((imuLine = brIMU.readLine()) != null) {
            String[] data = imuLine.split(";");
            GPSData imuData = gpsDatas.get(Integer.parseInt(data[1])-1);
            Integer pos = Integer.parseInt(data[0]);
            if (mapImu.get(pos) == null) {
                mapImu.put(pos, new ArrayList<GPSData>());
            }
            mapImu.get(pos).add(imuData);
        }
        brIMU.close();
        return mapImu;
    }
}
