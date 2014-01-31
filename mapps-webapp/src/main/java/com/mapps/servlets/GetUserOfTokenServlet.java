package com.mapps.servlets;

import com.google.gson.Gson;
import com.mapps.model.User;
import com.mapps.services.user.UserService;
import com.mapps.services.user.exceptions.AuthenticationException;

import javax.ejb.EJB;
import javax.servlet.Servlet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.Writer;

/**
 *
 */
@WebServlet(name = "getUserOfToken", urlPatterns = "/getUserOfToken/*")
public class GetUserOfTokenServlet extends HttpServlet implements Servlet {
    @EJB(beanName = "UserService")
    protected UserService userService;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
    String token = String.valueOf(req.getSession().getAttribute("token"));

        try {
            User user = userService.getUserOfToken(token);
            Writer writer = resp.getWriter();
            resp.setContentType("application/json");
            String json = new Gson().toJson(user);
            writer.write(json);
            writer.close();

        } catch (AuthenticationException e) {
            resp.sendError(2, "Error de autentificación");
        }
    }

}
