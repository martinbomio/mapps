package com.mapps.receiver;

import com.mapps.receiver.exceptions.CouldNotInvokeServiceException;

/**
 * Invoks the receiver service on the Server.
 */
public interface ServiceInvoker {
    /**
     * Invokes the remote service.
     * @param packet the string representing the data packet;
     */
    void invokeService(String packet) throws CouldNotInvokeServiceException;

}
