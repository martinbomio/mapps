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
import com.mapps.services.institution.InstitutionService;


/**
 *
 */
@WebServlet(name = "getAllInstitutions", urlPatterns = "/getAllInstitutions/*")
public class GetAllInstitutionsServlet extends HttpServlet implements Servlet {
    Logger logger = Logger.getLogger(GetAllInstitutionsServlet.class);
    @EJB(beanName = "InstitutionService")
    protected InstitutionService institutionService;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        List<String> instNames = institutionService.allInstitutionsNames();
        Writer writer = resp.getWriter();
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        String json = new Gson().toJson(instNames);
        writer.write(json);
        writer.close();
    }
}
