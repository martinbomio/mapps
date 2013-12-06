package com.mapps.persistence.impl;

import com.mapps.exceptions.DeviceAlreadyExistException;
import com.mapps.exceptions.DeviceNotFoundException;
import com.mapps.exceptions.NullParameterException;
import com.mapps.model.Device;
import com.mapps.persistence.DeviceDAO;
import org.apache.log4j.Logger;

import javax.ejb.Stateless;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.Query;
import java.util.List;


/**
 *
 */
@Stateless(name = "DeviceDAO")
public class DeviceDAOImpl implements DeviceDAO{

    Logger logger=Logger.getLogger(DeviceDAOImpl.class);
    @PersistenceContext(unitName="mapps-persistence")
    EntityManager entityManager;

    @Override
    public void addDevice(Device device) throws DeviceAlreadyExistException, NullParameterException {
        if(device!=null){
        if(isInDatabase(device)){
            throw new DeviceAlreadyExistException();
        }
        logger.info("add a Device to database");
        entityManager.persist(device);
        }else{
            throw new NullParameterException();
        }
    }

    private List<Device> getByDir(Device device){
        Query query=entityManager.createQuery("from Device as d where d.dirLow=:dir");
        query.setParameter("dir",device.getDirLow());
        List<Device> results=query.getResultList();
        return results;
    }



    private boolean isInDatabase(Device device) {
        boolean aux=true;
        List<Device> results=getByDir(device);
        if(results.size()==0){
           aux=false;
        }else{
            aux=true;
        }
        return aux;

    }

    @Override
    public void deleteDevice(Long deviceId) throws DeviceNotFoundException {
        logger.info("A Device was removed from the database");
        Device deviceAux=getDeviceById(deviceId);
        if(deviceAux!=null){
            entityManager.remove(deviceAux);
        }
    }

    @Override
    public void updateDevice(Device device) throws DeviceNotFoundException, NullParameterException {
       if(device!=null){
       Device deviceAux=getDeviceById(device.getId());
       if(deviceAux!=null){
           entityManager.merge(device);
           logger.info("A Device was updated in the database");
       }
       }else{
           throw new NullParameterException();
       }
    }

    @Override
    public Device getDeviceById(Long deviceId) throws DeviceNotFoundException {
       Device deviceAux=entityManager.find(Device.class,deviceId);
       if(deviceAux!=null){
           return deviceAux;
       }else{
           throw new DeviceNotFoundException();
       }
    }

    @Override
    public Device getDeviceByDir(String dirLow) throws DeviceNotFoundException {
        Query query=entityManager.createQuery("from Device as d where d.dirLow=:dir");
        query.setParameter("dir",dirLow);
        List<Device> results=query.getResultList();
        if(results.size()!=1){
            throw new DeviceNotFoundException();
        }
        return results.get(0);
    }

    @Override
    public List<Device> getAllDevicesByInstitution(String institutionName) {
        Query query=entityManager.createQuery("select d from Device as d INNER JOIN d.institution as i WHERE i.name =:name");
        query.setParameter("name",institutionName);
        List<Device> results=query.getResultList();
        return results;
    }
}
