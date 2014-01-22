package com.mapps.servlets;

import java.io.IOException;
import javax.ejb.EJB;
import javax.servlet.Servlet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.mapps.exceptions.NullParameterException;
import com.mapps.model.Permission;
import com.mapps.model.Role;
import com.mapps.model.Training;
import com.mapps.model.User;
import com.mapps.services.admin.AdminService;
import com.mapps.services.admin.exceptions.AuthenticationException;
import com.mapps.services.admin.exceptions.InvalidUserException;
import com.mapps.services.institution.InstitutionService;
import com.mapps.services.trainer.TrainerService;
import com.mapps.services.trainer.exceptions.InvalidTrainingException;
import com.mapps.services.user.UserService;

/**
 *
 */
@WebServlet(name = "changePermission", urlPatterns = "/changePermission/*")
public class ChangePermissionServlet extends HttpServlet implements Servlet {
    @EJB(beanName = "UserService")
    UserService userService;
    @EJB(beanName = "TrainerService")
    TrainerService trainerService;
    @EJB(beanName = "InstitutionService")
    InstitutionService institutionService;
    @EJB(beanName = "AdminService")
    AdminService adminService;

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String token = String.valueOf(req.getSession().getAttribute("token"));
        int numberOfUsers=Integer.parseInt(req.getParameter("numberOfUsers"));
        String trainingName = req.getParameter("name-hidden");
        String username="";
        Permission perm=Permission.READ;

        try {
            Training training = trainerService.getTrainingByName(token,trainingName);
        for (int i=0;i<numberOfUsers;i++){
            username=req.getParameter("username-hidden"+i);
            if (req.getParameter("permission_list"+i).equals("Crear")) {
                perm = Permission.CREATE;
            } else {
                perm = Permission.READ;
            }
            User user = adminService.getUserByUsername(username);
            adminService.changePermissions(training, user, perm, token);

        }

            resp.sendRedirect("training/trainings.jsp");
        } catch (InvalidUserException e) {
            resp.sendRedirect("training/change_permissions_training.jsp?error");
        } catch (AuthenticationException e) {
            resp.sendRedirect("training/change_permissions_training.jsp?error");
        } catch (InvalidTrainingException e) {
            resp.sendRedirect("training/change_permissions_training.jsp?error");
        } catch (com.mapps.services.trainer.exceptions.AuthenticationException e) {
            resp.sendRedirect("training/change_permissions_training.jsp?error");
        } catch (NullParameterException e) {
            resp.sendRedirect("training/change_permissions_training.jsp?error");
        }

    }
}
