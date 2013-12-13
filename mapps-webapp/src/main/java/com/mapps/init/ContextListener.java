package com.mapps.init;

import java.util.Date;
import javax.ejb.EJB;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;

import org.apache.log4j.Logger;

import com.mapps.exceptions.InstitutionAlreadyExistException;
import com.mapps.exceptions.NullParameterException;
import com.mapps.exceptions.UserAlreadyExistException;
import com.mapps.model.Gender;
import com.mapps.model.Institution;
import com.mapps.model.Role;
import com.mapps.model.User;
import com.mapps.persistence.InstitutionDAO;
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

    @Override
    public void contextInitialized(ServletContextEvent servletContextEvent) {
        createDefault();
    }

    @Override
    public void contextDestroyed(ServletContextEvent servletContextEvent) {

    }

    private void createDefault(){
        Institution inst = new Institution("CPC", "Carrasco Polo Club", "Uruguay");
        User user = new User("admin", "", new Date(), Gender.MALE, "admin@mapps.com", "admin", "admin", inst, Role.ADMINISTRATOR);
        try {
            institutionDAO.addInstitution(inst);
            userDAO.addUser(user);
        } catch (InstitutionAlreadyExistException e) {
            logger.error("Institution already exists");
        } catch (NullParameterException e) {
            throw new IllegalArgumentException();
        } catch (UserAlreadyExistException e) {
            logger.error("User already exists");
        }
    }
}
