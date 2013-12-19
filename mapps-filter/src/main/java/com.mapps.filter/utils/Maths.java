package com.mapps.filter.utils;

/**
 *
 */
public class Maths {
    public static double getMean(Double [] data){
        double sum = 0.0;
        for(int i = 0 ; i < data.length ; i ++){
            sum += data[i];
        }
        return sum/data.length;
    }

    public static double getVariance(Double [] data){
        double mean = getMean(data);
        double temp = 0;
        for(int i = 0 ; i < data.length ; i ++){
            temp += (mean-data[i])*(mean-data[i]);
        }
        return temp/data.length;
    }

    public static double getStdDev(Double [] data){
        return java.lang.Math.sqrt(getVariance(data));
    }
}
