package com.mapps.services.receiver;

import com.mapps.model.Device;
import com.mapps.model.Training;
import com.mapps.services.receiver.exceptions.InvalidDataException;
import com.mapps.services.receiver.exceptions.InvalidDeviceException;

/**
 * Defines the operation of the reciever to the system.
 */
public interface ReceiverService {
    Device getDevice(String dirHigh, String dirLow) throws InvalidDeviceException;
    void handleData(String data, Device device, Training training) throws InvalidDataException, InvalidDeviceException;
}
