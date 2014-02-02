package com.mapps.receiver;

import org.apache.log4j.Logger;

import com.rapplogic.xbee.api.ApiId;
import com.rapplogic.xbee.api.XBee;
import com.rapplogic.xbee.api.XBeeException;
import com.rapplogic.xbee.api.XBeeResponse;
import com.rapplogic.xbee.api.zigbee.ZNetRxResponse;

/**
 *
 */
public class XBeeReceiver {
    private static Logger logger = Logger.getLogger(XBeeReceiver.class);

    public static void main(String[] args) {
        XBee xbee = new XBee();
        try {
            xbee.open("COM6", 115200);
            while (true) {
                XBeeResponse response = xbee.getResponse();
                if (response.getApiId() == ApiId.ZNET_RX_RESPONSE) {
                    XbeeResponseDecoder decoder = new XbeeResponseDecoder((ZNetRxResponse) response);
                    if (decoder.isPacketComplete()) {
                        PacketBuilderPool pool = PacketBuilderPool.getDefaultInstace();
                        String dir = decoder.getDir();
                        if (!pool.hasPacketBuilder(dir)) {
                            PacketBuilder builder = new PacketBuilder(dir);
                            builder.setDirLow(dir);
                            pool.putPacketBuilder(dir, builder);
                        }
                        PacketBuilder builder = pool.getPacketBuilder(dir);
                        builder.addPacket(decoder.getPayload());
                    } else {
                        logger.debug("The XBee packet is incomplete");
                    }
                }
            }
        } catch (XBeeException e){
            e.printStackTrace();
        } finally {
            xbee.close();
        }
    }
}
