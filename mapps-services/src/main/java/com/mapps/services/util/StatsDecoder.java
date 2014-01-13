package com.mapps.services.util;

import java.util.Date;
import java.util.List;

import com.mapps.model.ProcessedDataUnit;

/**
 * This class is the responsable of decoding the processed data units and transform them to readable outputs
 * like:
 *      - Distance traveled.
 *      - Average speed.
 */
public class StatsDecoder {
    private List<ProcessedDataUnit> dataUnits;
    private Double distanceTraveled;

    public StatsDecoder(List<ProcessedDataUnit> dataUnits){
        this.dataUnits = dataUnits;
        this.distanceTraveled = null;
    }

    public List<ProcessedDataUnit> getDataUnits() {
        return dataUnits;
    }

    public void setDataUnits(List<ProcessedDataUnit> dataUnits) {
        this.dataUnits = dataUnits;
    }

    public double getDistanceTraveled(){
        double distance = 0;
        for (ProcessedDataUnit data : dataUnits){
            double module = getModule(data.getPositionX(), data.getPositionY());
            distance += module;
        }
        this.distanceTraveled = distance;
        return distance;
    }

    public double getAverageSpeed(){
        if(distanceTraveled == null){
            getDistanceTraveled();
        }
        long timeElapsed = getElapsedTime();
        double timeInSec = timeElapsed / 1000;
        return this.distanceTraveled / timeInSec;
    }

    private double getModule(double valX, double valY) {
        return Math.sqrt(Math.pow(valX, 2) + Math.pow(valY, 2));
    }

    public long getElapsedTime() {
        Date first = dataUnits.get(0).getRawDataUnit().getDate();
        Date last = dataUnits.get(dataUnits.size()-1).getRawDataUnit().getDate();
        return ((last.getTime() + 1000) - first.getTime());
    }
}
