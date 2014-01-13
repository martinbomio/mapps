package com.mapps.servlets;

import com.mapps.model.Device;
import com.mapps.model.Institution;
import com.mapps.model.Role;
import com.mapps.services.institution.InstitutionService;
import com.mapps.services.trainer.TrainerService;
import com.mapps.services.trainer.exceptions.AuthenticationException;
import com.mapps.services.trainer.exceptions.InvalidDeviceException;
import com.mapps.services.user.UserService;

import javax.ejb.EJB;
import javax.servlet.Servlet;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 *
 */
public class AddDeviceServlet extends HttpServlet implements Servlet {

    @EJB(beanName="UserService")
    UserService userService;

    @EJB(beanName="TrainerService")
    TrainerService trainerService;

    @EJB(beanName="institutionService")
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

        String dirHigh="0013A200";
        String dirLow=req.getParameter("dirLow");
        int panId=Integer.parseInt(req.getParameter("panId"));
        String instName=req.getParameter("institution");
        Institution instAux=institutionService.getInstitutionByName(instName);

        Device device=new Device(dirHigh,dirLow,panId,instAux);
        device.setAvailable(true);
        try {
            trainerService.addDevice(device,token);

        } catch (InvalidDeviceException e) {
           req.setAttribute("error","Invalid device");

        } catch (AuthenticationException e) {
            req.setAttribute("error","Authentication error");

        }
    }
}
