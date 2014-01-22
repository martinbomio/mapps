package com.mapps.servlets;

import java.io.IOException;
import java.net.URI;
import java.net.URISyntaxException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import javax.ejb.EJB;
import javax.servlet.Servlet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;

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
import com.mapps.utils.Constants;

/**
 *
 */
@WebServlet(name = "registerUser", urlPatterns = "/registerUser/*")
public class RegisterUserServlet extends HttpServlet implements Servlet {
    Logger logger = Logger.getLogger(RegisterUserServlet.class);
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
            String instName = req.getParameter("institution");
            Institution instAux = institutionService.getInstitutionByName(instName);
            SimpleDateFormat formatter = new SimpleDateFormat("dd/MM/yyyy");
            Date birth = formatter.parse(req.getParameter("date"));
            User user = new User(name, lastName, birth, gender, email, userName, password, instAux, role, idDocument);
            user.setEnabled(true);
            user.setImageURI(new URI(Constants.DEFAULT_USER_IMAGE));
            adminService.createUser(user, token);
            resp.sendRedirect("configuration/configuration_main.jsp?info=El usuario se agrego al sistema con exito");
        } catch (ParseException e) {
            logger.error("Date fromat exception");
            throw new IllegalStateException();
        } catch (AuthenticationException e) {
            resp.sendRedirect("configuration/register_user.jsp?error=Error de autentificación");
        } catch (InvalidUserException e) {
            resp.sendRedirect("configuration/register_user.jsp?error=Usuario no valido");
        } catch (UserAlreadyExistsException e) {
            resp.sendRedirect("configuration/register_user.jsp?error=Usuario ya existe en el sistema");

        } catch (URISyntaxException e) {
            throw new IllegalStateException();
        }

    }
}
