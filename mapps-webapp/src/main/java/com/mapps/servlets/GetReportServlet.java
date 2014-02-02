package com.mapps.servlets;

import com.google.gson.Gson;
import com.mapps.exceptions.InvalidReportException;
import com.mapps.model.Report;
import com.mapps.services.report.ReportService;
import com.mapps.services.report.exceptions.AuthenticationException;
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

/**
 *
 */
@WebServlet(name = "getReport", urlPatterns = "/getReport/*")
public class GetReportServlet extends HttpServlet implements Servlet {

    @EJB(beanName = "ReportService")
    ReportService reportService;
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
    String trainingID = req.getParameter("t");
    String athleteCI = req.getParameter("a");
    String token = String.valueOf(req.getSession().getAttribute("token"));
    Writer writer = resp.getWriter();

        try {
            Report report=reportService.getReport(trainingID,athleteCI,token);
            resp.setContentType("application/json");
            resp.setCharacterEncoding("UTF-8");
            String json = new Gson().toJson(report);
            writer.write(json);
            writer.close();
        } catch (AuthenticationException e) {
            e.printStackTrace();  //To change body of catch statement use File | Settings | File Templates.
        } catch (InvalidReportException e) {
            e.printStackTrace();  //To change body of catch statement use File | Settings | File Templates.
        }

    }
}
