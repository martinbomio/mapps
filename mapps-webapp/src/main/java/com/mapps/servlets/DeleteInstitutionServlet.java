package com.mapps.servlets;

import java.io.IOException;
import javax.ejb.EJB;
import javax.servlet.Servlet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.mapps.model.Institution;
import com.mapps.model.Role;
import com.mapps.services.admin.AdminService;
import com.mapps.services.institution.InstitutionService;
import com.mapps.services.institution.exceptions.AuthenticationException;
import com.mapps.services.institution.exceptions.InvalidInstitutionException;
import com.mapps.services.trainer.TrainerService;
import com.mapps.services.user.UserService;

/**
 *
 */
@WebServlet(name = "deleteInstitution", urlPatterns = "/deleteInstitution/*")
public class DeleteInstitutionServlet extends HttpServlet implements Servlet {
    @EJB(beanName = "UserService")
    UserService userService;
    @EJB(beanName = "TrainerService")
    TrainerService trainerService;
    @EJB(beanName = "InstitutionService")
    InstitutionService institutionService;
    @EJB(beanName = "AdminService")
    AdminService adminService;

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String token = String.valueOf(req.getSession().getAttribute("token"));

        String institutionName = req.getParameter("instName");
        Institution inst = institutionService.getInstitutionByName(institutionName);
        try {
            institutionService.deleteInstitution(inst, token);
            req.setAttribute("info", "La institución fue borrada del sistema con éxito");
        } catch (AuthenticationException e) {
            req.setAttribute("error", "Error de autentificación");
        } catch (InvalidInstitutionException e) {
            req.setAttribute("error", "Institución no válida");
        }

    }

}
