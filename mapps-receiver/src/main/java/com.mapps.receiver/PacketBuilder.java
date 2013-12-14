package com.mapps.receiver;

/**
 *
 */
public class PacketBuilder {
    private StringBuilder builder;
    private String dirLow;
    private boolean started;

    public PacketBuilder() {
        this.builder = new StringBuilder();
    }

    public void addPacket(String packet){
        if (packet.substring(0).equals("G")){
            if(builder.length() != 17){
                System.out.println(getPacket());
                builder.setLength(0);
                setDirLow(this.dirLow);
            }
            this.started = false;
        }
        if (this.started){
            builder.append(packet);
        }
    }

    public String getPacket(){
        return this.builder.toString();
    }

    public String getDirLow() {
        return dirLow;
    }

    public void setDirLow(String dirLow) {
        if (this.dirLow == null){
            this.dirLow = dirLow;
            this.builder.append(dirLow + "@");
            System.out.println(builder.length());
        }
    }
}
