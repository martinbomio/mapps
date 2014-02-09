package com.mapps.servlets;

import java.io.IOException;
import java.io.Writer;
import javax.ejb.EJB;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.mapps.exceptions.NullParameterException;
import com.mapps.model.Athlete;
import com.mapps.model.PulseReport;
import com.mapps.model.Training;
import com.mapps.services.report.ReportService;
import com.mapps.services.report.exceptions.AuthenticationException;
import com.mapps.services.report.exceptions.NoPulseDataException;
import com.mapps.services.trainer.TrainerService;
import com.mapps.services.trainer.exceptions.InvalidAthleteException;
import com.mapps.services.trainer.exceptions.InvalidTrainingException;

/**
 *
 *
 */
@WebServlet(name = "getAthleteOnTrainingData", urlPatterns = "/getAthleteOnTrainingData/*")
public class GetAthleteOnTrainingDataServlet extends HttpServlet {
    @EJB(name = "ReportService")
    protected ReportService reportService;
    @EJB(name = "TrainerService")
    protected TrainerService trainerService;

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String trainingID = req.getParameter("t");
        String athleteCI = req.getParameter("a");
        boolean relod = Boolean.parseBoolean(req.getParameter("r"));
        String token = String.valueOf(req.getSession().getAttribute("token"));
        Writer writer = resp.getWriter();
        try {
            Training training = trainerService.getTrainingByName(trainingID, token);
            Athlete athlete = trainerService.getAthleteByIdDocument(athleteCI);
            PulseReport report = reportService.getAthletePulseStats(training, athlete, relod, token);
            resp.setContentType("application/json");
            resp.setCharacterEncoding("UTF-8");
            Gson gson = new GsonBuilder().excludeFieldsWithModifiers().create();
            String json = gson.toJson(report);
            writer.write(json);
            writer.close();
        } catch (AuthenticationException e) {
            writer.write("Error de autenticacion");
        } catch (NoPulseDataException e) {
            writer.write("No hay datos del pulso");
        } catch (NullParameterException e) {
            throw new IllegalStateException("Null parameters", e);
        } catch (InvalidAthleteException e) {
            throw new IllegalStateException("Invalid Athlete", e);
        } catch (com.mapps.services.trainer.exceptions.AuthenticationException e) {
            writer.write("Error de autenticacion");
        } catch (InvalidTrainingException e) {
            throw new IllegalStateException("Invalid Training", e);
        } finally {
            writer.close();
        }
    }
}
