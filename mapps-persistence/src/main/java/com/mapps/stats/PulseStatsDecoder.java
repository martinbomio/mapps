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
        this.time = Lists.newArrayList();
        transverseData();
    }

    private void transverseData() {
        time.add(0L);
        for (RawDataUnit data : rawDataUnits) {
            long timestamp = data.getTimestamp();
            long porcionOfTime = timestamp / data.getPulseData().size();
            for (PulseData pulseData : data.getPulseData()) {
                if(!data.isRead()){
                    latestPulse.add(pulseData.getBPM());
                    latestTime.add(getNextTime(time.get(time.size() - 1), porcionOfTime));
                }
                bpm.add(pulseData.getBPM());
                time.add(getNextTime(time.get(time.size() - 1), porcionOfTime));
            }
        }
        time.remove(0);
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

    public List<Long> getLatestTime(){
        return latestTime;
    }

    public List<Integer> getLatestPulse(){
        return latestPulse;
    }

}
