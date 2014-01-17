package com.mapps.servlets;

import java.io.IOException;
import javax.ejb.EJB;
import javax.servlet.Servlet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.mapps.model.Athlete;
import com.mapps.model.Role;
import com.mapps.services.institution.InstitutionService;
import com.mapps.services.trainer.TrainerService;
import com.mapps.services.trainer.exceptions.AuthenticationException;
import com.mapps.services.trainer.exceptions.InvalidAthleteException;
import com.mapps.services.user.UserService;

/**
 *
 */
@WebServlet(name = "deleteAthlete", urlPatterns = "/deleteAthlete/*")
public class DeleteAthleteServlet extends HttpServlet implements Servlet {
    @EJB(beanName = "UserService")
    UserService userService;
    @EJB(beanName = "TrainerService")
    TrainerService trainerService;
    @EJB(beanName = "InstitutionService")
    InstitutionService institutionService;

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String token = String.valueOf(req.getSession().getAttribute("token"));

        String idDocument = req.getParameter("idDocument");
        try {
            Athlete delAthlete = trainerService.getAthleteByIdDocument(idDocument);
            trainerService.deleteAthlete(delAthlete, token);
            resp.sendRedirect("athletes/athletes.jsp?");
        } catch (InvalidAthleteException e) {
            //1:Error atleta no valido
            resp.sendRedirect("athletes/delete_athletes.jsp?error=1");
        } catch (AuthenticationException e) {
            //1:Error atleta no valido
            resp.sendRedirect("athletes/delete_athletes.jsp?error=2");
        }
    }
}
