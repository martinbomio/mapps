package com.mapps.servlets;

import java.io.IOException;
import java.io.Writer;
import java.util.List;
import javax.ejb.EJB;
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

/**
 *
 *
 */
@WebServlet(name = "getTrainingsToStart", urlPatterns = "/getTrainingsToStart/*")
public class GetTraingingsToStartForInstitution extends HttpServlet{
    @EJB(beanName = "InstitutionService")
    protected InstitutionService institutionService;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String token = String.valueOf(req.getSession().getAttribute("token"));
        try {
            List<Training> trainings = institutionService.getTraingsToStartOfInstitution(token);
            Gson gson = new GsonBuilder().setDateFormat("dd/MM/yyyy HH:mm").create();
            String json = gson.toJson(trainings);
            Writer writer = resp.getWriter();
            writer.write(json);
            writer.close();
        } catch (AuthenticationException e) {
            resp.sendError(1, "Authentication error");
        }
    }
}
