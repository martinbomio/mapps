package com.mapps.receiver;

import java.util.Map;

import com.google.common.base.Optional;
import com.google.common.collect.Maps;

/**
 * A singleton data structure that contain a packet builder for every device on the ZigBee network.
 *
 */
public class PacketBuilderPool {
    private Map<String, PacketBuilder> map;
    private static Optional<PacketBuilderPool> instance = Optional.absent();

    private PacketBuilderPool(){
        map = Maps.newHashMap();
    }

    /**
     * @return the default instance
     */
    public static PacketBuilderPool getDefaultInstace(){
        if (!instance.isPresent()){
            instance = Optional.of(new PacketBuilderPool());
        }
        return instance.get();
    }

    /**
     * @param key the device direction
     * @return true if the pool has a builder for that device, false otherwise.
     */
    public boolean hasPacketBuilder(String key){
        return map.containsKey(key);
    }

    /**
     * @param key the device direction
     * @return the packet builder for the device given.
     */
    public PacketBuilder getPacketBuilder(String key){
        return map.get(key);
    }

    /**
     * Relates a device with a packet builder.
     * @param key the device direction.
     * @param builder the packet builder.
     */
    public void putPacketBuilder(String key, PacketBuilder builder){
        map.put(key, builder);
    }

}
