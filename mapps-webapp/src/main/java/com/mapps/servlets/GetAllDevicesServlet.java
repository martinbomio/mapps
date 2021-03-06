package com.mapps.servlets;

import java.io.IOException;
import java.io.Writer;
import java.util.List;
import javax.ejb.EJB;
import javax.servlet.Servlet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;

import com.google.gson.Gson;
import com.mapps.model.Device;
import com.mapps.services.admin.AdminService;
import com.mapps.services.institution.InstitutionService;
import com.mapps.services.user.UserService;

/**
 *
 */
@WebServlet(name = "getAllDevices", urlPatterns = "/getAllDevices/*")
public class GetAllDevicesServlet extends HttpServlet implements Servlet {
    Logger logger = Logger.getLogger(GetAllInstitutionsServlet.class);
    @EJB(beanName = "InstitutionService")
    protected InstitutionService institutionService;
    @EJB(beanName = "UserService")
    protected UserService userService;
    @EJB(beanName = "AdminService")
    protected AdminService adminService;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Writer writer = resp.getWriter();
        List<Device> devices = adminService.getAllDevices();
        resp.setContentType("application/json");
        String json = new Gson().toJson(devices);
        writer.write(json);
        writer.close();
    }
}
