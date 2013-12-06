package com.mapps.model;


import com.mapps.exceptions.PermissionNotFoundException;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;

/**
 * Representation of the Permissions of the system
 */

public enum Permission {

    READ(1),
    CREATE(2);


    private int value;

    Permission(int value) {
        this.value = value;
    }

    public int toInt() {
        return value;
    }

    public  static Permission fromInt(int value) throws PermissionNotFoundException {
        switch(value) {
            case 1: return READ;
            case 2: return CREATE;
            default:
                throw new PermissionNotFoundException();
        }
    }

    public String toString() {
        switch(this) {
            case READ:
                return "Read";
            case CREATE:
                return "Create";
        }
        return null;
    }

}
