package com.mapps.servlets;

import com.mapps.model.User;
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
@WebServlet(name = "changePassword", urlPatterns = "/changePassword/*")
public class ChangePasswordServlet extends HttpServlet implements Servlet {

    @EJB(beanName = "UserService")
    UserService userService;

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String token = String.valueOf(req.getSession().getAttribute("token"));
        String oldPassword = req.getParameter("oldPassword");
        String newPassword = req.getParameter("newPassword");

        try {
            User user =userService.getUserOfToken(token);
            String userPassword=user.getPassword();
            String username=user.getUserName();
            if(userPassword.equals(oldPassword)){
                user.setPassword(newPassword);
                userService.updateUser(user,token);
                String newToken=userService.login(username, newPassword);
                req.getSession().setAttribute("token", newToken);
                resp.sendRedirect("configuration/my_account.jsp?info=1");
            }else{
                resp.sendRedirect("configuration/change_my_password.jsp?info=2");
            }
        } catch (AuthenticationException e) {
            resp.sendRedirect("configuration/change_my_password.jsp?error=1");
        } catch (InvalidUserException e) {
            resp.sendRedirect("configuration/change_my_password.jsp?error=1");
        }


    }
}
