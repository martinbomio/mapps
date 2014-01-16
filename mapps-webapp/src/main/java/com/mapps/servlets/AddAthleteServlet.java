package com.mapps.servlets;

import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

import javax.ejb.EJB;
import javax.servlet.Servlet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.mapps.model.Athlete;
import com.mapps.model.Gender;
import com.mapps.model.Institution;
import com.mapps.services.institution.InstitutionService;
import com.mapps.services.trainer.TrainerService;
import com.mapps.services.trainer.exceptions.AuthenticationException;
import com.mapps.services.trainer.exceptions.InvalidAthleteException;
import com.mapps.services.user.UserService;
import org.apache.log4j.Logger;

/**
 *
 */
@WebServlet(name = "addAthlete", urlPatterns = "/addAthlete/*")
public class AddAthleteServlet extends HttpServlet implements Servlet {
    Logger logger= Logger.getLogger(AddAthleteServlet.class);
    @EJB(beanName = "UserService")
    UserService userService;
    @EJB(beanName = "TrainerService")
    TrainerService trainerService;
    @EJB(beanName = "InstitutionService")
    InstitutionService institutionService;

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String token = String.valueOf(req.getSession().getAttribute("token"));

        String name = req.getParameter("name");
        String lastName = req.getParameter("lastName");
        SimpleDateFormat formatter = new SimpleDateFormat("dd/MM/yyyy");
        Date birth = null;
        try {
            birth = formatter.parse(req.getParameter("date"));
        } catch (ParseException e) {
            logger.error("Date fromat exception");
            throw new IllegalStateException();
        }
        Gender gender = Gender.UNKNOWN;;
        if (req.getParameter("gender").equalsIgnoreCase("hombre")) {
            gender = Gender.MALE;
        } else if (req.getParameter("gender").equalsIgnoreCase("mujer")){
            gender = Gender.FEMALE;
        }
        String email = req.getParameter("email");
        double weight = Double.parseDouble(req.getParameter("weight"));
        double height = Double.parseDouble(req.getParameter("height"));
        String idDocument = req.getParameter("document");
        String instName = req.getParameter("institution");
        Institution instAux = institutionService.getInstitutionByName(instName);

        Athlete athlete = new Athlete(name, lastName, birth, gender, email, weight, height, idDocument, instAux);
        athlete.setEnabled(true);

        try {
            trainerService.addAthlete(athlete, token);
            req.setAttribute("info", "El atleta fue ingresado con éxito al sistema");
            req.getRequestDispatcher("athletes/athletes.jsp").forward(req, resp);

            //resp.sendRedirect("athletes/athletes.jsp");
        } catch (InvalidAthleteException e) {
            req.setAttribute("error", "Atleta no válido o ya existente");
            req.getRequestDispatcher("athletes/add_athletes.jsp").forward(req, resp);
        } catch (AuthenticationException e) {
            req.setAttribute("error", "Error de autentificación");
            req.getRequestDispatcher("athletes/add_athletes.jsp").forward(req, resp);
        }
    }
}
