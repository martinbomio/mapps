package com.mapps.receiver;

import org.apache.log4j.Logger;

import com.rapplogic.xbee.api.XBee;
import com.rapplogic.xbee.api.XBeeException;
import com.rapplogic.xbee.api.zigbee.ZNetRxResponse;
import com.rapplogic.xbee.util.ByteUtils;

/**
 *
 */
public class XBeeReceiver {
    Logger logger = Logger.getLogger(XBeeReceiver.class);

    public static void main(String[] args){
        XBee xbee = new XBee();
        try {
            xbee.open("/dev/tty.usbserial-A40084il",115200);
            PacketBuilder builder = new PacketBuilder();
            while (true) {
                ZNetRxResponse ioSample = (ZNetRxResponse) xbee.getResponse();
                if(ioSample.getData().length>19){
                    System.out.println(ByteUtils.toString(ioSample.getData()));
                    int[] payload=new int[ioSample.getData().length-19];
                    for(int i=18;i<ioSample.getData().length-1;i++){
                        payload[i-18]=ioSample.getData()[i];
                    }
                    System.out.println(ByteUtils.toString(payload));
                    builder.setDirLow(ByteUtils.toString(ioSample.getRemoteAddress64().getAddress()));
                    builder.addPacket(ByteUtils.toString(payload));
                }
            }
        } catch (XBeeException e) {
            e.printStackTrace();
        }  finally {
            xbee.close();
        }
    }
}
