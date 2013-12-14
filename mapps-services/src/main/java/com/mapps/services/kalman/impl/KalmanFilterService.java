package com.mapps.services.kalman.impl;

import java.util.List;
import javax.ejb.Asynchronous;
import javax.ejb.EJB;
import javax.ejb.Stateless;

import com.mapps.filter.Filter;
import com.mapps.model.Device;
import com.mapps.model.RawDataUnit;
import com.mapps.persistence.RawDataUnitDAO;
import com.mapps.services.kalman.FilterService;

/**
 *
 */
@Stateless
public class KalmanFilterService implements FilterService{
    @EJB
    private RawDataUnitDAO rDataDAO;
    private Filter kalmanFilter;
    private List<RawDataUnit> initialConditions;

    @Asynchronous
    public void handleData(RawDataUnit rawDataUnit, Device device){
        loadInitialConditions(device);
    }

    private void loadInitialConditions(Device device) {

    }

    private boolean initialConditionsSatisfied() {
        return false;
    }



}
