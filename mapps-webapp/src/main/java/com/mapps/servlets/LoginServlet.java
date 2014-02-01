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
import com.mapps.model.User;
import com.mapps.services.user.UserService;
import com.mapps.services.user.exceptions.AuthenticationException;
import com.mapps.services.user.exceptions.InvalidUserException;

/**
 * Servlet that handles the login of the users to the system.
 */
@WebServlet(name = "login", urlPatterns = "/login/*")
public class LoginServlet extends HttpServlet implements Servlet {
    @EJB(beanName = "UserService")
    UserService userService;

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String username = req.getParameter("username");
        String password = req.getParameter("password");
        try {
            String token = userService.login(username, password);
            Role role = userService.userRoleOfToken(token);
            User user = userService.getUserOfToken(token);
            String instName = user.getInstitution().getName();
            req.getSession().setAttribute("token", token);
            req.getSession().setAttribute("role", role);
            req.getSession().setAttribute("institutionName",instName);
            resp.sendRedirect("index.jsp");
        } catch (AuthenticationException e) {
            //error 1: Nombre de Usuario o Contraseña no válido
            resp.sendRedirect("index_login.jsp?error=1");
        } catch (InvalidUserException e) {
            //error 2: Nombre de Usuario o Contraseña no válido
            resp.sendRedirect("index_login.jsp?error=1");
        }
    }

}
