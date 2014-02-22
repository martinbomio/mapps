package com.mapps.servlets;

import java.io.File;
import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import javax.ejb.EJB;
import javax.servlet.Servlet;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

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
import com.mapps.utils.Utils;

/**
 *
 */
@WebServlet(name = "modifyUser", urlPatterns = "/modifyUser/*")
@MultipartConfig
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

    private static final String UPLOAD_DIR = "images/users";
    private SimpleDateFormat formatter = new SimpleDateFormat("dd/MM/yyyy");

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // gets absolute path of the web application
        String applicationPath = req.getServletContext().getRealPath("");
        // constructs path of the directory to save uploaded file
        String uploadFilePath = applicationPath + File.separator + UPLOAD_DIR;
        // creates the save directory if it does not exists
        File fileSaveDir = new File(uploadFilePath);
        if (!fileSaveDir.exists()) {
            fileSaveDir.mkdirs();
        }
        String token = String.valueOf(req.getSession().getAttribute("token"));
        String name = req.getParameter("name");
        String lastName = req.getParameter("lastName");
        String email = req.getParameter("email");
        String userName = req.getParameter("username-hidden");
        String idDocument = req.getParameter("document");
        String birth = req.getParameter("date");
        Gender gender = Gender.UNKNOWN;
        if (req.getParameter("gender_list").equalsIgnoreCase("hombre")) {
            gender = Gender.MALE;
        } else if (req.getParameter("gender_list").equalsIgnoreCase("mujer")) {
            gender = Gender.FEMALE;
        }
        Role role = Role.USER;
        if (req.getParameter("role_list").equalsIgnoreCase("administrador")) {
            role = Role.ADMINISTRATOR;
        } else if (req.getParameter("role_list").equalsIgnoreCase("entrenador")) {
            role = Role.TRAINER;
        }
        try {
            Part part = req.getPart("file");
            String fileName = Utils.getFileName(part);
            User newUser = adminService.getUserByUsername(userName);
            newUser.setName(name);
            newUser.setLastName(lastName);
            newUser.setEmail(email);
            newUser.setIdDocument(idDocument);
            newUser.setGender(gender);
            newUser.setRole(role);
            newUser.setBirth(formatter.parse(birth));
            if (!fileName.equals("")){
                String extension = fileName.split("\\.")[1];
                newUser.setImageURI(Utils.getFileURI(userName, UPLOAD_DIR, extension));
                part.write(uploadFilePath + File.separator + userName + "." + extension);
            }
            userService.updateUser(newUser, token);
            resp.sendRedirect("index.jsp?info=5");
        } catch (InvalidUserException e) {
            resp.sendRedirect("configuration/edit_user.jsp?error=1");
        } catch (AuthenticationException e) {
            //Authentification error
            resp.sendRedirect("configuration/edit_user.jsp?error=2");
        } catch (com.mapps.services.admin.exceptions.InvalidUserException e) {
            resp.sendRedirect("configuration/edit_user.jsp?error=1");
        } catch (ParseException e) {
            logger.error("Date format exception");
            throw new IllegalStateException();
        }
    }
}
