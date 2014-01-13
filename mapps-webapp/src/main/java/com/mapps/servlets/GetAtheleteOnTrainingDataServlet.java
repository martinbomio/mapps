package com.mapps.servlets;

import java.io.IOException;
import java.io.Writer;
import java.util.List;
import javax.ejb.EJB;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.gson.Gson;
import com.mapps.model.ProcessedDataUnit;
import com.mapps.services.report.ReportService;
import com.mapps.services.report.exceptions.AuthenticationException;
import com.mapps.services.trainer.exceptions.InvalidAthleteException;
import com.mapps.services.trainer.exceptions.InvalidTrainingException;

/**
 *
 *
 */
public class GetAtheleteOnTrainingDataServlet extends HttpServlet {
    @EJB(name = "ReportService")
    protected ReportService reportService;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String trainingID = req.getParameter("t");
        String athleteData = req.getParameter("a");
        String token = req.getParameter("id");
        String athleteCI = athleteData.split("-")[1];

        try {
            List<ProcessedDataUnit> stats = reportService.getAthleteStats(trainingID, athleteCI, token);
            String json = new Gson().toJson(stats);
            resp.setContentType("application/json");
            resp.setCharacterEncoding("UTF-8");
            Writer writer = resp.getWriter();
            writer.write(json);
            writer.close();
        } catch (AuthenticationException e) {
            req.setAttribute("error", "El usuario no tiene permisos de entrenador para realizarr esta operación.");
            req.getRequestDispatcher("/athleteStats.jsp").forward(req, resp);
        } catch (InvalidTrainingException e) {
            req.setAttribute("error", "El entrenamiento seleccionado no es válido");
            req.getRequestDispatcher("/athleteStats.jsp").forward(req, resp);
        } catch (InvalidAthleteException e) {
            req.setAttribute("error", "El atleta seleccionado no es válido.");
            req.getRequestDispatcher("/athleteStats.jsp").forward(req, resp);
        }
    }
}
