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
        int[] margins = new int[]{getMargin(fcr, FCMax, 50), getMargin(fcr, FCMax, 60), getMargin(fcr, FCMax, 70),
                                  getMargin(fcr, FCMax, 80), getMargin(fcr, FCMax, 90), getMargin(fcr, FCMax, 100)};
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

    public static int getMargin(int fcr, int fcmax, int percentage) {
        return ((fcmax - fcr) * percentage + fcr);
    }

}
