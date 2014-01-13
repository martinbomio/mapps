package com.mapps.servlets;

import com.mapps.model.Permission;
import com.mapps.model.Role;
import com.mapps.model.Training;
import com.mapps.model.User;
import com.mapps.services.admin.AdminService;
import com.mapps.services.admin.exceptions.AuthenticationException;
import com.mapps.services.admin.exceptions.InvalidUserException;
import com.mapps.services.institution.InstitutionService;
import com.mapps.services.trainer.TrainerService;
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

/**
 *
 */
@WebServlet(name = "changePermission", urlPatterns = "/changePermission/*")
public class ChangePermissionServlet extends HttpServlet implements Servlet {

    @EJB(beanName="UserService")
    UserService userService;

    @EJB(beanName="TrainerService")
    TrainerService trainerService;

    @EJB(beanName="InstitutionService")
    InstitutionService institutionService;

    @EJB(beanName="AdminService")
    AdminService adminService;

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)throws ServletException, IOException {
        String token = req.getParameter("token");
        Role userRole= null;
        try {
            userRole = userService.userRoleOfToken(token);
        } catch (com.mapps.services.user.exceptions.InvalidUserException e) {
            req.setAttribute("error","Usuario no válido");
        } catch (com.mapps.services.user.exceptions.AuthenticationException e) {
            req.setAttribute("error", "Error de autentificación");
        }
        req.setAttribute("token", token);
        req.setAttribute("role",userRole);

        String trainingName=req.getParameter("trainingName");
        String username=req.getParameter("username");
        Permission perm=null;
        if(req.getParameter("permission")=="2"){
            perm=Permission.CREATE;
        } else{
            perm=Permission.READ;
        }
        try{
        Training training=trainerService.getTrainingByName(trainingName);
        User user=adminService.getUserByUsername(username);
        adminService.changePermissions(training,user,perm,token);
        } catch (InvalidUserException e) {
            req.setAttribute("error", "Usuario no válido");
        } catch (AuthenticationException e) {
            req.setAttribute("error", "Error de autentificación");
        } catch (InvalidTrainingException e) {
            req.setAttribute("error", "Entrenamiento no válido");
        }

    }
}
