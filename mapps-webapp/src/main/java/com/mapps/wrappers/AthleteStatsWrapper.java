package com.mapps.wrappers;

import java.util.List;

import com.google.common.collect.Lists;
import com.google.gson.Gson;
import com.mapps.model.Athlete;
import com.mapps.model.ProcessedDataUnit;
import com.mapps.model.PulseData;
import com.mapps.services.util.StatsDecoder;

/**
 *
 *
 */
public class AthleteStatsWrapper {
    private Athlete athlete;
    private List<Double> accelX;
    private List<Double> accelY;
    private List<Double> velX;
    private List<Double> velY;
    private List<Double> posX;
    private List<Double> posY;
    private List<Integer> pulse;
    private double distanceTraveled;
    private double averageSpeed;

    public AthleteStatsWrapper(Athlete athlete, List<ProcessedDataUnit> pDataUnits) {
        this.athlete = athlete;
        StatsDecoder statsDecoder = new StatsDecoder(pDataUnits);
        this.distanceTraveled = statsDecoder.getDistanceTraveled();
        this.averageSpeed = statsDecoder.getAverageSpeed();
        getStatsList(pDataUnits);
    }

    private void getStatsList(List<ProcessedDataUnit> pDataUnits) {
        initLists();
        for (ProcessedDataUnit pData : pDataUnits){
            accelX.add(pData.getAccelerationX());
            accelY.add(pData.getAccelerationY());
            velX.add(pData.getVelocityX());
            velY.add(pData.getVelocityY());
            posX.add(pData.getPositionX());
            posY.add(pData.getPositionY());
            for (PulseData pulseData : pData.getRawDataUnit().getPulseData()){
                pulse.add(pulseData.getBPM());
            }
        }
    }

    private void initLists() {
        this.accelX = Lists.newArrayList();
        this.accelY = Lists.newArrayList();
        this.velX = Lists.newArrayList();
        this.velY = Lists.newArrayList();
        this.posX = Lists.newArrayList();
        this.posY = Lists.newArrayList();
        this.pulse = Lists.newArrayList();
    }

    public String toJson(){
        return new Gson().toJson(this);
    }
}
