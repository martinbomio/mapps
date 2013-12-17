package com.mapps.receiver;

import org.apache.log4j.Logger;

import com.rapplogic.xbee.api.XBee;
import com.rapplogic.xbee.api.XBeeException;
import com.rapplogic.xbee.api.zigbee.ZNetRxResponse;
import com.rapplogic.xbee.util.ByteUtils;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;

/**
 *
 */
public class XBeeReceiver {
    Logger logger = Logger.getLogger(XBeeReceiver.class);

    public static void main(String[] args){
        XBee xbee = new XBee();
        try {
            xbee.open("COM6",115200);
            PacketBuilder builder = new PacketBuilder();
            File file = new File("src/main/resources/data.txt");
            BufferedWriter bf = new BufferedWriter(new FileWriter(file));
            while (true) {
                try{
                    ZNetRxResponse ioSample = (ZNetRxResponse) xbee.getResponse();
                    if(ioSample.getData().length>19){
                        int[] payload=new int[ioSample.getData().length-19];
                        for(int i=18;i<ioSample.getData().length-1;i++){
                            payload[i-18]=ioSample.getData()[i];
                        }
                        String dir = getStringDir(ByteUtils.toBase16(ioSample.getRemoteAddress64().getAddress(),""));
                        builder.setDirLow(dir);
                        builder.addPacket(ByteUtils.toString(payload),bf);
                    }
                }catch (ClassCastException e){
                    e.printStackTrace();
                }
            }
        } catch (XBeeException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();  //To change body of catch statement use File | Settings | File Templates.
        } finally {
            xbee.close();
        }
    }

    private static String getStringDir(String hex) {
        String[] split = hex.split("0x");
        StringBuilder dir = new StringBuilder();
        for (String s : split){
            dir.append(s);
        }
        return dir.toString();
    }
}
