package com.mapps.servlets;

import java.io.IOException;
import javax.ejb.EJB;
import javax.servlet.Servlet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.mapps.model.Device;
import com.mapps.model.Role;
import com.mapps.services.admin.AdminService;
import com.mapps.services.institution.InstitutionService;
import com.mapps.services.trainer.TrainerService;
import com.mapps.services.trainer.exceptions.InvalidDeviceException;
import com.mapps.services.user.UserService;

/**
 *
 */
@WebServlet(name = "deleteDevice", urlPatterns = "/deleteDevice/*")
public class DeleteDeviceServlet extends HttpServlet implements Servlet {
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
        String token = req.getParameter("token");
        Role userRole = null;
        try {
            userRole = userService.userRoleOfToken(token);
        } catch (com.mapps.services.user.exceptions.InvalidUserException e) {
            req.setAttribute("error", "Usuario no valido");
        } catch (com.mapps.services.user.exceptions.AuthenticationException e) {
            req.setAttribute("error", "Error de autentificación");
        }
        req.setAttribute("token", token);
        req.setAttribute("role", userRole);

        String dirLow = req.getParameter("dirLow");
        try {
            Device device = trainerService.getDeviceByDir(dirLow);
            adminService.disableDevice(device, token);
            req.setAttribute("error", "El device fue borrado del sistema con éxito");

        } catch (InvalidDeviceException e) {
            req.setAttribute("error", "Device no valido");

        } catch (com.mapps.services.admin.exceptions.AuthenticationException e) {
            req.setAttribute("error", "Error de autentificación");

        }
    }

}

