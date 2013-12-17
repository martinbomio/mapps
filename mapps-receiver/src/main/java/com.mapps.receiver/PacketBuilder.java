package com.mapps.receiver;

import com.mapps.receiver.exceptions.CouldNotInvokeServiceException;
import org.apache.log4j.Logger;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;

/**
 *
 */
public class PacketBuilder {
    Logger logger = Logger.getLogger(PacketBuilder.class);
    private StringBuilder builder;
    private String dirLow;
    private boolean started;
    private ServiceInvoker serviceInvoker;

    public PacketBuilder() {
        this.builder = new StringBuilder();
        serviceInvoker = new ResfulServiceInvoker();
    }

    public void addPacket(String packet,BufferedWriter bf)  {
        if (packet.substring(0,1).equals("G")){
            if(builder.length() != 9){
                String finalPacket = getPacket();
                logger.info("Packet: " + finalPacket);



                    try{

                    bf.write(finalPacket);
                    bf.newLine();

                    serviceInvoker.invokeService(finalPacket);
                } catch (CouldNotInvokeServiceException e) {
                    logger.error(e);
                } catch (IOException e) {
                        e.printStackTrace();  //To change body of catch statement use File | Settings | File Templates.
                    }finally {
                        if(bf!=null){
                            try {
                                bf.close();
                            } catch (IOException e) {
                                e.printStackTrace();  //To change body of catch statement use File | Settings | File Templates.
                            }
                        }
                    }
                builder.setLength(0);
                builder.append(this.dirLow + "@");

            }
            this.started = true;
        }
        if (this.started){
            builder.append(packet + ",");
        }
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
