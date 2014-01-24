package com.mapps.model;

import java.util.Date;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.ManyToOne;

/**
 * Represents the previousState of the kalman filter.
 */
@Entity(name = "KalmanState")
public class KalmanState {
    @Id
    @GeneratedValue(strategy= GenerationType.IDENTITY)
    Long id;
    @Column(nullable = false, length = 500)
    private String previousState;
    @Column(nullable = false, length = 500)
    private String qMatrix;
    @Column(nullable = false, length = 500)
    private String rgi;
    private double gpsError;
    private double aXBias;
    private double ayBias;
    private double initialYaw;
    private Date date;
    @ManyToOne
    private Training training;
    @ManyToOne
    private Device device;

    public KalmanState() {
    }

    public KalmanState(String previousState, String qMatrix, String rgi, double gpsError, double aXBias,
                       double ayBias, double initialYaw, Date date, Training training, Device device) {
        this.previousState = previousState;
        this.qMatrix = qMatrix;
        this.rgi = rgi;
        this.gpsError = gpsError;
        this.aXBias = aXBias;
        this.ayBias = ayBias;
        this.date = date;
        this.training = training;
        this.device = device;
        this.initialYaw = initialYaw;
    }

    public String getRgi() {
        return rgi;
    }

    public void setRgi(String rgi) {
        this.rgi = rgi;
    }

    public String getqMatrix() {
        return qMatrix;
    }

    public void setqMatrix(String qMatrix) {
        this.qMatrix = qMatrix;
    }

    public double getGpsError() {
        return gpsError;
    }

    public void setGpsError(double gpsError) {
        this.gpsError = gpsError;
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

    public Device getDevice() {
        return device;
    }

    public void setDevice(Device device) {
        this.device = device;
    }

    public String getPreviousState() {
        return previousState;
    }

    public void setPreviousState(String previousState) {
        this.previousState = previousState;
    }

    public double getaXBias() {
        return aXBias;
    }

    public void setaXBias(double aXBias) {
        this.aXBias = aXBias;
    }

    public double getAyBias() {
        return ayBias;
    }

    public void setAyBias(double ayBias) {
        this.ayBias = ayBias;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public double getInitialYaw() {
        return initialYaw;
    }

    public void setInitialYaw(double initialYaw) {
        this.initialYaw = initialYaw;
    }
}
