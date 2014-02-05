package com.mapps.servlets;

import java.io.IOException;
import javax.ejb.EJB;
import javax.servlet.Servlet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.mapps.exceptions.NullParameterException;
import com.mapps.model.Training;
import com.mapps.services.institution.InstitutionService;
import com.mapps.services.report.ReportService;
import com.mapps.services.trainer.TrainerService;
import com.mapps.services.trainer.exceptions.AuthenticationException;
import com.mapps.services.trainer.exceptions.InvalidTrainingException;
import com.mapps.services.user.UserService;

/**
 *
 */
@WebServlet(name = "stopTraining", urlPatterns = "/stopTraining/*")
public class StopTrainingServlet extends HttpServlet implements Servlet {
    @EJB(beanName = "UserService")
    UserService userService;
    @EJB(beanName = "TrainerService")
    TrainerService trainerService;
    @EJB(beanName = "InstitutionService")
    InstitutionService institutionService;
    @EJB(beanName = "ReportService")
    ReportService reportService;


    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String token = String.valueOf(req.getSession().getAttribute("token"));
        String name = req.getParameter("name");
        try {
            Training training = trainerService.getTrainingByName(token, name);
            reportService.createTrainingPulseReports(training.getName(), token);
            trainerService.stopTraining(training, token);
            resp.sendRedirect("index.jsp?info=10");
        } catch (AuthenticationException e) {
            resp.sendRedirect("index.jsp?error=10");
        } catch (InvalidTrainingException e) {
            resp.sendRedirect("index.jsp?error=11");
        } catch (NullParameterException e) {
            resp.sendRedirect("index.jsp?error=11");
        } catch (com.mapps.services.report.exceptions.AuthenticationException e) {
            resp.sendRedirect("index.jsp?error=10");
        }
    }
}
