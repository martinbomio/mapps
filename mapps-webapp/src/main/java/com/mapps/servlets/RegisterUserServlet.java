package com.mapps.servlets;

import java.io.IOException;
import java.util.Date;
import javax.ejb.EJB;
import javax.servlet.Servlet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.mapps.model.Gender;
import com.mapps.model.Institution;
import com.mapps.model.Role;
import com.mapps.model.User;
import com.mapps.services.admin.AdminService;
import com.mapps.services.admin.exceptions.AuthenticationException;
import com.mapps.services.admin.exceptions.InvalidUserException;
import com.mapps.services.admin.exceptions.UserAlreadyExistsException;
import com.mapps.services.institution.InstitutionService;
import com.mapps.services.user.UserService;

/**
 *
 */
@WebServlet(name = "registerUser", urlPatterns = "/registerUser/*")
public class RegisterUserServlet extends HttpServlet implements Servlet {
    @EJB(beanName = "UserService")
    UserService userService;
    @EJB(beanName = "AdminService")
    AdminService adminService;
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
        String idDocument = req.getParameter("idDocument");
        Gender gender = null;
        if (req.getParameter("gender").equalsIgnoreCase("male")) {
            gender = Gender.MALE;
        } else if (req.getParameter("gender").equalsIgnoreCase("female")){
            gender = Gender.FEMALE;
        } else {
            gender = Gender.UNKNOWN;
        }
        Role role = null;
        if (req.getParameter("role").equals("1")) {
            role = Role.ADMINISTRATOR;
        } else if (req.getParameter("role").equals("2")) {
            role = Role.TRAINER;
        } else {
            role = Role.USER;
        }
        String instName = req.getParameter("institution");
        Institution instAux = institutionService.getInstitutionByName(instName);
        Date birth = new Date(req.getParameter("date"));

        User user = new User(name, lastName, birth, gender, email, userName, password, instAux, role, idDocument);
        user.setEnabled(true);

        try {
            adminService.createUser(user, token);
            req.setAttribute("info", "user added to system");
            req.getRequestDispatcher("/mainPage.jsp").forward(req, resp);

        } catch (AuthenticationException e) {
            req.setAttribute("error", "Authentication error");
            req.getRequestDispatcher("/registerUser.jsp").forward(req, resp);
        } catch (InvalidUserException e) {
            req.setAttribute("error", "invalid user error");
            req.getRequestDispatcher("/registerUser.jsp").forward(req, resp);
        } catch (UserAlreadyExistsException e) {
            req.setAttribute("error", "user already exists error");
            req.getRequestDispatcher("/registerUser.jsp").forward(req, resp);
        }

    }
}
