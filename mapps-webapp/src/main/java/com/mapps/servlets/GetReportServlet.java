package com.mapps.servlets;

import javax.servlet.Servlet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.Writer;

/**
 *
 */
@WebServlet(name = "getReport", urlPatterns = "/getReport/*")
public class GetReportServlet extends HttpServlet implements Servlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
    String trainingID = req.getParameter("t");
    String athleteCI = req.getParameter("a");
    String token = String.valueOf(req.getSession().getAttribute("token"));
    Writer writer = resp.getWriter();


    }
}
