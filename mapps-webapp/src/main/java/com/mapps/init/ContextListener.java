package com.mapps.init;

import java.net.URI;
import java.net.URISyntaxException;
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


    @Override
    public void contextInitialized(ServletContextEvent servletContextEvent) {
        createDefault();
    }

    @Override
    public void contextDestroyed(ServletContextEvent servletContextEvent) {

    }

    private void createDefault() {
        Date date = new Date();

        Institution inst = new Institution("CPC", "Carrasco Polo Club", "Uruguay");
        Institution inst2 = new Institution("CAP", "Club Atletico Peñarol", "Uruguay");
        User user = new User("admin", "", new Date(), Gender.MALE, "admin@mapps.com", "admin", "admin", inst, Role.ADMINISTRATOR, "5.858.567-0");
        User user2 = new User("train", "", new Date(), Gender.MALE, "user@mapps.com", "train", "train", inst, Role.TRAINER, "5.858.544.4");
        user.setEnabled(true);
        Sport sport = new Sport("Futbol");
        Athlete athlete = new Athlete("pepe", "apellido", new Date(), Gender.MALE, "pepe@gmail.com", 78, 1.8, "1.111.111-0", inst);
        Athlete mario = new Athlete("Mario", "Gomez", new Date(), Gender.MALE, "mario@gmail.com", 78, 1.80, "4.447.599-3", inst);
        Device device = new Device("0013A200", "40aad87e", 55, inst);
        Report report = new Report("url", date, "report one", ReportType.TRAINNING);

        Map<Athlete, Device> mapAthleteDevice = new HashMap<Athlete, Device>();
        Map<User, Permission> mapUserPermission = new HashMap<User, Permission>();
        mapAthleteDevice.put(athlete, device);
        mapUserPermission.put(user, Permission.CREATE);
        mapUserPermission.put(user, Permission.READ);

        Training training = new Training("nombreTraining", new Date(), 3, 34523361, 56025285, 55, 190,
                                         mapAthleteDevice, null, sport, mapUserPermission, inst);
        training.setStarted(false);
        try {
            inst.setImageURI(new URI(Constants.DEFAULT_INSTITUTION_IMAGE));
            inst2.setImageURI(new URI(Constants.DEFAULT_INSTITUTION_IMAGE));
            institutionDAO.addInstitution(inst);
            institutionDAO.addInstitution(inst2);
            reportDAO.addReport(report);
            user.setImageURI(new URI(Constants.DEFAULT_USER_IMAGE));
            user2.setImageURI(new URI(Constants.DEFAULT_USER_IMAGE));
            userDAO.addUser(user);
            userDAO.addUser(user2);
            sportDAO.addSport(sport);
            athlete.setImageURI(new URI(Constants.DEFAULT_ATHLETE_IMAGE));
            mario.setImageURI(new URI(Constants.DEFAULT_ATHLETE_IMAGE));
            athleteDAO.addAthlete(athlete);
            athleteDAO.addAthlete(mario);
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
        } catch (URISyntaxException e) {
            logger.error("Image error");
        }
    }
}
