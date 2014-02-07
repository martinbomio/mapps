package com.mapps.jsonexclusions;

import com.google.gson.ExclusionStrategy;
import com.google.gson.FieldAttributes;
import com.mapps.jsonexclusions.annotations.PulseReportExclusion;

/**
 *
 *
 */
public class PulseReportExclusionStrategy implements ExclusionStrategy{
    @Override
    public boolean shouldSkipField(FieldAttributes fieldAttributes) {
        return fieldAttributes.getAnnotation(PulseReportExclusion.class) != null;
    }

    @Override
    public boolean shouldSkipClass(Class<?> aClass) {
        return aClass.getAnnotation(PulseReportExclusion.class) != null;
    }
}
