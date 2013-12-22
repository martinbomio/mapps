package com.mapps.servlets;

import com.mapps.services.institution.InstitutionService;
import com.mapps.services.user.UserService;

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
public class RegisterUserServlet extends HttpServlet implements Servlet {

    @EJB(beanName = "UserService")
    UserService userService;
    @EJB(beanName = "InstitutionService")
    InstitutionService institutionService;


    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp){
        String token = req.getParameter("token");
        List<String> instNames=institutionService.allInstitutionsNames();
        String inst=instNames.get(0);



        req.setAttribute("token",token);
        req.setAttribute("inst",inst);

        try {
            req.getRequestDispatcher("/mainPage.jsp").forward(req, resp);
        } catch (ServletException e) {
            e.printStackTrace();  //To change body of catch statement use File | Settings | File Templates.
        } catch (IOException e) {
            e.printStackTrace();  //To change body of catch statement use File | Settings | File Templates.
        }


    }

}
