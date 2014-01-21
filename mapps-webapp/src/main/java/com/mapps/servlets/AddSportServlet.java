package com.mapps.servlets;

import java.io.IOException;
import javax.ejb.EJB;
import javax.servlet.Servlet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.mapps.model.Sport;
import com.mapps.services.trainer.TrainerService;
import com.mapps.services.trainer.exceptions.AuthenticationException;
import com.mapps.services.trainer.exceptions.InvalidSportException;
import com.mapps.services.user.UserService;

/**
 *
 */
@WebServlet(name = "addSport", urlPatterns = "/addSport/*")
public class AddSportServlet extends HttpServlet implements Servlet {
    @EJB(beanName = "TrainerService")
    TrainerService trainerService;
    @EJB(beanName="UserService")
    UserService userService;

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String token = String.valueOf(req.getSession().getAttribute("token"));

        String sportName = req.getParameter("name");
        Sport newSport = new Sport(sportName);
        try {
            trainerService.addSport(newSport, token);
            resp.sendRedirect("./configuration/configuration.jsp");
        } catch (InvalidSportException e) {
            //1:Deporte no valido o existente
            resp.sendRedirect("configuration/add_sport.jsp?error=1");
        } catch (AuthenticationException e) {
            //2:Error de autentificacion
            resp.sendRedirect("configuration/add_sport.jsp.jsp?error=2");
        }
    }
}
