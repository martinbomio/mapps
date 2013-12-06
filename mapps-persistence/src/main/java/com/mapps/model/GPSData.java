package com.mapps.model;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.persistence.Transient;

import org.apache.log4j.Logger;

import com.mapps.interfaces.DataParser;

/**
 * Representation of a data packet from the GPS. Concrete component on a likewise
 * decorator pattern.
 */
@Entity
@Table(name = "GPSData")
public class GPSData implements DataParser{
    @Transient
    Logger logger = Logger.getLogger(GPSData.class);
    @Id
    @GeneratedValue(strategy= GenerationType.IDENTITY)
    Long id;
    @Column(nullable = false)
    private long latitude;
    @Column(nullable = false)
    private long longitude;
    @Column(nullable = false)
    private int nSatelltes;
    @Column(nullable = false)
    private int HDOP;

    public GPSData() {
    }
    public GPSData(String data) {
        this.populate(data);
    }

    public GPSData(long latitude, long longitude, int nSatelltes, int HDOP) {
        this.latitude = latitude;
        this.longitude = longitude;
        this.nSatelltes = nSatelltes;
        this.HDOP = HDOP;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public long getLatitude() {
        return latitude;
    }

    public void setLatitude(long latitude) {
        this.latitude = latitude;
    }

    public long getLongitude() {
        return longitude;
    }

    public void setLongitude(long longitude) {
        this.longitude = longitude;
    }

    public int getnSatelltes() {
        return nSatelltes;
    }

    public void setnSatelltes(int nSatelltes) {
        this.nSatelltes = nSatelltes;
    }

    public int getHDOP() {
        return HDOP;
    }

    public void setHDOP(int HDOP) {
        this.HDOP = HDOP;
    }

    @Override
    public void populate(String data) {
        if (data == null){
            logger.error("Error parsing null data");
            throw new IllegalArgumentException();
        }
        String[] split = data.split("/");
        this.latitude = Long.parseLong(split[0]);
        this.longitude = Long.parseLong(split[1]);
        this.nSatelltes = Integer.parseInt(split[2]);
        this.HDOP = Integer.parseInt(split[3]);
    }
}
