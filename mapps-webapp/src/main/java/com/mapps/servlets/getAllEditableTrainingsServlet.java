package com.mapps.servlets;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.mapps.model.Training;
import com.mapps.services.trainer.TrainerService;
import com.mapps.services.trainer.exceptions.AuthenticationException;
import com.mapps.services.user.UserService;
import com.mapps.wrappers.TrainingWrapper;

import javax.ejb.EJB;
import javax.servlet.Servlet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.Writer;
import java.util.ArrayList;
import java.util.List;

/**
 *
 */
@WebServlet(name = "getAllEditableTrainings", urlPatterns = "/getAllEditableTrainings/*")
public class GetAllEditableTrainingsServlet extends HttpServlet implements Servlet {
    @EJB(beanName = "TrainerService")
    protected TrainerService trainerService;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Writer writer = resp.getWriter();
        String token = String.valueOf(req.getSession().getAttribute("token"));
        List<Training> trainings = null;
        List<TrainingWrapper> trainingWrappers =new ArrayList<TrainingWrapper>();
        try {
            trainings = trainerService.getAllEditableTrainings(token);
            resp.setContentType("application/json");
            Gson gson = new GsonBuilder().setDateFormat("dd/MM/yyyy HH:mm").create();
            for(int i=0;i<trainings.size();i++){
                 trainingWrappers.add(new TrainingWrapper(trainings.get(i)));
            }
            String json = gson.toJson(trainingWrappers);
            writer.write(json);
            writer.close();
        } catch (AuthenticationException e) {
            e.printStackTrace();  //To change body of catch statement use File | Settings | File Templates.
        }
    }

}
