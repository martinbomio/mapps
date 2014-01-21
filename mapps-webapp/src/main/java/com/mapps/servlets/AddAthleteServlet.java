package com.mapps.servlets;

import java.io.IOException;
import java.net.URI;
import java.net.URISyntaxException;
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

import org.apache.log4j.Logger;

import com.mapps.model.Athlete;
import com.mapps.model.Gender;
import com.mapps.model.Institution;
import com.mapps.services.institution.InstitutionService;
import com.mapps.services.trainer.TrainerService;
import com.mapps.services.trainer.exceptions.AuthenticationException;
import com.mapps.services.trainer.exceptions.InvalidAthleteException;
import com.mapps.services.user.UserService;
import com.mapps.utils.Constants;

/**
 *
 */
@WebServlet(name = "addAthletes", urlPatterns = "/addAthletes/*")
public class AddAthleteServlet extends HttpServlet implements Servlet {
    Logger logger = Logger.getLogger(AddAthleteServlet.class);
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
        try {
            Date birth = formatter.parse(req.getParameter("date"));
            Gender gender = Gender.UNKNOWN;
            if (req.getParameter("gender").equalsIgnoreCase("hombre")) {
                gender = Gender.MALE;
            } else if (req.getParameter("gender").equalsIgnoreCase("mujer")) {
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
            athlete.setImageURI(new URI(Constants.DEFAULT_ATHLETE_IMAGE));
            trainerService.addAthlete(athlete, token);
            resp.sendRedirect("athletes/athletes.jsp?info=1");
        } catch (InvalidAthleteException e) {
            resp.sendRedirect("athletes/add_athletes.jsp?error=Atleta no válido o ya existente");
        } catch (AuthenticationException e) {
            resp.sendRedirect("athletes/add_athletes.jsp?error=Error de autentificación");
        } catch (ParseException e) {
            logger.error("Date fromat exception");
            throw new IllegalStateException();
        } catch (URISyntaxException e) {
            throw new IllegalStateException();
        }
    }
}
