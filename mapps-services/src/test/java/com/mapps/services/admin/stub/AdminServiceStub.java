package com.mapps.services.admin.stub;

import com.mapps.authentificationhandler.AuthenticationHandler;
import com.mapps.persistence.DeviceDAO;
import com.mapps.persistence.TrainingDAO;
import com.mapps.persistence.UserDAO;
import com.mapps.services.admin.impl.AdminServiceImpl;

/**
 *
 *
 */
public class AdminServiceStub extends AdminServiceImpl{

    public void setUserDAO(UserDAO userDAO){
        this.userDAO = userDAO;
    }

    public void setTrainingDAO(TrainingDAO tDAO){
        this.trainingDAO = tDAO;
    }

    public void setAuthenticationHandler(AuthenticationHandler authenticationHandler){
        this.authenticationHandler = authenticationHandler;
    }

    public void setDeviceDAO(DeviceDAO dDAO){
        this.deviceDAO = dDAO;
    }
}
