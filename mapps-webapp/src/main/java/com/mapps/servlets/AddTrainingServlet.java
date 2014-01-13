package com.mapps.servlets;

import com.mapps.model.Institution;
import com.mapps.model.Role;
import com.mapps.model.Sport;
import com.mapps.model.Training;
import com.mapps.services.institution.InstitutionService;
import com.mapps.services.trainer.TrainerService;
import com.mapps.services.trainer.exceptions.AuthenticationException;
import com.mapps.services.trainer.exceptions.InvalidTrainingException;
import com.mapps.services.user.UserService;

import javax.ejb.EJB;
import javax.servlet.Servlet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Date;

/**
 *
 */
@WebServlet(name = "addTraining", urlPatterns = "/addTraining/*")
public class AddTrainingServlet extends HttpServlet implements Servlet {

    @EJB(beanName="UserService")
    UserService userService;

    @EJB(beanName="TrainerService")
    TrainerService trainerService;

    @EJB(beanName="InstitutionService")
    InstitutionService institutionService;

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)throws ServletException, IOException {

        String token = req.getParameter("token");
        Role userRole= null;
        try {
            userRole = userService.userRoleOfToken(token);
        } catch (com.mapps.services.user.exceptions.InvalidUserException e) {
            req.setAttribute("error","Invalid user");
        } catch (com.mapps.services.user.exceptions.AuthenticationException e) {
            req.setAttribute("error","Authentication error");
        }
        req.setAttribute("token", token);
        req.setAttribute("role",userRole);

        String name=req.getParameter("name");
        Date date=new Date();
        int part=Integer.parseInt(req.getParameter("participants"));
        long longitude=Long.parseLong(req.getParameter("longitude"));
        long latitude=Long.parseLong(req.getParameter("latitude"));
        int minBPM=Integer.parseInt(req.getParameter("minBPM"));
        int maxBPM=Integer.parseInt(req.getParameter("maxBPM"));
        String sportName=req.getParameter("sport");
        Sport sportAux=trainerService.getSportByName(sportName);
        String instName=req.getParameter("institution");
        Institution instAux=institutionService.getInstitutionByName(instName);

        Training training=new Training(name,date,part,longitude,latitude,minBPM,maxBPM,
                null,null,sportAux,null,instAux);
        try {
            trainerService.addTraining(training,token);
            req.setAttribute("info", "El entrenamiento fue ingresado con exito en el sistema");
        } catch (AuthenticationException e) {
            req.setAttribute("error", "Error de autentificación");
        } catch (InvalidTrainingException e) {
            req.setAttribute("error", "Entrenamiento invalido");
        }
    }
}
