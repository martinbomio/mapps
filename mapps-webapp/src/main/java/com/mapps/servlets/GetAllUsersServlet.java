package com.mapps.servlets;

import java.io.IOException;
import java.io.Writer;
import java.util.List;
import javax.ejb.EJB;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.mapps.model.User;
import com.mapps.services.admin.AdminService;
import com.mapps.services.admin.exceptions.AuthenticationException;

/**
 *
 *
 */
@WebServlet(name = "getAllUsers", urlPatterns = "/getAllUsers")
public class GetAllUsersServlet extends HttpServlet{
    @EJB(beanName = "AdminService")
    protected AdminService adminService;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String token = String.valueOf(req.getSession().getAttribute("token"));
        try {
            List<User> users = adminService.getAllUsers(token);
            Gson gson = new GsonBuilder().setDateFormat("dd/MM/yyyy").create();
            String json = gson.toJson(users);
            Writer writer = resp.getWriter();
            resp.setContentType("application/json");
            writer.write(json);
            writer.close();
        } catch (AuthenticationException e) {
            resp.sendError(1, "Error de Autenticación");
        }
    }
}
