package com.mapps.model;


import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;

/**
 * Representation of a processed data unit in the system
 */
@Entity
@Table(name="ProcessedDataUnits")
public class ProcessedDataUnit {

    @Id
    @GeneratedValue(strategy= GenerationType.IDENTITY)
    Long id;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }
}
