package com.mapps.model;

import java.util.Date;
import java.util.List;
import javax.persistence.Column;
import javax.persistence.ElementCollection;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.ManyToOne;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

import com.mapps.stats.StatsDecoder;

/**
 * Represents a report in the model. Report can be for trainings or per athlete.
 */
@Entity
@Table(name = "Reports")
public class Report {
    @Id
    @GeneratedValue(strategy= GenerationType.IDENTITY)
    Long id;
    @Temporal(TemporalType.DATE)
    @Column(nullable = false)
    private Date createdDate;
    @ManyToOne
    private Athlete athlete;
    private double traveledDistance;
    private double averageSpeed;
    private double maxVelocity;
    private double minVelocity;
    @ElementCollection
    private List<Double> posX;
    @ElementCollection
    private List<Double> posY;
    @ElementCollection
    private List<Double> velocity;
    @ElementCollection
    private List<Integer> pulse;
    private String trainingName;
    @ElementCollection
    private List<Double> accelX;
    @ElementCollection
    private List<Double> accelY;
    @ElementCollection
    private List<Long> time;
    private long elapsedTime;

    public Report() {
    }

    public Report(String trainingName, Date createdDate, Athlete athlete, double traveledDistance, double averageSpeed,
                  double maxVelocity, double minVelocity, List<Double> posX, List<Double> posY,
                  List<Double> velocity, List<Integer> pulse, List<Double> accelX, List<Double> accelY, List<Long> time,
                  long elapsedTime) {
        this.createdDate = createdDate;
        this.athlete = athlete;
        this.traveledDistance = traveledDistance;
        this.averageSpeed = averageSpeed;
        this.maxVelocity = maxVelocity;
        this.minVelocity = minVelocity;
        this.posX = posX;
        this.posY = posY;
        this.velocity = velocity;
        this.pulse = pulse;
        this.accelX = accelX;
        this.accelY = accelY;
        this.trainingName = trainingName;
        this.time = time;
        this.elapsedTime = elapsedTime;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Date getCreatedDate() {
        return createdDate;
    }

    public void setCreatedDate(Date createdDate) {
        this.createdDate = createdDate;
    }

    public Athlete getAthlete() {
        return athlete;
    }

    public void setAthlete(Athlete athlete) {
        this.athlete = athlete;
    }

    public double getTraveledDistance() {
        return traveledDistance;
    }

    public void setTraveledDistance(double traveledDistance) {
        this.traveledDistance = traveledDistance;
    }

    public double getAverageSpeed() {
        return averageSpeed;
    }

    public void setAverageSpeed(double averageSpeed) {
        this.averageSpeed = averageSpeed;
    }

    public double getMaxVelocity() {
        return maxVelocity;
    }

    public void setMaxVelocity(double maxVelocity) {
        this.maxVelocity = maxVelocity;
    }

    public double getMinVelocity() {
        return minVelocity;
    }

    public void setMinVelocity(double minVelocity) {
        this.minVelocity = minVelocity;
    }

    public List<Double> getPosX() {
        return posX;
    }

    public void setPosX(List<Double> posX) {
        this.posX = posX;
    }

    public List<Double> getPosY() {
        return posY;
    }

    public void setPosY(List<Double> posY) {
        this.posY = posY;
    }

    public List<Double> getVelocity() {
        return velocity;
    }

    public void setVelocity(List<Double> velocity) {
        this.velocity = velocity;
    }

    public List<Integer> getPulse() {
        return pulse;
    }

    public void setPulse(List<Integer> pulse) {
        this.pulse = pulse;
    }

    public String getTrainingName() {
        return trainingName;
    }

    public void setTrainingName(String trainingName) {
        this.trainingName = trainingName;
    }

    public List<Double> getAccelX() {
        return accelX;
    }

    public void setAccelX(List<Double> accelX) {
        this.accelX = accelX;
    }

    public List<Double> getAccelY() {
        return accelY;
    }

    public void setAccelY(List<Double> accelY) {
        this.accelY = accelY;
    }

    public List<Long> getTime() {
        return time;
    }

    public void setTime(List<Long> time) {
        this.time = time;
    }

    public static class Builder{
        private List<ProcessedDataUnit> processedDataUnits;
        private Athlete athlete;
        private String trainingName;

        public Builder setData(List<ProcessedDataUnit> processedDataUnits){
            this.processedDataUnits = processedDataUnits;
            return this;
        }

        public Builder setAthlete(Athlete athlete){
            this.athlete = athlete;
            return this;
        }

        public Builder setTrainingName(String trainingName){
            this.trainingName = trainingName;
            return this;
        }

        public Report build(){
            Report report = processData(this.processedDataUnits, athlete);
            return report;
        }

        private Report processData(List<ProcessedDataUnit> processedDataUnits, Athlete athlete) {
            StatsDecoder decoder = new StatsDecoder(processedDataUnits);

            Report report = new Report(this.trainingName, new Date(), athlete, decoder.getDistanceTraveled(),
                                       decoder.getAverageSpeed(), decoder.getMaxVelocity(), decoder.getMinVelocity(),
                                       decoder.getPositionX(), decoder.getPositionY(), decoder.getVelocity(),
                                       decoder.getPulse(), decoder.getAccelX(), decoder.getAccelY(), decoder.getTime(),
                                       decoder.getElapsedTime());
            return report;
        }
    }
}
