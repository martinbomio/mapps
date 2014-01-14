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
import com.mapps.model.Institution;
import com.mapps.model.Role;
import com.mapps.services.admin.AdminService;
import com.mapps.services.admin.exceptions.DeviceAlreadyExistsException;
import com.mapps.services.institution.InstitutionService;
import com.mapps.services.trainer.TrainerService;
import com.mapps.services.user.UserService;

/**
 *
 */
@WebServlet(name = "addDevice", urlPatterns = "/addDevice/*")
public class AddDeviceServlet extends HttpServlet implements Servlet {
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
        String token = req.getParameter("token");
        Role userRole = null;
        try {
            userRole = userService.userRoleOfToken(token);
        } catch (com.mapps.services.user.exceptions.InvalidUserException e) {
            req.setAttribute("error", "Invalid user");
        } catch (com.mapps.services.user.exceptions.AuthenticationException e) {
            req.setAttribute("error", "Authentication error");
        }
        req.setAttribute("token", token);
        req.setAttribute("role", userRole);

        String dirHigh = "0013A200";
        String dirLow = req.getParameter("dirLow");
        int panId = Integer.parseInt(req.getParameter("panId"));
        String instName = req.getParameter("institution");
        Institution instAux = institutionService.getInstitutionByName(instName);

        Device device = new Device(dirHigh, dirLow, panId, instAux);
        device.setAvailable(true);
        try {
            adminService.addDevice(device, token);
            req.setAttribute("info", "El device fue ingresado al sistema con exito");
        } catch (com.mapps.services.admin.exceptions.InvalidDeviceException e) {
            req.setAttribute("error", "Device no valido");
        } catch (DeviceAlreadyExistsException e) {
            req.setAttribute("error", "Device no valido");
        } catch (com.mapps.services.admin.exceptions.AuthenticationException e) {
            req.setAttribute("error", "Error de autentificación");
        }
    }
}
