package com.mapps.wrappers;

import java.util.List;

import com.google.gson.Gson;
import com.mapps.model.Athlete;
import com.mapps.model.ProcessedDataUnit;
import com.mapps.services.util.StatsDecoder;

/**
 *
 *
 */
public class AthleteInfoWrapper {
    private Athlete athlete;
    private List<ProcessedDataUnit> pDataUnits;
    private double distanceTraveled;
    private double averageSpeed;

    public AthleteInfoWrapper(Athlete athlete, List<ProcessedDataUnit> pDataUnits) {
        this.athlete = athlete;
        this.pDataUnits = pDataUnits;
        StatsDecoder statsDecoder = new StatsDecoder(pDataUnits);
        this.distanceTraveled = statsDecoder.getDistanceTraveled();
        this.averageSpeed = statsDecoder.getAverageSpeed();
    }

    public String toJson(){
        return new Gson().toJson(this);
    }
}
