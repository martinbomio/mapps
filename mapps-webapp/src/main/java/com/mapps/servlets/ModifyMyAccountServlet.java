package com.mapps.servlets;

import com.mapps.model.User;
import com.mapps.services.admin.AdminService;
import com.mapps.services.user.UserService;
import com.mapps.services.user.exceptions.AuthenticationException;
import com.mapps.services.user.exceptions.InvalidUserException;

import javax.ejb.EJB;
import javax.servlet.Servlet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 *
 */
@WebServlet(name = "modifyMyAccount", urlPatterns = "/modifyMyAccount/*")
public class ModifyMyAccountServlet extends HttpServlet implements Servlet {
    @EJB(beanName = "AdminService")
    AdminService adminService;
    @EJB(beanName = "UserService")
    UserService userService;

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String token = String.valueOf(req.getSession().getAttribute("token"));
        String name = req.getParameter("name");

        String lastName = req.getParameter("lastName");
        String email = req.getParameter("email");

        try {
            User user = userService.getUserOfToken(token);
            user.setName(name);
            user.setLastName(lastName);
            user.setEmail(email);
            userService.updateUser(user, token);
            resp.sendRedirect("configuration/my_account.jsp?info=5");
        } catch (AuthenticationException e) {
            resp.sendRedirect("configuration/edit_my_user.jsp");
        } catch (InvalidUserException e) {
            resp.sendRedirect("configuration/edit_my_user.jsp");
        }
    }

}
