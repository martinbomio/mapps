package com.mapps.servlets;

import com.google.gson.Gson;
import com.mapps.model.Training;
import com.mapps.services.trainer.TrainerService;
import com.mapps.services.user.UserService;

import javax.ejb.EJB;
import javax.servlet.Servlet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.Writer;
import java.util.List;

/**
 *
 */
@WebServlet(name = "getAllTrainings", urlPatterns = "/getAllTrainings/*")
public class getAllTrainingsServlet extends HttpServlet implements Servlet {
    @EJB(beanName = "TrainerService")
    protected TrainerService trainerService;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Writer writer = resp.getWriter();
        String token = String.valueOf(req.getSession().getAttribute("token"));
        //List<Training> trainings = trainerService.getAllEditableTrainings(token);
        resp.setContentType("application/json");
       // String json = new Gson().toJson(trainings);
        //writer.write(json);
        writer.close();
    }

}
