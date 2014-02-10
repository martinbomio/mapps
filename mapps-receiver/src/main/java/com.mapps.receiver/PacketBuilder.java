package com.mapps.receiver;

import java.util.Date;

import org.apache.log4j.Logger;

import com.mapps.receiver.exceptions.CouldNotInvokeServiceException;

/**
 *
 */
public class PacketBuilder {
    Logger logger = Logger.getLogger(PacketBuilder.class);
    private StringBuilder builder;
    private String dirLow;
    private ServiceInvoker serviceInvoker;
    private int count;

    public PacketBuilder(String dir) {
        String dirLow = dir.substring(8);
        this.dirLow = dirLow;
        this.builder = new StringBuilder();
        this.builder.append(this.dirLow + "@");
        this.count = 0;
        serviceInvoker = new ResfulServiceInvoker();
    }

    public void addPacket(String packet)  {
        if (packet.substring(0,1).equals("P")){
            String payload = packet.split(",")[0];
            appendString(payload);
            count++;
            if( count == 3){
                String finalPacket = getPacket();
                logger.info("Packet: " + finalPacket);
                    try{
                        serviceInvoker.invokeService(finalPacket);
                    } catch (CouldNotInvokeServiceException e) {
                        logger.error(e);
                    }
                builder.setLength(0);
                builder.append(this.dirLow + "@");
                count = 0;
            }
        }
    }

    private void appendString(String payload) {
        builder.append(payload);
        
        builder.append("#");
        builder.append(new Date().getTime());
        builder.append(",");
    }

    public String getPacket(){
        return this.builder.toString();
    }

    public String getDirLow() {
        return dirLow;
    }

    public void setDirLow(String dir) {
        if (this.dirLow == null){
            String dirLow = dir.substring(8);
            this.dirLow = dirLow;
            this.builder.append(this.dirLow + "@");
        }
    }
}
