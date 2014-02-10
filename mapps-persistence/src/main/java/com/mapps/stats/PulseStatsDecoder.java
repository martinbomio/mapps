package com.mapps.stats;

import java.util.List;

import com.google.common.collect.Lists;
import com.mapps.model.PulseData;
import com.mapps.model.RawDataUnit;

/**
 *
 *
 */
public class PulseStatsDecoder {
    List<RawDataUnit> rawDataUnits;
    List<Integer> bpm;
    List<Long> time;
    List<Integer> latestPulse;
    List<Long> latestTime;

    public PulseStatsDecoder(List<RawDataUnit> rawDataUnitList) {
        this.rawDataUnits = rawDataUnitList;
        this.bpm = Lists.newArrayList();
        this.latestPulse = Lists.newArrayList();
        this.time = Lists.newArrayList();
        this.latestTime = Lists.newArrayList();
        transverseData();
    }

    private void transverseData() {
        for (RawDataUnit data : rawDataUnits) {
            for (PulseData pulseData : data.getPulseData()) {
                if (!data.isReaded()){
                    latestPulse.add(pulseData.getBPM());
                    latestTime.add(pulseData.getTimestamp());
                }
                bpm.add(pulseData.getBPM());
                time.add(pulseData.getTimestamp());
            }
        }
        long ajustent = time.get(0);
        time = adjustTime(time, ajustent);
        latestTime = adjustTime(latestTime, ajustent);
    }

    private List<Long> adjustTime(List<Long> time, long ajustment) {
        List<Long> result = Lists.newArrayList();
        for (Long aTime : time){
            result.add(aTime - ajustment);
        }
        return result;
    }

    private Long getNextTime(Long prevTime, Long porcionOfTime) {
        return prevTime + porcionOfTime;
    }

    public long getElapsedTime() {
        long first = time.get(0);
        long last = time.get(time.size() - 1);
        return last - first;
    }

    public List<Long> getTime() {
        return this.time;
    }

    public List<Integer> getPulse() {
        return bpm;
    }

    public List<Long> getLatestTime() {
        return latestTime;
    }

    public List<Integer> getLatestPulse() {
        return latestPulse;
    }

}
