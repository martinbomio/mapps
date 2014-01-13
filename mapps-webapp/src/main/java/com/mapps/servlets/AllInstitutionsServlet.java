package com.mapps.servlets;

import com.mapps.model.Role;
import com.mapps.services.institution.InstitutionService;
import com.mapps.services.user.UserService;
import com.mapps.services.user.exceptions.AuthenticationException;
import com.mapps.services.user.exceptions.InvalidUserException;

import javax.ejb.EJB;
import javax.servlet.Servlet;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

/**
 *
 */
public class AllInstitutionsServlet extends HttpServlet implements Servlet {
    @EJB(beanName = "UserService")
    UserService userService;

    @EJB(beanName = "InstitutionService")
    InstitutionService institutionService;

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {


        String token = req.getParameter("token");
       try {
            Role role=userService.userRoleOfToken(token);
            req.setAttribute("role",role);
        } catch (InvalidUserException e) {
            e.printStackTrace();  //To change body of catch statement use File | Settings | File Templates.
        } catch (AuthenticationException e) {
            e.printStackTrace();  //To change body of catch statement use File | Settings | File Templates.
        }
        List<String> instNames=institutionService.allInstitutionsNames();

        req.setAttribute("token",token);

        req.setAttribute("institutionNames",instNames);
        try {
            req.getRequestDispatcher("/registerUser.jsp").forward(req, resp);
        } catch (ServletException e) {
            e.printStackTrace();  //To change body of catch statement use File | Settings | File Templates.
        } catch (IOException e) {
            e.printStackTrace();  //To change body of catch statement use File | Settings | File Templates.
        }
    }
}
