package com.mapps.servlets;

import java.io.IOException;
import javax.ejb.EJB;
import javax.servlet.Servlet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.mapps.model.Role;
import com.mapps.model.User;
import com.mapps.services.admin.AdminService;
import com.mapps.services.admin.exceptions.AuthenticationException;
import com.mapps.services.admin.exceptions.InvalidUserException;
import com.mapps.services.institution.InstitutionService;
import com.mapps.services.trainer.TrainerService;
import com.mapps.services.user.UserService;

/**
 *
 */
@WebServlet(name = "deleteUser", urlPatterns = "/deleteUser/*")
public class DeleteUserServlet extends HttpServlet implements Servlet {
    @EJB(beanName = "UserService")
    UserService userService;
    @EJB(beanName = "TrainerService")
    TrainerService trainerService;
    @EJB(beanName = "AdminService")
    AdminService adminService;
    @EJB(beanName = "InstitutionService")
    InstitutionService institutionService;

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String token = String.valueOf(req.getSession().getAttribute("token"));

        String username = req.getParameter("username");
        try {
            User user = adminService.getUserByUsername(username);
            adminService.deleteUser(user, token);
            req.setAttribute("info", "El usuario fue borrado del sistema con éxito");
        } catch (InvalidUserException e) {
            req.setAttribute("error", "Usuario no valido");
        } catch (AuthenticationException e) {
            req.setAttribute("error", "Error de autentificación");
        }
    }

}
