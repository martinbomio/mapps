package com.mapps.wrappers;

import java.util.List;

import com.google.common.collect.Lists;
import com.google.gson.Gson;
import com.mapps.model.Athlete;
import com.mapps.model.ProcessedDataUnit;
import com.mapps.model.PulseData;
import com.mapps.services.util.StatsDecoder;
import com.mapps.filter.utils.Maths;

/**
 *
 *
 */
public class AthleteStatsWrapper {
    private String trainingName;
    private Athlete athlete;
    private List<Double> accelX;
    private List<Double> accelY;
    private List<Double> velX;
    private List<Double> velY;
    private List<Double> modVel;
    private List<Double> posX;
    private List<Double> posY;
    private List<Integer> pulse;
    private List<Long> time;
    private double distanceTraveled;
    private double averageSpeed;

    public AthleteStatsWrapper(String trainingName, Athlete athlete, List<ProcessedDataUnit> pDataUnits) {
        this.trainingName = trainingName;
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
            Double modulo=Math.sqrt(Math.pow(pData.getVelocityX(),2)+Math.pow(pData.getVelocityY(),2));
            modVel.add(modulo);
            posX.add(pData.getPositionX());
            posY.add(pData.getPositionY());
            time.add(pData.getElapsedTime());
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
        this.time = Lists.newArrayList();
        this.modVel=Lists.newArrayList();
    }

    public String toJson(){
        return new Gson().toJson(this);
    }
}
