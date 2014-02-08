package com.mapps.model;

/**
 *
 *
 */
public enum TrainingType {
    VERYSOFT(1),
    SOFT(2),
    MODERATED(3),
    INTENSE(4),
    VERYINTENSE(5);

    private int value;

    TrainingType(int value) {
        this.value = value;
    }

    public int toInt() {
        return value;
    }

    public static TrainingType fromInt(int value) {
        switch (value) {
            case 1:
                return VERYSOFT;
            case 2:
                return SOFT;
            case 3:
                return MODERATED;
            case 4:
                return INTENSE;
            case 5:
                return VERYINTENSE;
        }
        return null;
    }

    public static TrainingType fromFCR(int fcr, int age, int bpm) {
        int FCMax = 220 - age;
        double[] margins = new double[]{getMargin(fcr, FCMax, 0.5), getMargin(fcr, FCMax, 0.6), getMargin(fcr, FCMax, 0.7),
                                  getMargin(fcr, FCMax, 0.8), getMargin(fcr, FCMax, 0.9), getMargin(fcr, FCMax, 1.0)};
        if (bpm <= margins[1]){
            return VERYSOFT;
        }else if (bpm <= margins[2]){
            return SOFT;
        }else if (bpm <= margins[3]){
            return MODERATED;
        }else if (bpm <= margins[4]){
            return INTENSE;
        }else{
            return VERYINTENSE;
        }

    }

    public static double getMargin(int fcr, int fcmax, double percentage) {
        return ((fcmax - fcr) * percentage + fcr);
    }

}
