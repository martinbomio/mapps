package com.mapps.servlets;

import com.mapps.model.Institution;
import com.mapps.model.Role;
import com.mapps.services.institution.InstitutionService;
import com.mapps.services.institution.exceptions.AuthenticationException;
import com.mapps.services.institution.exceptions.InvalidInstitutionException;
import com.mapps.services.trainer.TrainerService;
import com.mapps.services.user.UserService;

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
@WebServlet(name = "addInstitution", urlPatterns = "/addInstitution/*")
public class AddInstitutionServlet extends HttpServlet implements Servlet {

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
        String description=req.getParameter("description");
        String country=req.getParameter("country");

        Institution institution=new Institution(name,description,country);

        try {
            institutionService.createInstitution(institution,token);
            req.setAttribute("info","La institución fue ingresada al sistema con éxito");
        } catch (AuthenticationException e) {
            req.setAttribute("error", "Error de autentificación");
        } catch (InvalidInstitutionException e) {
            req.setAttribute("error", "Institución invalida");
        }


    }
}
