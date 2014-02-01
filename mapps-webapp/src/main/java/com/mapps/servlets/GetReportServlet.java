package com.mapps.servlets;

import javax.servlet.Servlet;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;

/**
 *
 */
@WebServlet(name = "getReport", urlPatterns = "/getReport/*")
public class GetReportServlet extends HttpServlet implements Servlet {
}
