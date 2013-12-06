package com.mapps.model;


import com.mapps.exceptions.RoleNotFoundException;

/**
 * Representation of the Role of a User in the system.
 */
public enum Role {
    ADMINISTRATOR(1),
    TRAINER(2),
    USER(3);

    private int value;

    Role(int value) {
        this.value = value;
    }

    public int toInt() {
        return value;
    }

    public  static Role fromInt(int value) throws RoleNotFoundException {
        switch(value) {
            case 1: return ADMINISTRATOR;
            case 2: return TRAINER;
            case 3: return USER;
            default:
                throw new RoleNotFoundException();
        }
    }

    public String toString() {
        switch(this) {
            case ADMINISTRATOR:
                return "Administrator";
            case TRAINER:
                return "Trainer";
            case USER:
                return "User";
        }
        return null;
    }
}
