package com.mapps.wrappers;

import java.util.Date;
import java.util.List;

import com.google.common.collect.Lists;
import com.mapps.model.*;

/**
 *
 *
 */
public class TrainingWrapper {
    private String name;
    private Date date;
    private int participants;
    private long latOrigin;
    private long longOrigin;
    private int minBPM;
    private int maxBPM;
    private boolean started;
    private boolean finished;
    private List<Athlete> athletes;
    private List<Device> devices;

    private List<User> users;
    private List<Permission> permissions;
    private Sport sport;

    public TrainingWrapper(Training training){
        this.name = training.getName();
        this.date = training.getDate();
        this.participants = training.getParticipants();
        this.latOrigin = training.getLatOrigin();
        this.longOrigin = training.getLongOrigin();
        this.minBPM = training.getMinBPM();
        this.maxBPM = training.getMaxBPM();
        this.started = training.isStarted();
        this.finished = training.isFinished();
        this.athletes = Lists.newArrayList();
        this.devices = Lists.newArrayList();
        this.sport=training.getSport();

        for (Athlete athlete : training.getMapAthleteDevice().keySet()){
            this.athletes.add(athlete);
            this.devices.add(training.getMapAthleteDevice().get(athlete));
        }
        this.users = Lists.newArrayList();
        this.permissions = Lists.newArrayList();
        for (User user : training.getMapUserPermission().keySet()){
            this.users.add(user);
            this.permissions.add(training.getMapUserPermission().get(user));
        }
    }
}
