package com.mapps.servlets;

import java.io.IOException;
import javax.ejb.EJB;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.mapps.services.user.UserService;
import com.mapps.services.user.exceptions.AuthenticationException;

/**
 * Servlet that handles the login of the users to the system.
 */
public class LoginServlet extends HttpServlet{
    @EJB(beanName = "UserService")
    UserService userService;

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        String username = req.getParameter("username");
        String password = req.getParameter("password");
        try {
            String token = userService.login(username,password);
            req.setAttribute("token", token);
            req.getRequestDispatcher("/index.jsp").forward(req, resp);
        } catch (AuthenticationException e) {
            req.setAttribute("message", "Invalid username or password");
            req.getRequestDispatcher("/index.jsp").forward(req, resp);
        }
    }

}
