package com.mapps.servlets;

import java.io.IOException;
import javax.ejb.EJB;
import javax.servlet.Servlet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.mapps.model.Role;
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
        String token = req.getParameter("token");
        Role userRole = null;
        try {
            userRole = userService.userRoleOfToken(token);
        } catch (com.mapps.services.user.exceptions.InvalidUserException e) {
            req.setAttribute("error", "Usuario inválido");
        } catch (com.mapps.services.user.exceptions.AuthenticationException e) {
            req.setAttribute("error", "Error de autentificación");
        }
        req.setAttribute("token", token);
        req.setAttribute("role", userRole);
        String sportName = req.getParameter("name");
        Sport newSport = new Sport(sportName);
        try {
            trainerService.addSport(newSport, token);
            req.setAttribute("info", "El deporte fue ingresado al sistema con exito");
            req.getRequestDispatcher("/addSport.jsp").forward(req, resp);
        } catch (InvalidSportException e) {
            req.setAttribute("error", "Deporte no válido");
            req.getRequestDispatcher("/addSport.jsp").forward(req, resp);
        } catch (AuthenticationException e) {
            req.setAttribute("error", "Error de autentificación");
            req.getRequestDispatcher("/addSport.jsp").forward(req, resp);
        }
    }
}
