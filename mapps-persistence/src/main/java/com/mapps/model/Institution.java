package com.mapps.model;

import java.net.URI;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;

/**
 * Representation of the Institution of the system
 */
@Entity
@Table(name = "Institutions" )
public class Institution {
    @Id
    @GeneratedValue(strategy= GenerationType.IDENTITY)
    Long id;
    @Column(nullable=false)
    private String name;
    @Column(length = 10000)
    private String description;
    @Column(nullable=false)
    private String country;
    private boolean enabled;
    private URI imageURI;

    public Institution(){

    }
    public Institution(String name, String description, String country){
        this.name = name;
        this.description = description;
        this.country = country;
        this.enabled = true;
    }

    @Override
    public boolean equals(Object obj){
        boolean aux=false;
        if(obj==this){
            aux=true;
            return aux;
        }
        if(obj==null || obj.getClass()!=this.getClass()){
            return aux;
        }
        Institution other=  (Institution)obj;
        if(name.equals(other.name)&&description.equals(other.description)&&country.equals(other.country)){
            aux=true;
            return aux;
        }
        return aux;
    }

    public Long getId() {
        return id;
    }


    public void setId(Long id) {
        this.id = id;
    }
    public String getName(){
        return name;
    }
    public void setName(String name){
          this.name=name;
    }
    public String getDescription(){
        return description;
    }
    public void setDescription(String description){
        this.description=description;
    }

    public String getCountry() {
        return country;
    }

    public void setCountry(String country) {
        this.country = country;
    }

    public boolean isEnabled() {
        return enabled;
    }

    public void setEnabled(boolean enabled) {
        this.enabled = enabled;
    }

    public URI getImageURI() {
        return imageURI;
    }

    public void setImageURI(URI imageURI) {
        this.imageURI = imageURI;
    }
}
