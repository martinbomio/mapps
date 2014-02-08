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
import com.google.gson.GsonBuilder;
import com.mapps.jsonexclusions.PulseReportExclusionStrategy;
import com.mapps.model.PulseReport;
import com.mapps.services.report.ReportService;
import com.mapps.services.report.exceptions.AuthenticationException;

/**
 * Returns the pulse data in real time
 */
@WebServlet(name = "GetTrainingPulseData", urlPatterns = "/getTrainingPulseData/*")
public class GetTrainingPulseData extends HttpServlet {
    @EJB(beanName = "ReportService")
    ReportService reportService;

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String token = String.valueOf(req.getSession().getAttribute("token"));
        String trainingName = req.getParameter("t");
        Writer writer = resp.getWriter();
        try {
            List<PulseReport> reports = reportService.getPulseDataOfTraining(trainingName, token);
            resp.setContentType("application/json");
            resp.setCharacterEncoding("UTF-8");
            PulseReportExclusionStrategy strategy = new PulseReportExclusionStrategy();
            Gson gson = new GsonBuilder().setExclusionStrategies(strategy).create();
            String json = gson.toJson(reports);
            writer.write(json);
        } catch (AuthenticationException e) {
            writer.write("Error de autenticacion");
        } finally {
            writer.close();
        }
    }
}
