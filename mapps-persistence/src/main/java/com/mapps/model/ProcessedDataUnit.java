package com.mapps.model;


import javax.persistence.*;

/**
 * Representation of a processed data unit in the system
 */
@Entity
@Table(name="ProcessedDataUnits")

public class ProcessedDataUnit {

    @Id
    @GeneratedValue(strategy= GenerationType.IDENTITY)
    Long id;
    @Column(nullable = false)
    double positionX;
    @Column(nullable = false)
    double positionY;
    @Column(nullable = false)
    double velocityX;
    @Column(nullable = false)
    double velocityY;
    @Column(nullable = false)
    double accelerationX;
    @Column(nullable = false)
    double accelerationY;

    public ProcessedDataUnit(){

    }

    public ProcessedDataUnit(double positionX, double acelerationY, double acelerationX, double velocityY, double velocityX, double positionY) {
        this.positionX = positionX;
        this.accelerationY = acelerationY;
        this.accelerationX = acelerationX;
        this.velocityY = velocityY;
        this.velocityX = velocityX;
        this.positionY = positionY;
    }

    public double getPositionX() {
        return positionX;
    }

    public void setPositionX(double positionX) {
        this.positionX = positionX;
    }

    public double getPositionY() {
        return positionY;
    }

    public void setPositionY(double positionY) {
        this.positionY = positionY;
    }

    public double getVelocityX() {
        return velocityX;
    }

    public void setVelocityX(double velocityX) {
        this.velocityX = velocityX;
    }

    public double getVelocityY() {
        return velocityY;
    }

    public void setVelocityY(double velocityY) {
        this.velocityY = velocityY;
    }

    public double getAccelerationX() {
        return accelerationX;
    }

    public void setAccelerationX(double acelerationX) {
        this.accelerationX = acelerationX;
    }

    public double getAccelerationY() {
        return accelerationY;
    }

    public void setAccelerationY(double acelerationY) {
        this.accelerationY = acelerationY;
    }





    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }
}
