package com.mapps.servlets;

import java.io.IOException;
import javax.ejb.EJB;
import javax.servlet.Servlet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.mapps.exceptions.NullParameterException;
import com.mapps.model.Training;
import com.mapps.services.institution.InstitutionService;
import com.mapps.services.trainer.TrainerService;
import com.mapps.services.trainer.exceptions.AuthenticationException;
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
        String name = req.getParameter("name");
        try {
            Training training = trainerService.getTrainingByName(token, name);
            trainerService.startTraining(training, token);
            req.setAttribute("info", "El entrenamiento comenzó");
        } catch (AuthenticationException e) {
            req.setAttribute("error", "Error de autentificación");

        } catch (InvalidTrainingException e) {
            req.setAttribute("error", "Entrenamiento no valido");
        } catch (NullParameterException e) {
            e.printStackTrace();  //To change body of catch statement use File | Settings | File Templates.
        }
    }
}
