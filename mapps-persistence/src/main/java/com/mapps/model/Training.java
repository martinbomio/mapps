package com.mapps.model;


import java.util.Date;
import java.util.List;
import java.util.Map;
import javax.persistence.*;

import org.hibernate.annotations.Type;

/**
 * Representation of a training in the system
 */
@Entity
@Table(name="Trainings")
public class Training {

    @Id
    @GeneratedValue(strategy= GenerationType.IDENTITY)
    Long id;
    @Column(nullable=false,unique = true)
    private String name;
    @Column(nullable=false)
    private Date date;
    private int participants;
    @Column(nullable=false)
    private long latOrigin;
    @Column(nullable=false)
    private long longOrigin;
    private int minBPM;
    private int maxBPM;
    private boolean started;
    @ManyToMany(fetch = FetchType.EAGER)
    private Map<Athlete,Device> mapAthleteDevice;
    @OneToMany(fetch = FetchType.EAGER)
    private List<Report> reports;
    @ManyToOne
    private Sport sport;
    @ManyToOne
    private Institution institution;

    @ElementCollection(fetch = FetchType.EAGER)
    @JoinTable(name = "Permissions_Users_Training")
    @Enumerated(value = EnumType.ORDINAL)
    @Column(name = "permission")
    @Type(
                    type="org.hibernate.type.EnumType"
            )
    private Map <User,Permission> mapUserPermission;

    public Training(){

    }

    public Training(String name, Date date, int participants, long latOrigin, long longOrigin, int minBPM,
                    int maxBPM, Map<Athlete, Device> mapAthleteDevice, List<Report> reports, Sport sport,
                    Map<User, Permission> mapUserPermission,Institution institution) {
        this.name = name;
        this.date = date;
        this.participants = participants;
        this.latOrigin = latOrigin;
        this.longOrigin = longOrigin;
        this.minBPM = minBPM;
        this.maxBPM = maxBPM;
        this.mapAthleteDevice = mapAthleteDevice;
        this.reports = reports;
        this.sport = sport;
        this.mapUserPermission = mapUserPermission;
        this.institution=institution;
        this.started = false;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Date getDate() {
        return date;
    }

    public void setDate(Date date) {
        this.date = date;
    }

    public int getParticipants() {
        return participants;
    }

    public void setParticipants(int participants) {
        this.participants = participants;
    }

    public long getLatOrigin() {
        return latOrigin;
    }

    public void setLatOrigin(long latOrigin) {
        this.latOrigin = latOrigin;
    }

    public long getLongOrigin() {
        return longOrigin;
    }

    public void setLongOrigin(long longOrigin) {
        this.longOrigin = longOrigin;
    }

    public int getMinBPM() {
        return minBPM;
    }

    public void setMinBPM(int minBPM) {
        this.minBPM = minBPM;
    }

    public int getMaxBPM() {
        return maxBPM;
    }

    public void setMaxBPM(int maxBPM) {
        this.maxBPM = maxBPM;
    }

    public Map<Athlete, Device> getMapAthleteDevice() {
        return mapAthleteDevice;
    }

    public void setMapAthleteDevice(Map<Athlete, Device> mapAthleteDevice) {
        this.mapAthleteDevice = mapAthleteDevice;
    }

    public List<Report> getReports() {
        return reports;
    }

    public void setReports(List<Report> reports) {
        this.reports = reports;
    }

    public Sport getSport() {
        return sport;
    }

    public void setSport(Sport sport) {
        this.sport = sport;
    }

    public Map<User, Permission> getMapUserPermission() {
        return mapUserPermission;
    }

    public void setMapUserPermission(Map<User, Permission> mapUserPermission) {
        this.mapUserPermission = mapUserPermission;
    }

    public boolean isStarted() {
        return started;
    }

    public void setStarted(boolean started) {
        this.started = started;
    }

    public Institution getInstitution() {
        return institution;
    }

    public void setInstitution(Institution institution) {
        this.institution = institution;
    }
}
