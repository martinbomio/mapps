package com.mapps.filter.utils;

/**
 *
 */
public class Maths {
    public static double getMean(Double[] data) {
        double sum = 0.0;
        for (int i = 0; i < data.length; i++) {
            sum += data[i];
        }
        return sum / data.length;
    }

    public static double getVariance(Double[] data) {
        double mean = getMean(data);
        double temp = 0;
        for (int i = 0; i < data.length; i++) {
            temp += (mean - data[i]) * (mean - data[i]);
        }
        return temp / data.length;
    }

    public static double getStdDev(Double[] data) {
        return java.lang.Math.sqrt(getVariance(data));
    }

    public static double getPonderateMean(Double[] data) {
        double sum = 0;
        int i = 0;
        int multiplier = 1;
        for (Double element : data) {
            if (i > 14) multiplier = 3;
            sum += element * multiplier;
            i++;
        }
        int divisor = 15 + 30 * 3;
        return sum / divisor;
    }
}
