package com.mapps.servlets;

import com.google.common.collect.Maps;
import com.google.gson.Gson;
import com.mapps.services.trainer.TrainerService;

import javax.ejb.EJB;
import javax.servlet.Servlet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.Writer;
import java.util.List;
import java.util.Map;

/**
 *
 */
@WebServlet(name = "getAllDevicesDirs", urlPatterns = "/getAllDevicesDirs/*")
public class GetAllDevicesDirsServlet extends HttpServlet implements Servlet {


    @EJB(beanName = "TrainerService")
    protected TrainerService trainerService;



    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        List<String> devicesDirs = trainerService.getAllDevicesDirs();
        Writer writer = resp.getWriter();
        resp.setContentType("application/json");
        Map<String,String[]> map= Maps.newHashMap();
        map.put("name",devicesDirs.toArray(new String[devicesDirs.size()]));
        String json=new Gson().toJson(map);
        writer.write(json);
        writer.close();
    }
}
