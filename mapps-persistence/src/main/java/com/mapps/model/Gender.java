package com.mapps.model;

import javax.management.relation.RoleNotFoundException;

/**
 * Represent the gendre of a Person
 */
public enum Gender {
    MALE(1),
    FEMALE(2),
    UNKNOWN(3);

    private int value;

    Gender(int value) {
        this.value = value;
    }

    public int toInt() {
        return value;
    }

    public  static Gender fromInt(int value) throws RoleNotFoundException {
        switch(value) {
            case 1: return MALE;
            case 2: return FEMALE;
            case 3: return UNKNOWN;
        }
        return null;
    }

    public String toString() {
        switch(this) {
            case MALE:
                return "Male";
            case FEMALE:
                return "Female";
            case UNKNOWN:
                return "Unknown";
        }
        return null;
    }
}
