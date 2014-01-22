package com.mapps.servlets;

import java.io.IOException;
import java.util.List;
import java.util.Map;
import javax.ejb.EJB;
import javax.servlet.Servlet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.common.collect.Maps;
import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import com.mapps.exceptions.NullParameterException;
import com.mapps.model.Athlete;
import com.mapps.model.Device;
import com.mapps.model.Training;
import com.mapps.services.institution.InstitutionService;
import com.mapps.services.trainer.TrainerService;
import com.mapps.services.trainer.exceptions.AuthenticationException;
import com.mapps.services.trainer.exceptions.InvalidAthleteException;
import com.mapps.services.trainer.exceptions.InvalidDeviceException;
import com.mapps.services.trainer.exceptions.InvalidTrainingException;
import com.mapps.services.user.UserService;

/**
 *
 */
@WebServlet(name = "startTraining", urlPatterns = "/startTraining/*")
public class StartTrainingServlet extends HttpServlet implements Servlet {
    @EJB(beanName = "UserService")
    UserService userService;
    @EJB(beanName = "TrainerService")
    TrainerService trainerService;
    @EJB(beanName = "InstitutionService")
    InstitutionService institutionService;

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String token = String.valueOf(req.getSession().getAttribute("token"));
        String trainingName = req.getParameter("hidden-name");
        String json = req.getParameter("athlete-device");
        List<Map<String, String>> elements = new Gson().fromJson(json, new TypeToken<List<Map<String, String>>>() {
        }.getType());
        try {
            Map<Athlete, Device> athleteDeviceMap = createMap(elements);
            Training training = trainerService.getTrainingByName(token, trainingName);
            training.setMapAthleteDevice(athleteDeviceMap);
            trainerService.modifyTraining(training, token);
            trainerService.startTraining(training, token);
            resp.sendRedirect("training/trainings.jsp");
        } catch (AuthenticationException e) {
            resp.sendRedirect("training/start_training.jsp?error=4");
        } catch (InvalidTrainingException e) {
            resp.sendRedirect("training/start_training.jsp?error=1");
        } catch (NullParameterException e) {
            resp.sendRedirect("training/start_training.jsp?error=1");
        } catch (InvalidAthleteException e) {
            resp.sendRedirect("training/start_training.jsp?error=2");
        } catch (InvalidDeviceException e) {
            resp.sendRedirect("training/start_training.jsp?error=3");
        }
    }

    private Map<Athlete, Device> createMap(List<Map<String, String>> elements) throws InvalidAthleteException, InvalidDeviceException {
        Map<Athlete, Device> athleteDeviceMap = Maps.newHashMap();
        for (Map<String, String> map : elements){
            Athlete athlete = trainerService.getAthleteByIdDocument(map.get("uid"));
            Device device = trainerService.getDeviceByDir(map.get("device"));
            athleteDeviceMap.put(athlete, device);
        }
        return athleteDeviceMap;
    }
}
