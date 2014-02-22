package com.mapps.services.receiver;

import com.mapps.model.Device;
import com.mapps.model.Training;
import com.mapps.services.receiver.exceptions.InvalidDataException;
import com.mapps.services.receiver.exceptions.InvalidDeviceException;

/**
 * Defines the operation of the reciever to the system. This services will be invoked by the receiver
 * who transmits the received and processed data from the devices on the ZigBee network.
 */

public interface ReceiverService {
    /**
     * @param dirHigh the high direction of the xbee device.
     * @param dirLow the low direction of the xbee device.
     * @return the device with the directions passed by parameter.
     * @throws InvalidDeviceException
     */
    Device getDevice(String dirHigh, String dirLow) throws InvalidDeviceException;

    /**
     * This method checks the nature of the data to be handled and invokes the handle data on
     * the filter service. Checks if the data is ok and creates the raw data from the String
     * data passed as parameter and
     *
     * @param data the string representing the actual raw data.(payload of the ZigBee packet)
     * @param device the device that generated the data.
     * @param training the training in which the data was created.
     * @throws InvalidDataException when the data passed isn' in the right format.
     * @throws InvalidDeviceException
     */
    void handleData(String data, Device device, Training training) throws InvalidDataException, InvalidDeviceException;

    /**
     * This is the service called by the receiver and is the one that separates the data, into the
     * device direction and the actual data, and gets the training of the data.
     *
     * @param data the data that represents the unit created buy the receiver. It has the
     *             device direction and actual data.
     */
    void persistData(String data);
}
