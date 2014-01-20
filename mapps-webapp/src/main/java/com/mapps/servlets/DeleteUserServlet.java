package com.mapps.servlets;

import java.io.IOException;
import java.util.List;
import javax.ejb.EJB;
import javax.servlet.Servlet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.reflect.TypeToken;
import com.mapps.model.User;
import com.mapps.services.admin.AdminService;
import com.mapps.services.admin.exceptions.AuthenticationException;
import com.mapps.services.admin.exceptions.InvalidUserException;
import com.mapps.services.institution.InstitutionService;
import com.mapps.services.trainer.TrainerService;
import com.mapps.services.user.UserService;

/**
 *
 */
@WebServlet(name = "deleteUser", urlPatterns = "/deleteUser/*")
public class DeleteUserServlet extends HttpServlet implements Servlet {
    @EJB(beanName = "UserService")
    UserService userService;
    @EJB(beanName = "TrainerService")
    TrainerService trainerService;
    @EJB(beanName = "AdminService")
    AdminService adminService;
    @EJB(beanName = "InstitutionService")
    InstitutionService institutionService;

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String token = String.valueOf(req.getSession().getAttribute("token"));
        String json = req.getParameter("json");
        Gson gson = new GsonBuilder().setDateFormat("dd/MM/yyyy").create();
        List<User> users = gson.fromJson(json, new TypeToken<List<User>>(){}.getType());
        try {
            for (User user : users){
                User dbUser = adminService.getUserByUsername(user.getUserName());
                adminService.deleteUser(dbUser, token);
            }
        } catch (InvalidUserException e) {
            //Usuario no valido
            resp.sendError(1, "El usurio que desea eliminar no existe");
        } catch (AuthenticationException e) {
            //Error de autenticacion
            resp.sendError(2, "Error de autentificación");
        }
    }

}
