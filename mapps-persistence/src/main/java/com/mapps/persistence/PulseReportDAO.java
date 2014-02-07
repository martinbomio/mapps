package com.mapps.persistence;

import java.util.List;
import javax.ejb.Local;

import com.mapps.exceptions.NullParameterException;
import com.mapps.exceptions.ReportNotFoundException;
import com.mapps.model.PulseReport;
import com.mapps.model.Report;


/**
 * ReportDAO interface
 */
@Local
public interface PulseReportDAO {
    /**
     * This method adds a Report to the database.
     * @param report - The Report to add to the database
     * @throws com.mapps.exceptions.ReportAlreadyExistException
     */
    void addReport(PulseReport report) throws NullParameterException;

    /**
     * This method deletes a Report from the database.
     * @param reportId - The Report identification id to find the Report to delete
     * @throws com.mapps.exceptions.ReportNotFoundException - If the Report is not in the database
     */
    void deleteReport(Long reportId) throws ReportNotFoundException;

    /**
     * This method updates a Report in the database.
     * @param report - The Report identification id to find the Report to update
     * @throws ReportNotFoundException  - If the Report is not in the database
     */
    void updateReport(PulseReport report) throws ReportNotFoundException, NullParameterException;

    /**
     * This method gets a Report from the database
     * @param reportId - the Report identification id to find the Report in the database
     * @return - The Report in the database
     * @throws ReportNotFoundException - If the Report is not in the database
     */
    Report getReportById (Long reportId) throws ReportNotFoundException;

    List<PulseReport> getReportsOfTraining(String trainingName);
}
