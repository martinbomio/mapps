package com.mapps.model;

import java.util.Date;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;


/**
 * Represents an Athlete in the model. Atheletes are the ones that wear the devices
 */
@Entity
@Table(name = "Athletes")
public class Athlete extends Person{
    @Id
    @GeneratedValue(strategy= GenerationType.IDENTITY)
    Long id;
    @Column(nullable = false)
    private double weight;
    @Column(nullable = false)
    private double height;
    private boolean enabled;

    public boolean isEnabled() {
        return enabled;
    }

    public void setEnabled(boolean enabled) {
        this.enabled = enabled;
    }

    public Athlete() {
    }

    public Athlete(String name, String lastName, Date birth, Gender gender,
                   String email,double weight, double height,String idDocument, Institution institution) {
        this.name = name;
        this.lastName = lastName;
        this.birth = birth;
        this.gender = gender;
        this.email = email;
        this.weight = weight;
        this.height = height;
        this.idDocument = idDocument;
        this.enabled=true;
        this.institution = institution;
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
        Athlete other=  (Athlete)obj;
        if(name.equals(other.name)&&lastName.equals(other.lastName)&&gender.equals(other.gender)&&
                email.equals(other.email)&&birth.equals(other.birth)&&(weight==other.weight)&&
                (height==other.height)&&idDocument.equals(idDocument)&&institution.equals(other.institution)){
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

    public double getWeight() {
        return weight;
    }

    public void setWeight(double weight) {
        this.weight = weight;
    }

    public double getHeight() {
        return height;
    }

    public void setHeight(double height) {
        this.height = height;
    }
}
