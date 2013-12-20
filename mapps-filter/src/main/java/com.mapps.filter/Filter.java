package com.mapps.filter;

import java.util.List;

import com.mapps.filter.impl.exceptions.InvalidCoordinatesException;
import com.mapps.model.Device;
import com.mapps.model.KalmanState;
import com.mapps.model.ProcessedDataUnit;
import com.mapps.model.RawDataUnit;
import com.mapps.model.Training;

/**
 * Interface that defines the methods of a filter.
 */
public interface Filter {
    public void initData(Training training, Device device) throws InvalidCoordinatesException;
    public void setRawData(RawDataUnit rawData);
    public void process() throws InvalidCoordinatesException;
    public void setUpInitialConditions(List<RawDataUnit> rawDataUnits);
    public List<ProcessedDataUnit> getResults();
    public KalmanState getNewState();
}
