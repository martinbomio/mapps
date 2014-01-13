package com.mapps.servlets;

import com.mapps.model.Role;
import com.mapps.services.institution.InstitutionService;
import com.mapps.services.user.UserService;
import com.mapps.services.user.exceptions.AuthenticationException;
import com.mapps.services.user.exceptions.InvalidUserException;
import org.apache.log4j.Logger;

import java.io.IOException;
import java.util.List;
import javax.ejb.EJB;
import javax.servlet.Servlet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


/**
 *
 */
@WebServlet(name = "registerUserLink", urlPatterns = "/registerUserLink/*")
public class RegisterUserServletLink extends HttpServlet implements Servlet {
    Logger logger = Logger.getLogger(RegisterUserServletLink.class);
    @EJB(beanName = "UserService")
    UserService userService;
    @EJB(beanName = "InstitutionService")
    InstitutionService institutionService;


    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)throws ServletException, IOException{
        String token = req.getParameter("token");
        logger.info(token);

        try {
            Role role=userService.userRoleOfToken(token);
            req.setAttribute("role",role);
        } catch (InvalidUserException e) {
            req.setAttribute("error","Invalid user");
        } catch (AuthenticationException e) {
            req.setAttribute("error", "Authentication error");
        }
        List<String> instNames = institutionService.allInstitutionsNames();

        req.setAttribute("token",token);

        req.setAttribute("institutionNames",instNames);

        req.getRequestDispatcher("/registerUser.jsp").forward(req, resp);
    }
}
