package com.mapps.servlets;

import java.io.IOException;
import javax.ejb.EJB;
import javax.servlet.Servlet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;

import com.mapps.model.Gender;
import com.mapps.model.Role;
import com.mapps.model.User;
import com.mapps.services.admin.AdminService;
import com.mapps.services.institution.InstitutionService;
import com.mapps.services.trainer.TrainerService;
import com.mapps.services.user.UserService;
import com.mapps.services.user.exceptions.AuthenticationException;
import com.mapps.services.user.exceptions.InvalidUserException;

/**
 *
 */
@WebServlet(name = "modifyUserServlet", urlPatterns = "/modifyUserServlet/*")
public class ModifyUserServlet extends HttpServlet implements Servlet {
    Logger logger = Logger.getLogger(ModifyUserServlet.class);
    @EJB(beanName = "AdminService")
    AdminService adminService;
    @EJB(beanName = "UserService")
    UserService userService;
    @EJB(beanName = "TrainerService")
    TrainerService trainerService;
    @EJB(beanName = "InstitutionService")
    InstitutionService institutionService;

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String token = String.valueOf(req.getSession().getAttribute("token"));
        String name = req.getParameter("name");
        String lastName = req.getParameter("lastName");
        String email = req.getParameter("email");
        String userName = req.getParameter("username");
        String password = req.getParameter("password");
        String idDocument = req.getParameter("document");
        Gender gender = Gender.UNKNOWN;
        if (req.getParameter("gender").equalsIgnoreCase("hombre")) {
            gender = Gender.MALE;
        } else if (req.getParameter("gender").equalsIgnoreCase("mujer")) {
            gender = Gender.FEMALE;
        }
        Role role = Role.USER;
        if (req.getParameter("role").equalsIgnoreCase("administrador")) {
            role = Role.ADMINISTRATOR;
        } else if (req.getParameter("role").equalsIgnoreCase("entrenador")) {
            role = Role.TRAINER;
        }

        try {
            User newUser = adminService.getUserByUsername(userName);
            newUser.setName(name);
            newUser.setLastName(lastName);
            newUser.setEmail(email);
            newUser.setPassword(password);
            newUser.setIdDocument(idDocument);
            newUser.setGender(gender);
            newUser.setRole(role);
            userService.updateUser(newUser, token);
            resp.sendRedirect("configuration/configuration.jsp");
        } catch (InvalidUserException e) {
            resp.sendRedirect("configuration/edit_user.jsp?error=1");
        } catch (AuthenticationException e) {
            resp.sendRedirect("configuration/edit_user.jsp?error=2");
        } catch (com.mapps.services.admin.exceptions.InvalidUserException e) {
            resp.sendRedirect("configuration/edit_user.jsp?error=1");
        }
    }
}
