package com.mapps.servlets;

import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Map;
import javax.ejb.EJB;
import javax.servlet.Servlet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;

import com.google.common.collect.Maps;
import com.google.common.hash.Hashing;
import com.mapps.model.Athlete;
import com.mapps.model.Device;
import com.mapps.model.Institution;
import com.mapps.model.Permission;
import com.mapps.model.Sport;
import com.mapps.model.Training;
import com.mapps.model.User;
import com.mapps.services.institution.InstitutionService;
import com.mapps.services.trainer.TrainerService;
import com.mapps.services.trainer.exceptions.AuthenticationException;
import com.mapps.services.trainer.exceptions.InvalidAthleteException;
import com.mapps.services.trainer.exceptions.InvalidTrainingException;
import com.mapps.services.user.UserService;

/**
 *
 */
@WebServlet(name = "addTraining", urlPatterns = "/addTraining/*")
public class AddTrainingServlet extends HttpServlet implements Servlet {
    Logger logger = Logger.getLogger(AddTrainingServlet.class);
    @EJB(beanName = "UserService")
    UserService userService;
    @EJB(beanName = "TrainerService")
    TrainerService trainerService;
    @EJB(beanName = "InstitutionService")
    InstitutionService institutionService;

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String token = String.valueOf(req.getSession().getAttribute("token"));
        try {
            User userTraining = userService.getUserOfToken(token);
            Institution institution = userTraining.getInstitution();
            SimpleDateFormat formatter = new SimpleDateFormat("dd/MM/yyyy HH:mm");
            Date date = formatter.parse(req.getParameter("date"));
            long longitude = Long.parseLong(req.getParameter("num_longitude"));
            long latitude = Long.parseLong(req.getParameter("num_latitude"));
            int minBPM = Integer.parseInt(req.getParameter("num_min_bpm"));
            int maxBPM = Integer.parseInt(req.getParameter("num_max_bpm"));
            String sportName = req.getParameter("sport");
            Sport sportAux = trainerService.getSportByName(sportName);
            String name = createTrainingName(institution, sportAux);
            Map<User, Permission> permissionMap = createPermissionMap(token, userTraining);
            Training training = new Training(name, date, 0, longitude, latitude, minBPM, maxBPM,
                                             null, null, null, sportAux, permissionMap, institution);
            trainerService.addTraining(training, token);
            resp.sendRedirect("training/trainings.jsp?info=1");
        } catch (AuthenticationException e) {
            //2:Error de autentificacion
            resp.sendRedirect("training/create_training.jsp?error=2");
        } catch (InvalidTrainingException e) {
            //1: Entrenamineto invalido
            resp.sendRedirect("training/create_training.jsp?error=1");
        } catch (com.mapps.services.user.exceptions.AuthenticationException e) {
            //2:Error de autentificacion
            resp.sendRedirect("training/create_training.jsp?error=2");
        } catch (ParseException e) {
            logger.error("Date fromat exception");
            throw new IllegalStateException();
        } catch (com.mapps.services.institution.exceptions.AuthenticationException e) {
            //2:Error de autentificacion
            resp.sendRedirect("training/create_training.jsp?error=2");
        }
    }

    private Map<User, Permission> createPermissionMap(String token, User owner) throws com.mapps.services.institution.exceptions.AuthenticationException {
        Map<User, Permission> permissionMap = Maps.newHashMap();
        List<User> usersOfInstitution = institutionService.getUsersOfInstitution(token);
        for (User user : usersOfInstitution){
        	if (user.equals(owner)){
                permissionMap.put(user, Permission.CREATE);
        	}
            permissionMap.put(user, Permission.READ);
        }
        return permissionMap;
    }

    private String createTrainingName(Institution institution, Sport sport) {
        SimpleDateFormat formatter = new SimpleDateFormat("dd-MM-yyyy-HH-mm-ss-SSSS");
        String dateString = formatter.format(new Date());
        String hash = Hashing.murmur3_32().hashString(institution.getName() + "-" + sport.getName() + "-" + dateString).toString();
        return "0T" + hash;
    }

    private Map<Athlete, Device> createAthleteDeviceMap(String players) throws InvalidAthleteException {
        Map<Athlete, Device> map = Maps.newHashMap();
        String[] athletes = players.split(",");
        for (String athlete : athletes) {
            Athlete realAthlete = trainerService.getAthleteByIdDocument(athlete);
            map.put(realAthlete, null);
        }
        return map;
    }
}
