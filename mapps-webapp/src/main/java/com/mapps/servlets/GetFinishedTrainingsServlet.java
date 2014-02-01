package com.mapps.servlets;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.mapps.model.Training;
import com.mapps.services.institution.InstitutionService;
import com.mapps.services.institution.exceptions.AuthenticationException;
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
@WebServlet(name = "getFinishedTrainings", urlPatterns = "/getFinishedTrainings/*")
public class GetFinishedTrainingsServlet extends HttpServlet implements Servlet {
    @EJB(beanName = "InstitutionService")
    protected InstitutionService institutionService;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String token = String.valueOf(req.getSession().getAttribute("token"));
        Writer writer = resp.getWriter();
        List<TrainingWrapper> trainingWrappers =new ArrayList<TrainingWrapper>();
        try {
            List<Training> trainings=institutionService.getFinishedTrainingsOfInstitution(token);
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
