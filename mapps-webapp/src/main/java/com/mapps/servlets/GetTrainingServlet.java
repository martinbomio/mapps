package com.mapps.servlets;

import java.io.IOException;
import java.io.Writer;
import javax.ejb.EJB;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.mapps.exceptions.NullParameterException;
import com.mapps.model.Training;
import com.mapps.services.trainer.TrainerService;
import com.mapps.services.trainer.exceptions.AuthenticationException;
import com.mapps.services.trainer.exceptions.InvalidTrainingException;

/**
 *
 *
 */
@WebServlet(name = "getTraining", urlPatterns = "/getTraining/*")
public class GetTrainingServlet extends HttpServlet{
    @EJB(beanName = "TrainerService")
    protected TrainerService trainerService;

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String token = String.valueOf(req.getSession().getAttribute("token"));
        String trainingName = req.getParameter("training");
        try {
            Training training = trainerService.getTrainingByName(token, trainingName);
            Gson gson = new GsonBuilder().setDateFormat("dd/MM/yyyy HH:mm").create();
            String json = gson.toJson(training);
            Writer writer = resp.getWriter();
            writer.write(json);
            writer.close();
        } catch (InvalidTrainingException e) {
            resp.sendError(1, "El training no existe");
        } catch (AuthenticationException e) {
            resp.sendError(2, "Error de Autenticación");
        } catch (NullParameterException e) {
            resp.sendError(1, "el entrenamineto no existe");
        }
    }
}
