package com.mapps.filter;

import java.util.List;

import com.mapps.filter.impl.exceptions.InvalidCoordinatesException;
import com.mapps.model.Device;
import com.mapps.model.KalmanState;
import com.mapps.model.ProcessedDataUnit;
import com.mapps.model.RawDataUnit;
import com.mapps.model.Training;

/**
 * Interface that defines the operations of a Filter. A filter that implements this interface is the one
 * that handles all the manipulation of the data, processing it to retrieve and save processed data.
 */
public interface Filter {
    /**
     * Initialize all the necessary data that is particular for a device on a training. e.g. the
     * start latitude and longitude
     *
     * @param training the training of the data to be processed.
     * @param device the device of the data to be processed.
     * @throws InvalidCoordinatesException when the initial coordenates are invalid.
     */
	public void initData(Training training, Device device) throws InvalidCoordinatesException;

    /**
     * Sets the raw data to be processed by the filter.
     *
     * @param rawData the raw data to be processed.
     */
    public void setRawData(RawDataUnit rawData);

    /**
     * Process the raw data.
     *
     * @throws InvalidCoordinatesException when the coordenates of the data are incorrect.
     */
    public void process() throws InvalidCoordinatesException;

    /**
     * Sets the initial conditions for the filter.
     * @param rawDataUnits the initial conditions.
     */
    public void setUpInitialConditions(List<RawDataUnit> rawDataUnits);

    /**
     * @return the results of the filter.
     */
    public List<ProcessedDataUnit> getResults();

    /**
     * @return the new state after the processing. The states saves how the kalman filter is after a loop.
     */
    public KalmanState getNewState();
}
