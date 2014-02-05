package com.mapps.persistence.impl;

import javax.ejb.Stateless;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;

import org.apache.log4j.Logger;

import com.mapps.exceptions.NullParameterException;
import com.mapps.exceptions.ReportNotFoundException;
import com.mapps.model.PulseReport;
import com.mapps.model.Report;
import com.mapps.persistence.PulseReportDAO;

/**
 * Implementation of PulseReportDAO.
 */
@Stateless(name = "PulseReportDAO")
public class PulseReportDAOImpl implements PulseReportDAO {
    Logger logger = Logger.getLogger(PulseReportDAOImpl.class);
    @PersistenceContext(unitName = "mapps-persistence")
    EntityManager entityManager;

    @Override
    public void addReport(PulseReport report) throws NullParameterException {
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
    public void updateReport(PulseReport report) throws ReportNotFoundException, NullParameterException {
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
}
