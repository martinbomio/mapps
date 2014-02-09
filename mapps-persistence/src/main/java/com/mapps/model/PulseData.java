package com.mapps.model;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.persistence.Transient;

import org.apache.log4j.Logger;

import com.mapps.interfaces.DataParser;

/**
 * Representation of a data packet from the Heart Rate Monitor. Concrete component on a likewise
 * decorator pattern.
 */
@Entity
@Table(name = "PulseData")
public class PulseData implements DataParser{
    @Transient
    Logger log = Logger.getLogger(PulseData.class);
    @Id
    @GeneratedValue(strategy= GenerationType.IDENTITY)
    Long id;
    long timestamp;
    private int BPM;

    public PulseData() {
    }

    public PulseData(int BPM) {
        this.BPM = BPM;
    }

    public PulseData(String data){
        this.populate(data);
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public int getBPM() {
        return BPM;
    }

    public void setBPM(int BPM) {
        this.BPM = BPM;
    }

    public long getTimestamp() {
        return timestamp;
    }

    public void setTimestamp(long timestamp) {
        this.timestamp = timestamp;
    }

    @Override
    public void populate(String data) {
        if (data == null){
            log.error("Error parsing null data");
            throw new IllegalArgumentException();
        }
        String[] split = data.split("#");
        this.timestamp = Long.valueOf(split[1]);
        this.BPM = Integer.parseInt(split[0]);

    }
}
