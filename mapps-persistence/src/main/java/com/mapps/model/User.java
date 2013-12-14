package com.mapps.model;

import java.util.Date;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Enumerated;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;

/**
 * Representation of the User of the system
 */
@Entity
@Table(name = "Users" )
public class User extends Person{
    @Id
    @GeneratedValue(strategy= GenerationType.IDENTITY)
    Long id;
    @Column(nullable = false, unique = true)
    private String userName;
    @Column(nullable = false)
    private String password;
    @Enumerated
    private Role role;
    private boolean enabled;

    public User() {
    }

    public User(String name, String lastName, Date birth, Gender gender,
                String email, String userName, String password, Institution institution, Role role,String idDocument){
        this.name = name;
        this.lastName = lastName;
        this.birth = birth;
        this.gender = gender;
        this.email = email;
        this.userName = userName;
        this.password = password;
        this.institution = institution;
        this.role = role;
        this.idDocument=idDocument;
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
        User other=  (User)obj;
        if(name.equals(other.name)&&lastName.equals(other.lastName)&&gender.equals(other.gender)&&
                email.equals(other.email)&&birth.equals(other.birth)&&userName.equals(other.userName)&&
                password.equals(other.password)&&institution.equals(other.institution)){
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

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public boolean isEnabled() {
        return enabled;
    }

    public void setEnabled(boolean enabled) {
        this.enabled = enabled;
    }

    public Role getRole() {
        return role;
    }

    public void setRole(Role role) {
        this.role = role;
    }
}
