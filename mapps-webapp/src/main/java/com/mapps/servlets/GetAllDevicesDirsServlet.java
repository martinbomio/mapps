package com.mapps.servlets;

import java.io.IOException;
import java.io.Writer;
import java.util.List;
import java.util.Map;
import javax.ejb.EJB;
import javax.servlet.Servlet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.common.collect.Maps;
import com.google.gson.Gson;
import com.mapps.model.Device;
import com.mapps.services.admin.AdminService;

/**
 *
 */
@WebServlet(name = "getAllDevices", urlPatterns = "/getAllDevices/*")
public class GetAllDevicesDirsServlet extends HttpServlet implements Servlet {
    @EJB(beanName = "AdminService")
    protected AdminService adminService;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        List<Device> devices = adminService.getAllDevices();
        Writer writer = resp.getWriter();
        resp.setContentType("application/json");
        Map<String, Device[]> map = Maps.newHashMap();
        map.put("devices", devices.toArray(new Device[devices.size()]));
        String json = new Gson().toJson(map);
        writer.write(json);
        writer.close();
    }
}
