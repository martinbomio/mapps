package com.mapps.servlets;

import java.io.File;
import java.io.IOException;
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

import com.mapps.model.Institution;
import com.mapps.services.institution.InstitutionService;
import com.mapps.services.institution.exceptions.AuthenticationException;
import com.mapps.services.institution.exceptions.InvalidInstitutionException;
import com.mapps.services.trainer.TrainerService;
import com.mapps.services.user.UserService;
import com.mapps.utils.Utils;

/**
 *
 */
@WebServlet(name = "modifyInstitution", urlPatterns = "/modifyInstitution/*")
@MultipartConfig
public class ModifyInstitutionServlet extends HttpServlet implements Servlet {
    Logger logger = Logger.getLogger(ModifyAthleteServlet.class);
    @EJB(beanName = "UserService")
    UserService userService;
    @EJB(beanName = "TrainerService")
    TrainerService trainerService;
    @EJB(beanName = "InstitutionService")
    InstitutionService institutionService;

    private static final String UPLOAD_DIR = "images/institutions";

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
        String description = req.getParameter("description");
        String country = req.getParameter("country");
        String id = req.getParameter("id-hidden");
        try {
            Part part = req.getPart("file");
            String fileName = Utils.getFileName(part);
            Institution newInst = institutionService.getInstitutionByID(token, Long.valueOf(id));
            newInst.setDescription(description);
            newInst.setCountry(country);
            newInst.setName(name);
            if (!fileName.equals("")) {
                String extension = fileName.split("\\.")[1];
                newInst.setImageURI(Utils.getFileURI(name, UPLOAD_DIR, extension));
                part.write(uploadFilePath + File.separator + name + "." + extension);
            }
            institutionService.updateInstitution(newInst, token);
            resp.sendRedirect("configuration/configuration_main.jsp");
        } catch (AuthenticationException e) {
            //2:error de autentificacion
            resp.sendRedirect("configuration/edit_institution.jsp?error=2");
        } catch (InvalidInstitutionException e) {
            resp.sendRedirect("configuration/edit_institution.jsp?error=1");
        }
    }
}
