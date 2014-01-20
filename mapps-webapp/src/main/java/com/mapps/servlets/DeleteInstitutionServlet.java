package com.mapps.servlets;

import java.io.IOException;
import java.util.List;
import javax.ejb.EJB;
import javax.servlet.Servlet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import com.mapps.model.Institution;
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
        String json = req.getParameter("json");
        List<Institution> institutions = new Gson().fromJson(json, new TypeToken<List<Institution>>() {
        }.getType());
        try {
            for (Institution institution : institutions) {
                Institution inst = institutionService.getInstitutionByName(institution.getName());
                institutionService.deleteInstitution(inst, token);
            }
        } catch (AuthenticationException e) {
            //Error de autentificación
            resp.sendError(1, "configuration/delete_institution.jsp?error=1");
        } catch (InvalidInstitutionException e) {
            //Institución no válida
            resp.sendError(2, "delete_institution.jsp?error=2");
        }

    }

}
