package com.mapps.persistence.impl;

import java.util.List;
import javax.ejb.Stateless;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.Query;

import com.mapps.model.Athlete;
import org.apache.log4j.Logger;

import com.mapps.exceptions.NullParameterException;
import com.mapps.exceptions.ReportNotFoundException;
import com.mapps.model.Report;
import com.mapps.persistence.ReportDAO;

/**
 *
 */
@Stateless(name = "ReportDAO")
public class ReportDAOImpl implements ReportDAO {

    Logger logger = Logger.getLogger(ReportDAOImpl.class);
    @PersistenceContext(unitName = "mapps-persistence")
    EntityManager entityManager;

    @Override
    public void addReport(Report report) throws NullParameterException {
        if (report != null) {
            logger.info("a Report was added to the database");
            entityManager.persist(report);
        } else {
            throw new NullParameterException();
        }
    }

    @Override
    public void deleteReport(Long reportId) throws ReportNotFoundException {
        Report repAux = getReportById(reportId);
        if (repAux != null) {
            entityManager.remove(repAux);
            logger.info("a Report was removed from the database");
        }
    }

    @Override
    public void updateReport(Report report) throws ReportNotFoundException, NullParameterException {
        if (report != null) {
            Report repAux = getReportById(report.getId());
            if (repAux != null) {
                entityManager.merge(report);
                logger.info("A Report was updated in the database");
            }
        } else {
            throw new NullParameterException();
        }
    }

    @Override
    public Report getReportById(Long reportId) throws ReportNotFoundException {
        Report repAux = entityManager.find(Report.class, reportId);
        if (repAux != null) {
            return repAux;
        } else {
            throw new ReportNotFoundException();
        }
    }

    @Override
    public List<Report> getAllReportsByDate(Long reportDate) {
        Query query = entityManager.createQuery("select r from Report as r where r.createdDate=:date");
        query.setParameter("date", reportDate);
        List<Report> result = query.getResultList();
        return result;
    }
    @Override
    public Report getReport(String trainingName,Athlete athlete) throws ReportNotFoundException {
        Query query = entityManager.createQuery("select r from Training t join t.reports r " +
                "where r.athlete=:athlete and t.name=:trainingName");

        query.setParameter("athlete",athlete);
        query.setParameter("trainingName",trainingName);
        List<Report> results = query.getResultList();

        if(results.size()==0){
            return null;
        }else if (results.size() != 1) {
            throw new ReportNotFoundException();
        }
        return results.get(0);
    }

}
