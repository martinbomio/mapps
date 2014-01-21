package com.mapps.servlets;

import java.io.IOException;
import java.io.Writer;
import java.util.List;
import javax.ejb.EJB;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.gson.Gson;
import com.mapps.model.Device;
import com.mapps.services.institution.InstitutionService;
import com.mapps.services.institution.exceptions.AuthenticationException;

/**
 *
 *
 */
@WebServlet(name = "getAllDevicesOfInstitution", urlPatterns = "/getAllDevicesOfInstitution/*")
public class GetAllDevicesOfInstitutionServlet extends HttpServlet{
    @EJB(beanName = "InstitutionService")
    protected InstitutionService institutionService;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String token = String.valueOf(req.getSession().getAttribute("token"));
        try {
            List<Device> devices = institutionService.getDeviceOfInstitution(token);
            String json = new Gson().toJson(devices);
            Writer writer = resp.getWriter();
            writer.write(json);
            writer.close();
        } catch (AuthenticationException e) {
            //Authentication error
            resp.sendError(1, "Authentication error");
        }
    }
}
