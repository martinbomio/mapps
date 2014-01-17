package com.mapps.servlets;

import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import javax.ejb.EJB;
import javax.servlet.Servlet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.mapps.model.*;
import com.mapps.services.institution.InstitutionService;
import com.mapps.services.trainer.TrainerService;
import com.mapps.services.trainer.exceptions.AuthenticationException;
import com.mapps.services.trainer.exceptions.InvalidTrainingException;
import com.mapps.services.user.UserService;
import org.apache.log4j.Logger;

/**
 *
 */
@WebServlet(name = "addTraining", urlPatterns = "/addTraining/*")
public class AddTrainingServlet extends HttpServlet implements Servlet {
    Logger logger= Logger.getLogger(AddTrainingServlet.class);
    @EJB(beanName = "UserService")
    UserService userService;
    @EJB(beanName = "TrainerService")
    TrainerService trainerService;
    @EJB(beanName = "InstitutionService")
    InstitutionService institutionService;

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String token = String.valueOf(req.getSession().getAttribute("token"));
        String userTraining="";
        try {
            userTraining=userService.getUserOfToken(token);
        } catch (com.mapps.services.user.exceptions.AuthenticationException e) {
            //2:Error de autentificacion
            resp.sendRedirect("training/create_training.jsp?error=2");
        }
        SimpleDateFormat formatter = new SimpleDateFormat("dd/MM/yyyy");
        Date date = null;
        try {
            date = formatter.parse(req.getParameter("date"));
        } catch (ParseException e) {
            logger.error("Date fromat exception");
            throw new IllegalStateException();
        }
        int part = Integer.parseInt(req.getParameter("participants"));
        long longitude = Long.parseLong(req.getParameter("longitude"));
        long latitude = Long.parseLong(req.getParameter("latitude"));
        int minBPM = Integer.parseInt(req.getParameter("minBPM"));
        int maxBPM = Integer.parseInt(req.getParameter("maxBPM"));
        String sportName = req.getParameter("sport");
        Sport sportAux = trainerService.getSportByName(sportName);
        String instName = req.getParameter("institution");
        Institution instAux = institutionService.getInstitutionByName(instName);


        String dateString=String.valueOf(date);
        String name=dateString+"-"+userTraining+"-"+sportName;


        Training training = new Training(name, date, part, longitude, latitude, minBPM, maxBPM,
                                         null, null, sportAux, null, instAux);
        try {
            trainerService.addTraining(training, token);
            req.setAttribute("info", "El entrenamiento fue ingresado con exito en el sistema");
        } catch (AuthenticationException e) {
            req.setAttribute("error", "Error de autentificación");
        } catch (InvalidTrainingException e) {
            req.setAttribute("error", "Entrenamiento invalido");
        }
    }
}
