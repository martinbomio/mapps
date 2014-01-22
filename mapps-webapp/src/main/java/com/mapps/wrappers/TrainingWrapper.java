package com.mapps.wrappers;

import java.util.Date;
import java.util.List;

import com.google.common.collect.Lists;
import com.mapps.model.Athlete;
import com.mapps.model.Device;
import com.mapps.model.Permission;
import com.mapps.model.Report;
import com.mapps.model.Training;
import com.mapps.model.User;

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
    private List<Athlete> athletes;
    private List<Device> devices;
    private List<Report> reports;
    private List<User> users;
    private List<Permission> permissions;

    public TrainingWrapper(Training training){
        this.name = training.getName();
        this.date = training.getDate();
        this.participants = training.getParticipants();
        this.latOrigin = training.getLatOrigin();
        this.longOrigin = training.getLongOrigin();
        this.minBPM = training.getMinBPM();
        this.maxBPM = training.getMaxBPM();
        this.started = training.isStarted();
        this.athletes = Lists.newArrayList();
        this.devices = Lists.newArrayList();
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
