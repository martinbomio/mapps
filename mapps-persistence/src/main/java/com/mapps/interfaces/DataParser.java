package com.mapps.interfaces;

/**
 * Interface that defines operation of populating objects depending on what
 * they represent. Is the component of a likewise Decorator Pattern
 */
public interface DataParser {
    /**
     * method that populates the object with data depending on which objects call the populate
     * @param data character chain that contains the data without parsing
     */
    void populate(String data);
}
