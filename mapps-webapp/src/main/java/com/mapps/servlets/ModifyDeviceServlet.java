package com.mapps.servlets;

import com.mapps.model.Device;
import com.mapps.model.Institution;
import com.mapps.services.admin.AdminService;
import com.mapps.services.admin.exceptions.AuthenticationException;
import com.mapps.services.institution.InstitutionService;
import com.mapps.services.trainer.TrainerService;
import com.mapps.services.trainer.exceptions.InvalidDeviceException;
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
@WebServlet(name = "modifyDevice", urlPatterns = "/modifyDevice/*")
public class ModifyDeviceServlet extends HttpServlet implements Servlet {

    Logger logger = Logger.getLogger(ModifyAthleteServlet.class);
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
        
        String dirLow = req.getParameter("dirLow");
        String panId = req.getParameter("panId");
        String id = req.getParameter("id-hidden");

        try {
            Device device=trainerService.getDeviceById(Long.valueOf(id));
            
            device.setDirLow(dirLow);
            device.setPanId(Integer.valueOf(panId));
            adminService.modifyDevice(device,token);
            resp.sendRedirect("configuration/configuration_main.jsp?info=7");
        } catch (InvalidDeviceException e) {
            resp.sendRedirect("configuration/edit_device.jsp");
        } catch (com.mapps.services.admin.exceptions.InvalidDeviceException e) {
            resp.sendRedirect("configuration/edit_device.jsp");
        } catch (AuthenticationException e) {
            resp.sendRedirect("configuration/edit_device.jsp");
        }

    }
}
