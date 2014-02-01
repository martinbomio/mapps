package com.mapps.receiver;

import java.util.Map;

import com.google.common.base.Optional;
import com.google.common.collect.Maps;

/**
 *
 *
 */
public class PacketBuilderPool {
    private Map<String, PacketBuilder> map;
    private static Optional<PacketBuilderPool> instance;

    private PacketBuilderPool(){
        map = Maps.newHashMap();
    }

    public static PacketBuilderPool getDefaultInstace(){
        if (!instance.isPresent()){
            instance = Optional.of(new PacketBuilderPool());
        }
        return instance.get();
    }

    public boolean hasPacketBuilder(String key){
        return map.containsKey(key);
    }

    public PacketBuilder getPacketBuilder(String key){
        return map.get(key);
    }

    public void putPacketBuilder(String key, PacketBuilder builder){
        map.put(key, builder);
    }

}
