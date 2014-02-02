package com.mapps.stats;

import java.util.Collections;
import java.util.List;

import org.apache.commons.lang.ArrayUtils;
import org.apache.commons.math.stat.descriptive.moment.Mean;

import com.google.common.collect.Lists;
import com.mapps.model.ProcessedDataUnit;
import com.mapps.model.PulseData;

/**
 * This class is the responsable of decoding the processed data units and transform them to readable outputs
 * like:
 * - Distance traveled.
 * - Average speed.
 */
public class StatsDecoder {
    private static final int SAMPLING_RATE = 5;
    private List<ProcessedDataUnit> dataUnits;
    private double traveledDistance;
    private List<Double> velocities;
    private List<Integer> pulse;
    private List<Double> posX;
    private List<Double> posY;
    private List<Double> accelX;
    private List<Double> accelY;
    private List<Long> time;
    private List<Double> acceleration;

    public StatsDecoder(List<ProcessedDataUnit> dataUnits) {
        this.dataUnits = dataUnits;
        this.traveledDistance = 0;
        this.velocities = Lists.newArrayList();
        this.pulse = Lists.newArrayList();
        this.posX = Lists.newArrayList();
        this.posY = Lists.newArrayList();
        this.accelX = Lists.newArrayList();
        this.accelY = Lists.newArrayList();
        this.time = Lists.newArrayList();
        this.acceleration = Lists.newArrayList();
        traverseData();
    }

    public List<ProcessedDataUnit> getDataUnits() {
        return dataUnits;
    }

    public void setDataUnits(List<ProcessedDataUnit> dataUnits) {
        this.dataUnits = dataUnits;
    }

    public double getDistanceTraveled() {
        return this.traveledDistance;
    }

    public double getAverageSpeed() {
        Mean mean = new Mean();
        double[] velModules = ArrayUtils.toPrimitive(velocities.toArray(new Double[velocities.size()]));
        return 3.6 * mean.evaluate(velModules);
    }

    private double getModule(double valX, double valY) {
        return Math.sqrt(Math.pow(valX, 2) + Math.pow(valY, 2));
    }

    public long getElapsedTime() {
        long first = dataUnits.get(0).getElapsedTime();
        long last = dataUnits.get(dataUnits.size() - 1).getElapsedTime();
        return ((last) - first);
    }

    public List<Double> getVelocity(){
        return velocities;
    }

    public double getMaxVelocity(){
        return (Collections.max(this.velocities) * 3.6);
    }

    public double getMinVelocity(){
        return (Collections.min(this.velocities) * 3.6);
    }

    public List<Double> getPositionX(){
        return this.posX;
    }

    public List<Double> getPositionY(){
        return this.posY;
    }

    public List<Integer> getPulse(){
        return this.pulse;
    }

    public List<Double> getAccelX(){
        return this.accelX;
    }

    public List<Double> getAccelY(){
        return this.accelY;
    }

    public List<Long> getTime(){
        return this.time;
    }

    public List<Double> getAcceleration(){
        return this.acceleration;
    }

    private void traverseData(){
        int index = 0;
        ProcessedDataUnit last = null;
        for (ProcessedDataUnit data : dataUnits) {
            for (PulseData pulse : data.getRawDataUnit().getPulseData()){
                this.pulse.add(pulse.getBPM());
            }
            if (index == 0) {
                index++;
                last = data;
                continue;
            }
            if (index % (SAMPLING_RATE - 1) == 0) {
                this.posX.add(data.getPositionX());
                this.posY.add(data.getPositionY());
                this.accelX.add(data.getAccelerationX());
                this.accelY.add(data.getAccelerationY());
                this.time.add(data.getElapsedTime());
                double accel = getModule(data.getAccelerationX(), data.getAccelerationY());
                this.acceleration.add(accel);
                double moduleDistance = getModule((data.getPositionX() - last.getPositionX()),
                                          (data.getPositionY() - last.getPositionY()));
                double velocity = getModule(data.getVelocityX(), data.getVelocityY());
                this.velocities.add(velocity * 3.6);
                last = data;
                traveledDistance += moduleDistance;
            }
            index++;
        }
    }
}
