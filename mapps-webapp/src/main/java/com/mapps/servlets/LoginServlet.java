package com.mapps.servlets;

import java.io.IOException;
import javax.ejb.EJB;
import javax.servlet.Servlet;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.mapps.services.user.UserService;
import com.mapps.services.user.exceptions.AuthenticationException;
import com.mapps.services.user.exceptions.InvalidUserException;
import com.mapps.services.user.impl.UserServiceImpl;

/**
 * Servlet that handles the login of the users to the system.
 */

public class LoginServlet extends HttpServlet implements Servlet {
    @EJB(beanName = "UserService")
    UserService userService;

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        String username = req.getParameter("username");
        String password = req.getParameter("password");
        try {

            String token = userService.login(username,password);
            boolean admin=userService.isAdministrator(username);
            req.setAttribute("token", token);
            if(admin){
            req.setAttribute("admin","administrator");
            }else{
            req.setAttribute("admin","other");
            }
            req.getRequestDispatcher("/mainPage.jsp").forward(req, resp);
        } catch (AuthenticationException e) {
            req.setAttribute("error", "Invalid username or password");
            req.getRequestDispatcher("/index.jsp").forward(req, resp);
        } catch (InvalidUserException e) {
            req.setAttribute("error", "Invalid username or password");
            req.getRequestDispatcher("/index.jsp").forward(req, resp);
        }
    }

}
