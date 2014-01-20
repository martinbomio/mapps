package com.mapps.servlets;

import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
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

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String token = String.valueOf(req.getSession().getAttribute("token"));
        try {
            User userTraining = userService.getUserOfToken(token);
            Institution institution = userTraining.getInstitution();
            SimpleDateFormat formatter = new SimpleDateFormat("dd/MM/yyyy");
            Date date = formatter.parse(req.getParameter("date"));
            long longitude = Long.parseLong(req.getParameter("num_longitude"));
            long latitude = Long.parseLong(req.getParameter("num_latitude"));
            int minBPM = Integer.parseInt(req.getParameter("num_min_bpm"));
            int maxBPM = Integer.parseInt(req.getParameter("num_max_bpm"));
            String sportName = req.getParameter("sport");
            Sport sportAux = trainerService.getSportByName(sportName);
            String players = req.getParameter("players_list");
            Map<Athlete, Device> athleteDeviceMap = createAthleteDeviceMap(players);
            int part = athleteDeviceMap.keySet().size();
            String name = createTrainingName(institution, sportAux);
            Map<User, Permission> permissionMap = Maps.newHashMap();
            permissionMap.put(userTraining, Permission.CREATE);
            Training training = new Training(name, date, part, longitude, latitude, minBPM, maxBPM,
                                             athleteDeviceMap, null, sportAux, permissionMap, institution);
            trainerService.addTraining(training, token);
            resp.sendRedirect("training/trainings.jsp");
        } catch (AuthenticationException e) {
            req.setAttribute("error", "Error de autentificación");
        } catch (InvalidTrainingException e) {
            req.setAttribute("error", "Entrenamiento invalido");
        } catch (com.mapps.services.user.exceptions.AuthenticationException e) {
            //2:Error de autentificacion
            resp.sendRedirect("training/create_training.jsp?error=2");
        } catch (ParseException e) {
            logger.error("Date fromat exception");
            throw new IllegalStateException();
        } catch (InvalidAthleteException e) {
            logger.error("Invalid Athlete");
            throw new IllegalStateException();
        }
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
