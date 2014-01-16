package com.mapps.model;

import java.util.Date;
import javax.persistence.*;

import org.hibernate.validator.constraints.Email;

/**
 * Representation of a person to the system. Abstraction for reuse.
 */
@MappedSuperclass
public abstract class Person{
    protected String name;
    protected String lastName;
    @Temporal(TemporalType.DATE)
    protected Date birth;
    @Enumerated
    protected Gender gender;
    @Email
    protected String email;
    @Column(nullable = false)
    protected String idDocument;
    @ManyToOne
    protected Institution institution;

    public String getIdDocument() {
        return idDocument;
    }

    public void setIdDocument(String idDocument) {
        this.idDocument = idDocument;
    }



    public Institution getInstitution() {
        return institution;
    }

    public void setInstitution(Institution institution) {
        this.institution = institution;
    }



    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getLastName() {
        return lastName;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
    }

    public Date getBirth() {
        return birth;
    }

    public void setBirth(Date birth) {
        this.birth = birth;
    }

    public Gender getGender() {
        return gender;
    }

    public void setGender(Gender gender) {
        this.gender = gender;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }
}
