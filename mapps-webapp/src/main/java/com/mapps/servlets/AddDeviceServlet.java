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
import com.mapps.model.User;
import com.mapps.services.admin.AdminService;
import com.mapps.services.admin.exceptions.DeviceAlreadyExistsException;
import com.mapps.services.institution.InstitutionService;
import com.mapps.services.trainer.TrainerService;
import com.mapps.services.user.UserService;
import com.mapps.services.user.exceptions.AuthenticationException;
import com.mapps.services.util.Constants;

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
        String token = String.valueOf(req.getSession().getAttribute("token"));

        String dirHigh = Constants.DIRHIGH;
        String dirLow = req.getParameter("dirLow");
        int panId = Integer.parseInt(req.getParameter("panId"));
        String instName = req.getParameter("institution");
        Institution instAux = institutionService.getInstitutionByName(instName);


        try {
            if(instAux==null){
                User user = userService.getUserOfToken(token);
                String institutionOfUser = user.getInstitution().getName();
                instAux = institutionService.getInstitutionByName(institutionOfUser);
            }

            Device device = new Device(dirHigh, dirLow, panId, instAux);
            device.setAvailable(true);
            adminService.addDevice(device, token);
            resp.sendRedirect("index.jsp?info=2");
        } catch (com.mapps.services.admin.exceptions.InvalidDeviceException e) {
        	resp.sendRedirect("configuration/add_device.jsp?error=1");
        } catch (DeviceAlreadyExistsException e) {
        	resp.sendRedirect("configuration/add_device.jsp?error=1");
        } catch (com.mapps.services.admin.exceptions.AuthenticationException e) {
            resp.sendRedirect("configuration/add_device.jsp?error=1");
        } catch (AuthenticationException e) {
            resp.sendRedirect("configuration/add_device.jsp?error=1");
        }
    }
}
