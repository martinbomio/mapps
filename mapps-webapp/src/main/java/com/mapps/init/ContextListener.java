package com.mapps.init;

import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import javax.ejb.EJB;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;

import org.apache.log4j.Logger;

import com.mapps.exceptions.AthleteAlreadyExistException;
import com.mapps.exceptions.DeviceAlreadyExistException;
import com.mapps.exceptions.InstitutionAlreadyExistException;
import com.mapps.exceptions.NullParameterException;
import com.mapps.exceptions.ReportAlreadyExistException;
import com.mapps.exceptions.SportAlreadyExistException;
import com.mapps.exceptions.TrainingAlreadyExistException;
import com.mapps.exceptions.UserAlreadyExistException;
import com.mapps.model.Athlete;
import com.mapps.model.Device;
import com.mapps.model.Gender;
import com.mapps.model.Institution;
import com.mapps.model.Permission;
import com.mapps.model.Report;
import com.mapps.model.ReportType;
import com.mapps.model.Role;
import com.mapps.model.Sport;
import com.mapps.model.Training;
import com.mapps.model.User;
import com.mapps.persistence.AthleteDAO;
import com.mapps.persistence.DeviceDAO;
import com.mapps.persistence.InstitutionDAO;
import com.mapps.persistence.ReportDAO;
import com.mapps.persistence.SportDAO;
import com.mapps.persistence.TrainingDAO;
import com.mapps.persistence.UserDAO;

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
        User user = new User("adminnnnnnn","", new Date(), Gender.MALE, "admin@mapps.com", "admin", "admin", inst, Role.ADMINISTRATOR,"58585");
        Sport sport=new Sport("Futbol");
        Athlete athlete=new Athlete("pepe","apellido",null,Gender.MALE,"pepe@gmail.com",78,1.8,"44475993",inst);
        Device device =new Device("0013A200","40aad87e",55,inst);
        Report report=new Report("url",date,"report one",ReportType.TRAINNING);

        Map<Athlete,Device> mapAthleteDevice=new HashMap<Athlete,Device>();
        Map<User,Permission> mapUserPermission=new HashMap<User,Permission>();
        mapAthleteDevice.put(athlete,device);
        mapUserPermission.put(user,Permission.CREATE);
        mapUserPermission.put(user,Permission.READ);

        Training training=new Training("nombreTraining",new Date(),3,0,0,55,190,mapAthleteDevice,null,sport,mapUserPermission,inst);

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
