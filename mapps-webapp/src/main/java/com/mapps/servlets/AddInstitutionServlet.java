package com.mapps.servlets;

import java.io.IOException;
import java.net.URI;
import java.net.URISyntaxException;
import javax.ejb.EJB;
import javax.servlet.Servlet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.mapps.model.Institution;
import com.mapps.services.institution.InstitutionService;
import com.mapps.services.institution.exceptions.AuthenticationException;
import com.mapps.services.institution.exceptions.InvalidInstitutionException;
import com.mapps.services.trainer.TrainerService;
import com.mapps.services.user.UserService;
import com.mapps.utils.Constants;

/**
 *
 */
@WebServlet(name = "addInstitution", urlPatterns = "/addInstitution/*")
public class AddInstitutionServlet extends HttpServlet implements Servlet {
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

        Institution institution = new Institution(name, description, country);
        try {
            institution.setImageURI(new URI(Constants.DEFAULT_INSTITUTION_IMAGE));
            institutionService.createInstitution(institution, token);
            resp.sendRedirect("configuration/configuration_main.jsp");
        } catch (AuthenticationException e) {
            resp.sendRedirect("configuration/add_institution.jsp?error=Error de autentificación");
        } catch (InvalidInstitutionException e) {
        	resp.sendRedirect("configuration/add_institution.jsp?error=Instituci�n no v�lida");
        } catch (URISyntaxException e) {
            new IllegalStateException();
        }
    }
}
