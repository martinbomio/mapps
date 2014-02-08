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
        transverseData();
    }

    private void transverseData() {
        List<String> auxTime = Lists.newArrayList();
        List<String> latestAuxTime = Lists.newArrayList();
        for (RawDataUnit data : rawDataUnits) {
            auxTime.add(data.getPulseData().size() + "@" + data.getTimestamp());
            for (PulseData pulseData : data.getPulseData()) {
                if (!data.isReaded()){
                    latestPulse.add(pulseData.getBPM());
                }
                bpm.add(pulseData.getBPM());
            }
        }
        this.time = calculateTime(auxTime);
        this.latestTime = calculateTime(latestAuxTime);
    }

    private List<Long> calculateTime(List<String> auxTime) {
        List<Long> time = Lists.newArrayList();
        long prev = 0;
        int lastSize = 0;
        for (int i = 0; i < auxTime.size(); i++) {
            String[] split = auxTime.get(i).split("@");
            long currentTime = Long.valueOf(split[1]);
            if (i == 0) {
                time.add(currentTime);
            } else {
                long porcion = (currentTime - prev) / (lastSize + 1);
                for (int j = 0; j < lastSize; j++) {
                    long next = getNextTime(prev, (j+1) * porcion);
                    time.add(next);
                }
                time.add(currentTime);
            }
            lastSize = Integer.valueOf(split[0]);
            if (i == (auxTime.size() -1)){
                long porcion = (currentTime - prev) / (lastSize + 1);
                for (int j = 0; j < lastSize; j++) {
                    long next = getNextTime(currentTime, (j+1) * porcion);
                    time.add(next);
                }
            }
            prev = currentTime;
        }
        return time;
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
