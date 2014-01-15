package com.mapps.persistence;

import java.util.List;
import javax.ejb.Local;

import com.mapps.exceptions.AthleteAlreadyExistException;
import com.mapps.exceptions.AthleteNotFoundException;
import com.mapps.exceptions.NullParameterException;
import com.mapps.model.Athlete;

import java.util.List;

/**
 * AthleteDAO interface
 */
@Local
public interface AthleteDAO {
    /**
     * This method adds a Athlete to the database.
     * @param athlete - The Athlete to add to the database
     * @throws AthleteAlreadyExistException - If the Athlete is already in the database
     */
    void addAthlete(Athlete athlete) throws AthleteAlreadyExistException, NullParameterException;


    /**
     * This method deletes a Athlete from the database.
     * @param athleteId - The Athlete identification id to find the Athlete to delete
     * @throws AthleteNotFoundException - If the Athlete is not in the database
     */
    void deleteAthlete(Long athleteId) throws AthleteNotFoundException;

    /**
     * This method updates a Athlete in the database.
     * @param athlete - The Athlete identification id to find the Athlete to update
     * @throws AthleteNotFoundException  - If the Athlete is not in the database
     */
    void updateAthlete(Athlete athlete) throws AthleteNotFoundException, NullParameterException;

    /**
     * This method gets a Athlete from the database
     * @param athleteId - the Athlete identification id to find the Athlete in the database
     * @return - The Athlete in the database
     * @throws AthleteNotFoundException - If the Athlete is not in the database
     */
    Athlete getAthleteById (Long athleteId) throws AthleteNotFoundException;

    /**
     * This method gets a Athlete from the database
     * @param name - the Athlete identification name to find the Athlete in the database
     * @return - The Athlete in the database
     * @throws AthleteNotFoundException - If the Athlete is not in the database
     */
    Athlete getAthleteByName (String name) throws AthleteNotFoundException;

    /**
     * This method gets a Athlete from the database
     * @param idDocument - the Athlete to find by idDocument in the database
     * @return - The Athlete in the database
     * @throws AthleteNotFoundException - If the Athlete is not in the database
     */
    Athlete getAthleteByIdDocument (String idDocument) throws AthleteNotFoundException;

    /**
     * Method that gets all the Athletes by institution
     * @param institutionName
     * @return all the Athletes of one institution
     */
    List<Athlete> getAllAthletesByInstitution(String institutionName);

    public List<Athlete> getAllAthletes();



}

