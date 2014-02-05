package com.mapps.model;

import junit.framework.Assert;

import java.util.List;

import org.junit.Test;

/**
 * Tests the populate method
 */
public class RawDataUnitTest {

    @Test
    public void testPopulate(){
        String data = "G:345255776/560287680/8/118:100,I:-4748/194/-90/156/-70/4561:-4748/194/-90/157/-71/4559:," +
                "I:-4747/194/-90/156/-63/4542:-4747/194/-89/161/-79/4559:," +
                "I:-4746/194/-90/160/-77/4566:-4745/194/-90/153/-67/4554:," +
                "I:-4745/194/-90/162/-73/4556:-4744/194/-89/160/-72/4551:";
        RawDataUnit rawDataUnit = new RawDataUnit();
        rawDataUnit.populate(data);

        List<GPSData> gpsList = rawDataUnit.getGpsData();
        List<PulseData> pulseList = rawDataUnit.getPulseData();
        List<IMUData> imuList = rawDataUnit.getImuData();

        Assert.assertTrue(gpsList.size() > 0);
        Assert.assertTrue(imuList.size() > 0);
        Assert.assertTrue(pulseList.size() > 0);

        GPSData gpsData = gpsList.get(0);
        Assert.assertEquals(gpsData.getLatitude(),345255776);
        Assert.assertEquals(gpsData.getLongitude(),560287680);
        Assert.assertEquals(gpsData.getHDOP(),118);
        Assert.assertEquals(gpsData.getnSatelltes(),8);

        PulseData pulseData = pulseList.get(0);
        Assert.assertEquals(pulseData.getBPM(), 100);

        IMUData imuData = imuList.get(5);
        Assert.assertTrue(imuList.size() == 8);
        Assert.assertEquals(imuData.getAccelX(),153);
        Assert.assertEquals(imuData.getAccelY(),-67);
        Assert.assertEquals(imuData.getAccelZ(),4554);
        Assert.assertEquals(imuData.getYaw(),-4745);
        Assert.assertEquals(imuData.getPitch(),194);
        Assert.assertEquals(imuData.getRoll(),-90);
    }
}
