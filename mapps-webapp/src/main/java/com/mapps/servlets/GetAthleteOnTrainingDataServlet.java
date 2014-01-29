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

import com.mapps.model.Athlete;
import com.mapps.model.ProcessedDataUnit;
import com.mapps.services.report.ReportService;
import com.mapps.services.report.exceptions.AuthenticationException;
import com.mapps.services.trainer.TrainerService;
import com.mapps.services.trainer.exceptions.InvalidAthleteException;
import com.mapps.services.trainer.exceptions.InvalidTrainingException;
import com.mapps.wrappers.AthleteStatsWrapper;

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
        String token = String.valueOf(req.getSession().getAttribute("token"));
        Writer writer = resp.getWriter();
        try {
            List<ProcessedDataUnit> stats = reportService.getAthleteStats(trainingID, athleteCI, token);
            Athlete athlete = trainerService.getAthleteByIdDocument(athleteCI);
            AthleteStatsWrapper wrapper = new AthleteStatsWrapper(trainingID, athlete, stats);
            resp.setContentType("application/json");
            resp.setCharacterEncoding("UTF-8");
            String json = wrapper.toJson();
            writer.write(json);
            writer.close();
        } catch (AuthenticationException e) {
        	writer.write("Error de autenticacion");
        } catch (InvalidTrainingException e) {
        	writer.write("El entrenamiento no es valido");
        } catch (InvalidAthleteException e) {
        	writer.write("El atleta no es valido");
        }finally{
        	writer.close();
        }
    }
}
