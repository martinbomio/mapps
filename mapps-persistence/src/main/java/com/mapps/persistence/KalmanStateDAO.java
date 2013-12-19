package com.mapps.persistence;

import javax.ejb.Local;

import com.mapps.exceptions.NullParameterException;
import com.mapps.model.Device;
import com.mapps.model.KalmanState;
import com.mapps.model.Training;

/**
 * Defines the operations with the Kalman state
 */
@Local
public interface KalmanStateDAO {
    KalmanState getLastState(Training training, Device device) throws NullParameterException;
    void addKalmanState(KalmanState state) throws NullParameterException;
}
