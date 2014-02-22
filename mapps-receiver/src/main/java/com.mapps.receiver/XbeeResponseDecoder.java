package com.mapps.receiver;

import com.rapplogic.xbee.api.zigbee.ZNetRxResponse;
import com.rapplogic.xbee.util.ByteUtils;

/**
 * Utility created to decode a XBee Response.
 */
public class XbeeResponseDecoder {
    ZNetRxResponse response;

    public XbeeResponseDecoder(ZNetRxResponse response) {
        this.response = response;
    }

    /**
     * @return the payload of the XBee response.
     */
    public String getPayload() {
        int[] payload = new int[response.getData().length - 19];
        for (int i = 18; i < response.getData().length - 1; i++) {
            payload[i - 18] = response.getData()[i];
        }
        return ByteUtils.toString(payload);
    }

    /**
     * @return true if the packet is complete, false otherwise.
     */
    public boolean isPacketComplete() {
        return response.getData().length > 19;
    }

    /**
     * @return the direction of the device which owns the response.
     */
    public String getDir() {
        String hex = ByteUtils.toBase16(this.response.getRemoteAddress64().getAddress(), "");
        String[] split = hex.split("0x");
        StringBuilder dir = new StringBuilder();
        for (String s : split) {
            dir.append(s);
        }
        return dir.toString();
    }


}
