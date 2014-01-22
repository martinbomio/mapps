package com.mapps.servlets;

import java.io.IOException;
import java.util.Map;
import javax.ejb.EJB;
import javax.servlet.Servlet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.common.collect.Maps;
import com.mapps.exceptions.NullParameterException;
import com.mapps.model.Athlete;
import com.mapps.model.Device;
import com.mapps.model.Training;
import com.mapps.services.trainer.TrainerService;
import com.mapps.services.trainer.exceptions.AuthenticationException;
import com.mapps.services.trainer.exceptions.InvalidAthleteException;
import com.mapps.services.trainer.exceptions.InvalidTrainingException;
import com.mapps.services.user.UserService;

/**
 *
 */
@WebServlet(name = "modifyTraining", urlPatterns = "/modifyTraining/*")
public class ModifyTrainingServlet extends HttpServlet implements Servlet {
    @EJB(beanName = "UserService")
    UserService userService;
    @EJB(beanName = "TrainerService")
    TrainerService trainerService;


    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String token = String.valueOf(req.getSession().getAttribute("token"));
        long longitude = Long.parseLong(req.getParameter("num_longitude"));
        long latitude = Long.parseLong(req.getParameter("num_latitude"));
        int minBPM = Integer.parseInt(req.getParameter("num_min_bpm"));
        int maxBPM = Integer.parseInt(req.getParameter("num_max_bpm"));
        String name = req.getParameter("name-hidden");
        String players = req.getParameter("players_list");
        try {
            Training training = trainerService.getTrainingByName(token, name);
            training.setLongOrigin(longitude);
            training.setLatOrigin(latitude);
            training.setMinBPM(minBPM);
            training.setMaxBPM(maxBPM);
            trainerService.modifyTraining(training, token);
            resp.sendRedirect("training/trainings.jsp");
        } catch (InvalidTrainingException e) {
            resp.sendRedirect("training/edit_training.jsp");
        } catch (AuthenticationException e) {
            resp.sendRedirect("training/edit_training.jsp");
        } catch (NullParameterException e) {
            e.printStackTrace();  //To change body of catch statement use File | Settings | File Templates.
        }
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
