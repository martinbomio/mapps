package com.mapps.servlets;

import com.mapps.model.Athlete;
import com.mapps.model.Role;
import com.mapps.services.institution.InstitutionService;
import com.mapps.services.trainer.TrainerService;
import com.mapps.services.trainer.exceptions.AuthenticationException;
import com.mapps.services.trainer.exceptions.InvalidAthleteException;
import com.mapps.services.user.UserService;

import javax.ejb.EJB;
import javax.servlet.Servlet;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 *
 */
public class DeleteAthleteServlet extends HttpServlet implements Servlet {

    @EJB(beanName="UserService")
    UserService userService;

    @EJB(beanName="TrainerService")
    TrainerService trainerService;

    @EJB(beanName="institutionService")
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

        String idDocument=req.getParameter("idDocument");
        try {
            Athlete delAthlete=trainerService.getAthleteByIdDocument(idDocument);
            delAthlete.setEnabled(false);
            trainerService.modifyAthlete(delAthlete,token);
            req.setAttribute("info","El atleta fue eliminado del sistema");
        } catch (InvalidAthleteException e) {
            req.setAttribute("error","Atleta no valido");
        } catch (AuthenticationException e) {
            req.setAttribute("error","error de autentificación");
        }

    }

}
