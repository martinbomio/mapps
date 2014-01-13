package com.mapps.servlets;

import com.mapps.model.Sport;
import com.mapps.services.trainer.TrainerService;
import com.mapps.services.trainer.exceptions.AuthenticationException;
import com.mapps.services.trainer.exceptions.InvalidSportException;

import javax.ejb.EJB;
import javax.servlet.Servlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 */
public class AddSportServlet extends HttpServlet implements Servlet {

    @EJB(beanName = "TrainerService")
    TrainerService trainerService;

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp){
        String token = req.getParameter("token");
        String sportName=req.getParameter("name");
        Sport newSport =new Sport(sportName);

        try {
            trainerService.addSport(newSport,token);
            req.setAttribute("token", token);
        } catch (InvalidSportException e) {
            req.setAttribute("error", "Invalid sport");
        } catch (AuthenticationException e) {
            req.setAttribute("error", "Invalid authentication");
        }


    }
}
