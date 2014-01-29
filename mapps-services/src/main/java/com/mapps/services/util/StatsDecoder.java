package com.mapps.services.util;

import java.util.List;

import org.apache.commons.lang.ArrayUtils;
import org.apache.commons.math.stat.descriptive.moment.Mean;

import com.google.common.collect.Lists;
import com.mapps.model.ProcessedDataUnit;

/**
 * This class is the responsable of decoding the processed data units and transform them to readable outputs
 * like:
 * - Distance traveled.
 * - Average speed.
 */
public class StatsDecoder {
    private static final int SAMPLING_RATE = 5;
    private List<ProcessedDataUnit> dataUnits;
    private Double distanceTraveled;

    public StatsDecoder(List<ProcessedDataUnit> dataUnits) {
        this.dataUnits = dataUnits;
        this.distanceTraveled = null;
    }

    public List<ProcessedDataUnit> getDataUnits() {
        return dataUnits;
    }

    public void setDataUnits(List<ProcessedDataUnit> dataUnits) {
        this.dataUnits = dataUnits;
    }

    public double getDistanceTraveled() {
        int index = 0;
        double distance = 0;
        ProcessedDataUnit last = null;
        for (ProcessedDataUnit data : dataUnits) {
            if (index == 0) {
                index++;
                last = data;
                continue;
            }
            if (index % SAMPLING_RATE == 0) {
                double module = getModule((data.getPositionX() - last.getPositionX()),
                                          (data.getPositionY() - last.getPositionY()));
                last = data;
                distance += module;
            }
            index++;
        }
        this.distanceTraveled = distance;
        return distance;
    }

    public double getAverageSpeed() {
        Mean mean = new Mean();
        List<Double> velocities = Lists.newArrayList();
        for (ProcessedDataUnit data : dataUnits){
            velocities.add(getModule(data.getVelocityX(), data.getVelocityY()));
        }
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
}
