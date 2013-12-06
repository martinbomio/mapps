package com.mapps.persistence;

import java.util.List;

import com.mapps.exceptions.NullParameterException;
import com.mapps.exceptions.SportAlreadyExistException;
import com.mapps.exceptions.SportNotFoundException;
import com.mapps.model.Sport;

import javax.ejb.Local;

/**
 * SportDAO interface
 */
@Local
public interface SportDAO {

    /**
     * This method adds a Sport to the database.
     * @param sport - The Permission to add to the database
     * @throws SportAlreadyExistException
     */
    void addSport(Sport sport) throws SportAlreadyExistException, NullParameterException;



    /**
     * This method deletes a Sport from the database.
     * @param sportId - The Sport identification id to find the Sport to delete
     * @throws SportNotFoundException - If the Sport is not in the database
     */
    void deleteSport(Long sportId) throws SportNotFoundException;

    /**
     * This method updates a Sport in the database.
     * @param sport - The Sport identification id to find the Sport to update
     * @throws SportNotFoundException  - If the sport is not in the database
     */
    void updateSport(Sport sport) throws SportNotFoundException, NullParameterException;

    /**
     * This method gets a Sport from the database
     * @param sportId - the Sport identification id to find the Sport in the database
     * @return - The Sport in the database
     * @throws SportNotFoundException - If the Sport is not in the database
     */
    Sport getSportById (Long sportId) throws SportNotFoundException;

    /**
     * Searches a sport for its name.
     * @param name name of the sport.
     * @return sport with name.
     * @throws SportNotFoundException thrown if the there is no sport with that name.
     */
    Sport getSportByName(String name) throws SportNotFoundException;

    /**
     * Returns all sport on the database
     * @return list of sports.
     */
    List<Sport> getAllSports();
}
