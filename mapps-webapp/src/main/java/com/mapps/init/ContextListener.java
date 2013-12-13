package com.mapps.init;

import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import javax.ejb.EJB;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;

import com.mapps.exceptions.*;
import com.mapps.model.*;
import com.mapps.persistence.*;
import org.apache.log4j.Logger;

/**
 *
 *
 */
public class ContextListener implements ServletContextListener{
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


    @Override
    public void contextInitialized(ServletContextEvent servletContextEvent) {
        createDefault();
    }

    @Override
    public void contextDestroyed(ServletContextEvent servletContextEvent) {

    }

    private void createDefault(){
        Date date=new Date();

        Institution inst = new Institution("CPC", "Carrasco Polo Club", "Uruguay");
        User user = new User("adminnnnnnn","", new Date(), Gender.MALE, "admin@mapps.com", "admin", "admin", inst, Role.ADMINISTRATOR);
        Sport sport=new Sport("Futbol");
        Athlete athlete=new Athlete("pepe","apellido",null,Gender.MALE,"pepe@gmail.com",78,1.8,"44475993",inst);
        Device device =new Device("0013A202","40813E2B",55,inst);
        Report report=new Report("url",date,"report one",ReportType.TRAINNING);

        Map<Athlete,Device> mapAthleteDevice=new HashMap<Athlete,Device>();
        Map<User,Permission> mapUserPermission=new HashMap<User,Permission>();
        mapAthleteDevice.put(athlete,device);
        mapUserPermission.put(user,Permission.CREATE);
        mapUserPermission.put(user,Permission.READ);

        Training training=new Training("nombreTraining",null,3,0,0,55,190,mapAthleteDevice,null,sport,mapUserPermission,inst);

        try {
            institutionDAO.addInstitution(inst);
            reportDAO.addReport(report);
            userDAO.addUser(user);
            sportDAO.addSport(sport);
            athleteDAO.addAthlete(athlete);
            deviceDAO.addDevice(device);
            trainingDAO.addTraining(training);

        } catch (InstitutionAlreadyExistException e) {
            logger.error("Institution already exists");
        } catch (NullParameterException e) {
            throw new IllegalArgumentException();
        } catch (UserAlreadyExistException e) {
            logger.error("User already exists");
        } catch (SportAlreadyExistException e) {
            logger.error("Sport already exists");
        } catch (AthleteAlreadyExistException e) {
            logger.error("Athlete already exists");
        } catch (DeviceAlreadyExistException e) {
            logger.error("Device already exists");
        } catch (ReportAlreadyExistException e) {
            logger.error("Report already exists");
        } catch (TrainingAlreadyExistException e) {
            logger.error("Training already exists");
        }
    }
}
