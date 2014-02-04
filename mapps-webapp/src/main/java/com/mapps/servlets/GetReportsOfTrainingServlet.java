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
import com.mapps.model.Report;
import com.mapps.services.report.ReportService;
import com.mapps.services.report.exceptions.AuthenticationException;

/**
 *
 */
@WebServlet(name = "getReportsOfTraining", urlPatterns = "/getReportsOfTraining/*")
public class GetReportsOfTrainingServlet extends HttpServlet implements Servlet {
    private static Logger logger = Logger.getLogger(GetReportsOfTrainingServlet.class);
    @EJB(beanName = "ReportService")
    ReportService reportService;

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String trainingID = req.getParameter("t");
        String token = String.valueOf(req.getSession().getAttribute("token"));

        try {
            Writer writer = resp.getWriter();
            List<Report> reports = reportService.getReportsOfTraining(trainingID, token);
            resp.setContentType("application/json");
            resp.setCharacterEncoding("UTF-8");
            String json = new Gson().toJson(reports);
            writer.write(json);
            writer.close();
        } catch (AuthenticationException e) {

        }
    }
}
