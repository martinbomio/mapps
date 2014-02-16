package com.mapps.servlets;

import java.io.File;
import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import javax.ejb.EJB;
import javax.servlet.Servlet;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

import com.mapps.model.Gender;
import com.mapps.model.User;
import com.mapps.services.admin.AdminService;
import com.mapps.services.user.UserService;
import com.mapps.services.user.exceptions.AuthenticationException;
import com.mapps.services.user.exceptions.InvalidUserException;
import com.mapps.utils.Utils;

/**
 *
 */
@WebServlet(name = "modifyMyAccount", urlPatterns = "/modifyMyAccount/*")
@MultipartConfig
public class ModifyMyAccountServlet extends HttpServlet implements Servlet {
    @EJB(beanName = "AdminService")
    AdminService adminService;
    @EJB(beanName = "UserService")
    UserService userService;

    private static final String UPLOAD_DIR = "images/users";

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
        String document = req.getParameter("idDocument");
        String birthString = req.getParameter("birth");
        SimpleDateFormat format = new SimpleDateFormat("dd/MM/yyyy");
        Gender gender = Gender.UNKNOWN;
        if (req.getParameter("gender").equalsIgnoreCase("hombre")) {
            gender = Gender.MALE;
        } else if (req.getParameter("gender").equalsIgnoreCase("mujer")) {
            gender = Gender.FEMALE;
        }
        try {
            Part part = req.getPart("file");
            String fileName = Utils.getFileName(part);

            Date birth = format.parse(birthString);
            User user = userService.getUserOfToken(token);
            user.setName(name);
            user.setBirth(birth);
            user.setIdDocument(document);
            user.setGender(gender);
            user.setLastName(lastName);
            user.setEmail(email);
            if (!fileName.equals("")){
                String extension = fileName.split("\\.")[1];
                user.setImageURI(Utils.getFileURI(user.getUserName(), UPLOAD_DIR, extension));
                part.write(uploadFilePath + File.separator + user.getUserName() + "." + extension);
            }
            userService.updateUser(user, token);
            resp.sendRedirect("configuration/my_account.jsp?info=5");
        } catch (AuthenticationException e) {
            resp.sendRedirect("configuration/edit_my_user.jsp");
        } catch (InvalidUserException e) {
            resp.sendRedirect("configuration/edit_my_user.jsp");
        } catch (ParseException e) {
            throw new IllegalStateException("Date format exception", e);
        }
    }

}
