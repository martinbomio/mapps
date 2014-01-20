package com.mapps.servlets.stubs;

import com.mapps.services.institution.InstitutionService;
import com.mapps.services.user.UserService;
import com.mapps.servlets.GetAllInstitutionsServlet;

/**
 *
 *
 */
public class GetAllInstitutionsServletStub extends GetAllInstitutionsServlet {
    public void setInstitutionService(InstitutionService institutionService){
        this.institutionService = institutionService;
    }
    public void setUserService(UserService userService){
        this.userService = userService;
    }
}
