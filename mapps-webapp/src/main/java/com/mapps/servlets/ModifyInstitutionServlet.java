package com.mapps.servlets;

import com.mapps.model.Institution;
import com.mapps.services.institution.InstitutionService;
import com.mapps.services.institution.exceptions.AuthenticationException;
import com.mapps.services.institution.exceptions.InvalidInstitutionException;
import com.mapps.services.trainer.TrainerService;
import com.mapps.services.user.UserService;
import org.apache.log4j.Logger;

import javax.ejb.EJB;
import javax.servlet.Servlet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 *
 */
@WebServlet(name = "modifyInstitution", urlPatterns = "/modifyInstitution/*")
public class ModifyInstitutionServlet extends HttpServlet implements Servlet {

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
        String description = req.getParameter("description");
        String country = req.getParameter("country");

        Institution newInst=institutionService.getInstitutionByName(name);
        newInst.setDescription(description);
        newInst.setCountry(country);

        try {
            institutionService.updateInstitution(newInst, token);
            resp.sendRedirect("configuration/configuration.jsp?");
        } catch (AuthenticationException e) {
            //2:error de autentificacion
            resp.sendRedirect("configuration/edit_institution.jsp?error=2");
        } catch (InvalidInstitutionException e) {
            resp.sendRedirect("configuration/edit_institution.jsp?error=1");

        }
    }
}
