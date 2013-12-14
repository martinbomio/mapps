package com.mapps.services.kalman;

import javax.ejb.Local;

import com.mapps.model.Device;
import com.mapps.model.RawDataUnit;

/**
 * Interface that defines de operations with the data Filters.
 */
@Local
public interface FilterService {
    void handleData(RawDataUnit rawDataUnit, Device device);
}
