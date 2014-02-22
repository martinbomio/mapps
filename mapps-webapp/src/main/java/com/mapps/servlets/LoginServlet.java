package com.mapps.servlets;

import java.io.IOException;
import javax.ejb.EJB;
import javax.servlet.Servlet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.mapps.model.User;
import com.mapps.services.trainer.TrainerService;
import com.mapps.services.user.UserService;
import com.mapps.services.user.exceptions.AuthenticationException;

/**
 * Servlet that handles the login of the users to the system.
 */
@WebServlet(name = "login", urlPatterns = "/login/*")
public class LoginServlet extends HttpServlet implements Servlet {
    @EJB(beanName = "UserService")
    UserService userService;
    @EJB(beanName = "TrainerService")
    TrainerService trainerService;

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String username = req.getParameter("username");
        String password = req.getParameter("password");
        try {
            String token = userService.login(username, password);
            User user = userService.getUserOfToken(token);
            String instName = user.getInstitution().getName();
            req.getSession().setAttribute("token", token);
            req.getSession().setAttribute("role", user.getRole());
            req.getSession().setAttribute("institutionName",instName);
            req.getSession().setAttribute("finishedTraining", "noFinishedTraining");
            if(trainerService.thereIsAStartedTraining(user.getInstitution())){
                req.getSession().setAttribute("trainingStarted", "trainingStarted");
            } else{
                req.getSession().setAttribute("trainingStarted", "trainingStopped");
            }
                resp.sendRedirect("index.jsp");
        } catch (AuthenticationException e) {
            //error 1: Nombre de Usuario o Contraseña no válido
            resp.sendRedirect("index_login.jsp?error=1");
        }
    }

}
