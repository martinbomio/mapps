package com.mapps.servlets;

import java.io.IOException;
import java.io.Writer;
import javax.ejb.EJB;
import javax.servlet.Servlet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.mapps.model.Training;
import com.mapps.services.institution.InstitutionService;
import com.mapps.services.institution.exceptions.AuthenticationException;
import com.mapps.wrappers.TrainingWrapper;

/**
 *
 */
@WebServlet(name = "getStartedTraining", urlPatterns = "/getStartedTraining/*")
public class GetStartedTrainingServlet extends HttpServlet implements Servlet {
    @EJB(beanName = "InstitutionService")
    protected InstitutionService institutionService;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String token = String.valueOf(req.getSession().getAttribute("token"));
        Writer writer = resp.getWriter();
        try {
            Training training = institutionService.getStartedTrainingOfInstitution(token);
            if (training == null) {
                String aux = "not started";
                writer.write(aux);
                writer.close();
            } else {
                Gson gson = new GsonBuilder().setDateFormat("dd/MM/yyyy HH:mm").create();
                TrainingWrapper trainingWrapper = new TrainingWrapper(training);
                String json = gson.toJson(trainingWrapper);
                writer.write(json);
                writer.close();
            }
        } catch (AuthenticationException e) {
            e.printStackTrace();
        }

    }

}
