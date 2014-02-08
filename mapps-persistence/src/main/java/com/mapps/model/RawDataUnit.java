package com.mapps.model;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.Transient;

import org.apache.log4j.Logger;
import org.hibernate.annotations.Fetch;
import org.hibernate.annotations.FetchMode;

import com.mapps.interfaces.DataParser;
import com.mapps.utils.Constants;

/**
 * Represent the data unit that works as input for the Kalman Filter. This object
 * contains all the data necessary for a prediction. A concrete Decorator on the
 * decorator pattern.
 */
@Entity(name = "RawDataUnit")
public class RawDataUnit implements DataParser{
    @Transient
    private static final Logger logger = Logger.getLogger(RawDataUnit.class);

    @Id
    @GeneratedValue(strategy= GenerationType.IDENTITY)
    Long id;
    @OneToMany(cascade = CascadeType.PERSIST, fetch = FetchType.EAGER)
    @Fetch(value = FetchMode.SUBSELECT)
    private List<IMUData> imuData;
    @OneToMany(cascade = CascadeType.PERSIST, fetch = FetchType.EAGER)
    @Fetch(value = FetchMode.SUBSELECT)
    private List<GPSData> gpsData;
    @OneToMany(cascade = CascadeType.PERSIST, fetch = FetchType.EAGER)
    @Fetch(value = FetchMode.SUBSELECT)
    private List<PulseData> pulseData;
    @ManyToOne
    private Device device;
    @Column(nullable = false)
    private Long timestamp;
    private Date date;
    private boolean correct;
    @ManyToOne
    private Training training;
    private boolean readed;

    public RawDataUnit(List<IMUData> imuData, List<GPSData> gpsData, List<PulseData> pulseData,
                       Device device, Long timestamp, Date date, Training training) {
        this.imuData = imuData;
        this.gpsData = gpsData;
        this.pulseData = pulseData;
        this.device = device;
        this.timestamp = timestamp;
        this.date = date;
        this.correct = true;
        this.training = training;
        this.readed = false;
    }

    public RawDataUnit() {
    }

    public RawDataUnit(String data) {
        this.setCorrect(true);
        this.date = new Date();
        this.readed = false;
        this.populate(data);
    }

    public boolean isCorrect() {
        return correct;
    }

    public void setCorrect(boolean correct) {
        this.correct = correct;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public List<IMUData> getImuData() {
        return imuData;
    }

    public void setImuData(List<IMUData> imuData) {
        this.imuData = imuData;
    }

    public List<GPSData> getGpsData() {
        return gpsData;
    }

    public void setGpsData(List<GPSData> gpsData) {
        this.gpsData = gpsData;
    }

    public List<PulseData> getPulseData() {
        return pulseData;
    }

    public void setPulseData(List<PulseData> pulseData) {
        this.pulseData = pulseData;
    }

    public Device getDevice() {
        return device;
    }

    public void setDevice(Device device) {
        this.device = device;
    }

    public Long getTimestamp() {
        return timestamp;
    }

    public void setTimestamp(Long timestamp) {
        this.timestamp = timestamp;
    }

    public Date getDate() {
        return date;
    }

    public void setDate(Date date) {
        this.date = date;
    }

    public Training getTraining() {
        return training;
    }

    public void setTraining(Training training) {
        this.training = training;
    }

    public boolean isReaded() {
        return readed;
    }

    public void setReaded(boolean readed) {
        this.readed = readed;
    }

    @Override
    public void populate(String data) {
        if (data == null){
            throw new IllegalArgumentException();
        }
        String[] separetedData = data.split(",");
        if (separetedData.length >0 ){
            pulseData = new ArrayList<PulseData>();
        }
        for(String d : separetedData){
            String[] sensorData = d.split(":");
            if( sensorData[0].equals(Constants.PULSEDELIMETER)){
                PulseData pulse = new PulseData(sensorData[1]);
                pulseData.add(pulse);
            }else{
                logger.error("Invalid raw data unit");
            }

        }
    }
}
