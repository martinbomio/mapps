package com.mapps.servlets;

import java.io.IOException;
import javax.ejb.EJB;
import javax.servlet.Servlet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;

import com.mapps.model.Athlete;
import com.mapps.model.Gender;
import com.mapps.services.institution.InstitutionService;
import com.mapps.services.trainer.TrainerService;
import com.mapps.services.trainer.exceptions.AuthenticationException;
import com.mapps.services.trainer.exceptions.InvalidAthleteException;
import com.mapps.services.user.UserService;

/**
 *
 */
@WebServlet(name = "modifyAthlete", urlPatterns = "/modifyAthlete/*")
public class ModifyAthleteServlet extends HttpServlet implements Servlet {
    Logger logger = Logger.getLogger(ModifyAthleteServlet.class);
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
        String lastName = req.getParameter("lastName");
        Gender gender = Gender.UNKNOWN;
        if (req.getParameter("gender_list").equalsIgnoreCase("hombre")) {
            gender = Gender.MALE;
        } else if (req.getParameter("gender_list").equalsIgnoreCase("mujer")) {
            gender = Gender.FEMALE;
        }
        String email = req.getParameter("email");
        double weight = Double.parseDouble(req.getParameter("weight"));
        double height = Double.parseDouble(req.getParameter("height"));
        String idDocument = req.getParameter("document");
        try {
            Athlete athlete = trainerService.getAthleteByIdDocument(idDocument);
            athlete.setName(name);
            athlete.setLastName(lastName);
            athlete.setGender(gender);
            athlete.setEmail(email);
            athlete.setWeight(weight);
            athlete.setHeight(height);

            trainerService.modifyAthlete(athlete, token);
            resp.sendRedirect("athletes/athletes.jsp");
        } catch (InvalidAthleteException e) {
            //error 1: Atleta no valido
            resp.sendRedirect("athletes/edit_athletes.jsp?error=1");
        } catch (AuthenticationException e) {
            //error 2: Error de autetificacion
            resp.sendRedirect("athletes/edit_athletes.jsp?error=2");
        }

    }

}
