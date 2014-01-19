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

import com.google.gson.Gson;
import com.mapps.model.Sport;
import com.mapps.services.user.UserService;

/**
 *
 */
@WebServlet(name = "getAllSports", urlPatterns = "/getAllSports/*")
public class GetAllSportsServlet extends HttpServlet implements Servlet {
    @EJB(beanName = "UserService")
    protected UserService userService;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        List<Sport> sports = userService.getAllSports();
        Writer writer = resp.getWriter();
        resp.setContentType("application/json");
        String json = new Gson().toJson(sports);
        writer.write(json);
        writer.close();
    }

}
