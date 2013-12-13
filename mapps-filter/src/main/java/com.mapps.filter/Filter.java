package com.mapps.filter;

import java.util.List;

import com.mapps.model.Device;
import com.mapps.model.RawDataUnit;
import com.mapps.model.Training;

/**
 * Interface that defines the methods of a filter.
 */
public interface Filter {
    public void initData(Training training, Device device);
    public void setRawData(RawDataUnit rawData);
    public void process();
    public void setUpInitialConditions(List<RawDataUnit> rawDataUnits);
}
