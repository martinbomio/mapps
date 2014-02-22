package com.mapps.services.kalman;

import javax.ejb.Local;

import com.mapps.model.Device;
import com.mapps.model.RawDataUnit;
import com.mapps.model.Training;

/**
 * Interface that defines de operations with the data Filters. The filters are the ones that process
 * the raw data and transforms it to processed data ready to be shown to the user.
 * This abstraction allow to switch the actual implementation of the algorithm to transform the data.
 */
@Local
public interface FilterService {
    /**
     * Method that performs all the manipulation of the raw data. Transforms the data and saves it.
     *
     * @param rawDataUnit the raw daata to be processed.
     * @param device the device that generated the raw data.
     * @param training the training in which the raw data was generated.
     */
    void handleData(RawDataUnit rawDataUnit, Device device, Training training);
}
