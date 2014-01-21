package com.mapps.servlets;

import java.io.File;
import java.io.IOException;
import java.net.URI;
import java.net.URISyntaxException;
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
            String fileName = getFileName(part);
            String extension = fileName.split("\\.")[1];
            Institution newInst = institutionService.getInstitutionByID(token, Long.valueOf(id));
            newInst.setDescription(description);
            newInst.setCountry(country);
            newInst.setName(name);
            newInst.setImageURI(new URI("/mapps" + File.separator + UPLOAD_DIR + File.separator + name + "." + extension));
            institutionService.updateInstitution(newInst, token);
            part.write(uploadFilePath + File.separator + name + "." + extension);
            resp.sendRedirect("configuration/configuration.jsp");
        } catch (AuthenticationException e) {
            //2:error de autentificacion
            resp.sendRedirect("configuration/edit_institution.jsp?error=2");
        } catch (InvalidInstitutionException e) {
            resp.sendRedirect("configuration/edit_institution.jsp?error=1");
        } catch (URISyntaxException e) {
            logger.error("File URI error");
            throw new IllegalStateException();
        }
    }

    /**
     * Utility method to get file name from HTTP header content-disposition
     */
    private String getFileName(Part part) {
        String contentDisp = part.getHeader("content-disposition");
        System.out.println("content-disposition header= "+contentDisp);
        String[] tokens = contentDisp.split(";");
        for (String token : tokens) {
            if (token.trim().startsWith("filename")) {
                return token.substring(token.indexOf("=") + 2, token.length()-1);
            }
        }
        return "";
    }
}
