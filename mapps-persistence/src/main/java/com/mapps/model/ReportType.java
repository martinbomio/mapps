package com.mapps.model;

/**
 * Representation of a type of report.
 */
public enum ReportType {
    TRAINNING(1),
    ATHLETE(2),
    DAILY(3),
    MENSUAL(4);

    private int value;

    ReportType(int value) {
        this.value = value;
    }

    public int toInt() {
        return value;
    }

    public  static ReportType fromInt(int value){
        switch(value) {
            case 1: return TRAINNING;
            case 2: return ATHLETE;
            case 3: return DAILY;
            case 4: return MENSUAL;
        }
        return null;
    }

    public String toString() {
        switch(this) {
            case TRAINNING:
                return "Training";
            case ATHLETE:
                return "Athlete";
            case DAILY:
                return "Daily";
            case MENSUAL:
                return "Mensual";
        }
        return null;
    }
}
