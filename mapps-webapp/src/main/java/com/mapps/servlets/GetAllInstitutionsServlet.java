package com.mapps.servlets;

import java.io.IOException;
import java.io.Writer;
import java.util.List;
import javax.ejb.EJB;
import javax.servlet.Servlet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;

import com.google.common.collect.Lists;
import com.google.gson.Gson;
import com.mapps.model.Institution;
import com.mapps.model.Role;
import com.mapps.model.User;
import com.mapps.services.institution.InstitutionService;
import com.mapps.services.user.UserService;
import com.mapps.services.user.exceptions.AuthenticationException;


/**
 *
 */
@WebServlet(name = "getAllInstitutions", urlPatterns = "/getAllInstitutions/*")
public class GetAllInstitutionsServlet extends HttpServlet implements Servlet {
    Logger logger = Logger.getLogger(GetAllInstitutionsServlet.class);
    @EJB(beanName = "InstitutionService")
    protected InstitutionService institutionService;
    @EJB(beanName = "UserService")
    protected UserService userService;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Writer writer = resp.getWriter();
        try {
            List<Institution> institutions;
            String token = String.valueOf(req.getSession().getAttribute("token"));
            User user = userService.getUserOfToken(token);
            if ( req.getParameter("edit") != null && req.getParameter("edit").equals("1") && user.getRole() != Role.ADMINISTRATOR) {
                resp.setContentType("application/json");
                institutions = Lists.newArrayList();
                institutions.add(user.getInstitution());
            } else {
                institutions = institutionService.getAllInstitutions();
                resp.setContentType("application/json");
            }
            String json = new Gson().toJson(institutions);
            writer.write(json);
        } catch (AuthenticationException e) {

        } finally {
            writer.close();
        }
    }
}
