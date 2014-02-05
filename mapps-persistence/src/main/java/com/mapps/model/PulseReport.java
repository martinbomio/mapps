package com.mapps.model;

import java.util.Date;
import java.util.List;
import javax.persistence.Column;
import javax.persistence.ElementCollection;
import javax.persistence.Entity;
import javax.persistence.Enumerated;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.ManyToOne;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;
import javax.persistence.Transient;

import org.hibernate.annotations.LazyCollection;
import org.hibernate.annotations.LazyCollectionOption;

import com.google.gson.annotations.Expose;
import com.mapps.pulsedata.RestPulseForAge;
import com.mapps.stats.PulseStatsDecoder;
import com.mapps.wrappers.AthleteWrapper;

/**
 * Represents a pulse report on the database. Gives the necessary information about pulse calculations a data
 * to display the necessary information.
 */
@Entity
@Table(name = "PulseReport")
public class PulseReport {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    Long id;
    @ElementCollection
    @LazyCollection(LazyCollectionOption.FALSE)
    private List<Integer> pulse;
    @LazyCollection(LazyCollectionOption.FALSE)
    @ElementCollection
    private List<Long> time;
    private long elapsedTime;
    @Temporal(TemporalType.DATE)
    @Column(nullable = false)
    private Date createdDate;
    @ManyToOne(fetch = FetchType.EAGER)
    @Expose
    private Athlete athlete;
    @Transient
    private AthleteWrapper athleteWrapper;
    @Enumerated
    private TrainingType trainingTyepe;
    private String trainingName;

    public PulseReport() {

    }

    public PulseReport(String trainingName, List<Long> time, List<Integer> pulse, long elapsedTime, Date createdDate, Athlete athlete) {
        this.trainingName = trainingName;
        this.time = time;
        this.pulse = pulse;
        this.elapsedTime = elapsedTime;
        this.createdDate = createdDate;
        this.athlete = athlete;
        this.athleteWrapper = new AthleteWrapper.Builder().setAthlete(this.athlete).build();
        this.trainingTyepe = getTrainingType();
    }

    public List<Integer> getPulse() {
        return pulse;
    }

    public void setPulse(List<Integer> pulse) {
        this.pulse = pulse;
    }

    public List<Long> getTime() {
        return time;
    }

    public void setTime(List<Long> time) {
        this.time = time;
    }

    public long getElapsedTime() {
        return elapsedTime;
    }

    public void setElapsedTime(long elapsedTime) {
        this.elapsedTime = elapsedTime;
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

    public AthleteWrapper getAthleteWrapper() {
        return athleteWrapper;
    }

    public void setAthleteWrapper(AthleteWrapper athleteWrapper) {
        this.athleteWrapper = athleteWrapper;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public TrainingType getTrainingType() {
        RestPulseForAge restPulse = RestPulseForAge.loadFromJson();
        List<Integer> fcr;
        if (athlete.getGender().equals(Gender.MALE)) {
            fcr = restPulse.getMalePulse();
        } else {
            fcr = restPulse.getFemalePulse();
        }
        int age = athleteWrapper.getAge();
        return TrainingType.fromFCR(fcr.get(age), age, pulse.get(pulse.size() - 1));
    }

    public static class Builder {
        private List<RawDataUnit> rawDataUnits;
        private Athlete athlete;
        private Training training;

        public Builder setPulseData(List<RawDataUnit> rawDataUnits) {
            this.rawDataUnits = rawDataUnits;
            return this;
        }

        public Builder setAthlete(Athlete athlete) {
            this.athlete = athlete;
            return this;
        }

        public Builder setTraining(Training training) {
            this.training = training;
            return this;
        }

        public PulseReport build() {
            PulseStatsDecoder decoder = new PulseStatsDecoder(this.rawDataUnits);
            PulseReport report = new PulseReport(training.getName(),
                                                 decoder.getTime(),
                                                 decoder.getPulse(),
                                                 decoder.getElapsedTime(),
                                                 new Date(), this.athlete);
            return report;
        }

    }
}
