package com.mapps.persistence.impl;

import junit.framework.Assert;

import java.util.Date;
import java.util.List;
import javax.ejb.embeddable.EJBContainer;
import javax.naming.NamingException;

import org.junit.AfterClass;
import org.junit.Before;
import org.junit.BeforeClass;
import org.junit.Test;

import com.mapps.model.Device;
import com.mapps.model.RawDataUnit;
import com.mapps.model.Training;
import com.mapps.persistence.DeviceDAO;
import com.mapps.persistence.RawDataUnitDAO;

import static org.junit.Assert.assertTrue;

/**
 * Test for RawDataUnitDAO
 */
public class RawDataUnitDAOImplTest {
    private static EJBContainer ejbContainer;
    private RawDataUnitDAO rawDataUnitDAO;
    private DeviceDAO deviceDAO;

    @BeforeClass
    public static void startTheContainer(){

        ejbContainer= EJBContainer.createEJBContainer();
    }
    @Before
    public void lookupABean() throws NamingException {

        Object dao=ejbContainer.getContext().lookup("java:global/mapps-persistence/RawDataUnitDAO");
        Object deviceDao=ejbContainer.getContext().lookup("java:global/mapps-persistence/DeviceDAO");
        assertTrue(dao instanceof RawDataUnitDAO);
        assertTrue(deviceDao instanceof DeviceDAO);
        rawDataUnitDAO = (RawDataUnitDAO)dao;
        this.deviceDAO = (DeviceDAO)deviceDao;
    }

    @AfterClass
    public static void stopTheContainer(){
        if(ejbContainer!=null){
            ejbContainer.close();
        }
    }
    @Test
    public void testInitialConditionsSatisfied() throws Exception {
        Device device = new Device("123","456",55,null);
        deviceDAO.addDevice(device);

        Training training = new Training(null,new Date(),1,1L,1L,0,0,null,null,null,null,null);
        addRawDataUnits(50, device);
        Assert.assertTrue(rawDataUnitDAO.initialConditionsSatisfied(training, device));
    }
    @Test
    public void testGetInitialConditions() throws Exception {
        Device device = new Device("123","456789",55,null);
        deviceDAO.addDevice(device);

        Training training = new Training(null,new Date(),1,1L,1L,0,0,null,null,null,null,null);
        addRawDataUnits(50, device);
        List<RawDataUnit> rawDataUnits = rawDataUnitDAO.getInitialConditions(training, device);
        Assert.assertEquals(rawDataUnits.size(), 45);
        Date first = rawDataUnits.get(0).getDate();
        Date last = rawDataUnits.get(rawDataUnits.size()-1).getDate();
        Assert.assertTrue(first.getTime() < last.getTime());
    }

    private void addRawDataUnits(int numb, Device device) throws Exception{
        for(int i = 0; i < numb; i++){
            RawDataUnit data = new RawDataUnit(null, null,null,device,1L,false,new Date(),null);
            rawDataUnitDAO.addRawDataUnit(data);
        }
    }
}
