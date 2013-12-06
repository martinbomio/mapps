package com.mapps.persistence.impl;

import com.mapps.exceptions.NullParameterException;
import com.mapps.exceptions.ReportAlreadyExistException;
import com.mapps.exceptions.ReportNotFoundException;
import com.mapps.model.Report;
import com.mapps.persistence.ReportDAO;
import org.apache.log4j.Logger;

import javax.ejb.Stateless;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.Query;
import java.util.List;

/**
 *
 */
@Stateless(name="ReportDAO")
public class ReportDAOImpl implements ReportDAO {

    Logger logger= Logger.getLogger(ReportDAOImpl.class);
    @PersistenceContext(unitName = "mapps-persistence")
    EntityManager entityManager;

    @Override
    public void addReport(Report report) throws ReportAlreadyExistException, NullParameterException {
        if(report!=null){
        if(isInDatabase(report)){
            throw new ReportAlreadyExistException();
        }
        logger.info("a Report was added to the database");
        entityManager.persist(report);
        }else{
            throw new NullParameterException();
        }
    }
    private boolean isInDatabase(Report report){
        boolean aux=true;
        Query query=entityManager.createQuery("from Report as r where r.name=:name").setParameter("name",report.getName());
        List<Report> result=query.getResultList();
        if (result.size() == 0){
            aux=false;
        }else{
            aux=true;
        }
        return aux;
    }

    @Override
    public void deleteReport(Long reportId) throws ReportNotFoundException {
      Report repAux=getReportById(reportId);
      if(repAux!=null){
        entityManager.remove(repAux);
        logger.info("a Report was removed from the database");
        }
    }

    @Override
    public void updateReport(Report report) throws ReportNotFoundException, NullParameterException {
        if(report!=null){
        Report repAux=getReportById(report.getId());
        if(repAux!=null){
            entityManager.merge(report);
            logger.info("A Report was updated in the database");
        }
        }else{
            throw new NullParameterException();
        }
    }

    @Override
    public Report getReportById(Long reportId) throws ReportNotFoundException {
       Report repAux=entityManager.find(Report.class,reportId);
       if(repAux!=null){
           return repAux;
       }else{
           throw new ReportNotFoundException();
       }
    }

    @Override
    public List<Report> getAllReportsByDate(Long reportDate) {
        Query query=entityManager.createQuery("from Report as r where r.createdDate=:date");
        query.setParameter("date",reportDate);
        List<Report> result=query.getResultList();
        return result;
    }
}
