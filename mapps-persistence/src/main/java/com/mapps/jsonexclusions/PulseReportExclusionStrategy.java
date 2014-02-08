package com.mapps.jsonexclusions;

import java.util.Arrays;
import java.util.Map;

import com.google.common.collect.Maps;
import com.google.gson.ExclusionStrategy;
import com.google.gson.FieldAttributes;
import com.mapps.model.PulseReport;

/**
 *
 *
 */
public class PulseReportExclusionStrategy implements ExclusionStrategy{
    private Map<Class<?>, String[]> exclusions;

    public PulseReportExclusionStrategy(){
        exclusions = Maps.newHashMap();
        exclusions.put(PulseReport.class, new String[]{"time", "pulse", "athlete"});
        for(Map.Entry<Class<?>,String[]> entry : exclusions.entrySet()){
            Arrays.sort(entry.getValue());
        }
    }
    @Override
    public boolean shouldSkipField(FieldAttributes fieldAttributes) {
        if(exclusions.containsKey(fieldAttributes.getDeclaredClass())){
            return Arrays.binarySearch(exclusions.get(fieldAttributes.getDeclaredClass()),fieldAttributes.getName())>=0;
        }
        return false;
    }

    @Override
    public boolean shouldSkipClass(Class<?> aClass) {
        return false;
    }
}
