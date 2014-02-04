package com.mapps.persistence;

import java.util.List;
import javax.ejb.Local;

import com.mapps.exceptions.InvalidReportException;
import com.mapps.exceptions.NullParameterException;
import com.mapps.exceptions.ReportAlreadyExistException;
import com.mapps.exceptions.ReportNotFoundException;
import com.mapps.model.Athlete;
import com.mapps.model.Report;

/**
 * ReportDAO interface
 */
@Local
public interface ReportDAO {
    /**
     * This method adds a Report to the database.
     * @param report - The Report to add to the database
     * @throws ReportAlreadyExistException
     */
    void addReport(Report report) throws NullParameterException;

    /**
     * This method deletes a Report from the database.
     * @param reportId - The Report identification id to find the Report to delete
     * @throws ReportNotFoundException - If the Report is not in the database
     */
    void deleteReport(Long reportId) throws ReportNotFoundException;

    /**
     * This method updates a Report in the database.
     * @param report - The Report identification id to find the Report to update
     * @throws ReportNotFoundException  - If the Report is not in the database
     */
    void updateReport(Report report) throws ReportNotFoundException, NullParameterException;

    /**
     * This method gets a Report from the database
     * @param reportId - the Report identification id to find the Report in the database
     * @return - The Report in the database
     * @throws ReportNotFoundException - If the Report is not in the database
     */
    Report getReportById (Long reportId) throws ReportNotFoundException;

    /**
     * This method gets all the Report of one date from the database
     * @param reportDate - the Report identification id to find the Report in the database
     * @return - all the Report of one date
     */
    List<Report> getAllReportsByDate (Long reportDate);

    public Report getReport(String trainingName,Athlete athlete) throws InvalidReportException;

    public List<Report> getReportsOfTraining(String trainingName);
}
