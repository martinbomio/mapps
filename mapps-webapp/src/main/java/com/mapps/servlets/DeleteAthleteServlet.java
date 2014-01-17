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

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import com.mapps.model.Athlete;
import com.mapps.services.trainer.TrainerService;
import com.mapps.services.trainer.exceptions.AuthenticationException;
import com.mapps.services.trainer.exceptions.InvalidAthleteException;

/**
 *
 */
@WebServlet(name = "deleteAthlete", urlPatterns = "/deleteAthlete/*")
public class DeleteAthleteServlet extends HttpServlet implements Servlet {
    @EJB(beanName = "TrainerService")
    protected TrainerService trainerService;

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String token = String.valueOf(req.getSession().getAttribute("token"));
        String json = String.valueOf(req.getParameter("json"));
        List<Map<String, String>> elements = new Gson().fromJson(json, new TypeToken<List<Map<String, String>>>() {
        }.getType());
        for (Map<String, String> map : elements) {
            try {
                Athlete delAthlete = trainerService.getAthleteByIdDocument(map.get("idDocument"));
                trainerService.deleteAthlete(delAthlete, token);
            } catch (InvalidAthleteException e) {
                //1:Error atleta no valido
                resp.sendError(1, "El Atleta: " + map.get("name") + " no pudo ser eliminado.");
            } catch (AuthenticationException e) {
                //1:Error atleta no valido
                resp.sendError(2, "No cuenta con permisos suficientes para eliminar este atleta");
            }
        }
    }
}
