package com.mapps.servlets;

import java.io.IOException;
import java.io.Writer;
import java.util.List;
import java.util.Map;
import javax.ejb.EJB;
import javax.servlet.Servlet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.common.collect.Maps;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.mapps.model.Athlete;
import com.mapps.model.Institution;
import com.mapps.model.User;
import com.mapps.services.institution.InstitutionService;
import com.mapps.services.trainer.TrainerService;
import com.mapps.services.user.UserService;
import com.mapps.services.user.exceptions.AuthenticationException;
import com.mapps.services.user.exceptions.InvalidUserException;

/**
 *
 */
@WebServlet(name = "getAllAthletesOfInstitution", urlPatterns = "/getAllAthletesOfInstitution/*")
public class GetAllAthletesOfInstitutionServlet extends HttpServlet implements Servlet {
    @EJB(beanName = "TrainerService")
    protected TrainerService trainerService;
    @EJB(beanName = "UserService")
    protected UserService userService;
    @EJB(beanName = "InstitutionService")
    protected InstitutionService institutionService;


    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String token = String.valueOf(req.getSession().getAttribute("token"));
        try {
            User user = userService.getUserOfToken(token);
            if (userService.isAdministrator(user.getUserName())){
                req.getRequestDispatcher("getAllAthletes").forward(req, resp);
            }
            Institution institution = institutionService.getInstitutionOfUser(user.getUserName());
            List<Athlete> athletes = trainerService.getAllAthletesOfInstitution(institution.getName());
            Writer writer = resp.getWriter();
            resp.setContentType("application/json");
            Map<String, List<Athlete>> map = Maps.newHashMap();
            map.put("athletes", athletes);
            Gson gson = new GsonBuilder().setDateFormat("dd/MM/yyy").create();
            String json = gson.toJson(map);
            writer.write(json);
            writer.close();
        } catch (InvalidUserException e) {
            req.setAttribute("error", "Error de autentificación");
        }catch (AuthenticationException e) {
            req.setAttribute("error", "Error de autentificación");
        }
    }
}
