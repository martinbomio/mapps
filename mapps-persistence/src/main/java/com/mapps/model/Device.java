package com.mapps.model;


import javax.persistence.*;

/**
Representation of the device in the system
 */
@Entity
@Table(name = "Devices" )
public class Device {
    @Id
    @GeneratedValue(strategy= GenerationType.IDENTITY)
    Long id;
    @Column(nullable=false)
    private String dirHigh;
    @Column(nullable=false,unique = true)
    private String dirLow;
    private int panId;
    @ManyToOne
    private Institution institution;
    private boolean available;

    public Device(){

    }
    public Device(String dirHigh, String dirLow, int panId, Institution institution){
        this.institution = institution;
        this.dirHigh=dirHigh;
        this.dirLow=dirLow;
        this.panId=panId;
        this.available = true;
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
        Device other=  (Device)obj;
        if(dirHigh.equals(other.dirHigh)&&dirLow.equals(other.dirLow)&&panId==other.panId&&institution.equals(other.institution)){
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
    public String getDirHigh(){
        return dirHigh;
    }
    public void setDirHigh(String dirHigh){
        this.dirHigh=dirHigh;
    }
    public String getDirLow(){
        return dirLow;
    }
    public void setDirLow(String dirLow){
        this.dirLow=dirLow;
    }
    public int getPanId(){
        return panId;
    }
    public void setPanId(int panId){
        this.panId=panId;
    }

    public boolean isAvailable() {
        return available;
    }

    public void setAvailable(boolean available) {
        this.available = available;
    }

    public Institution getInstitution() {
        return institution;
    }

    public void setInstitution(Institution institution) {
        this.institution = institution;
    }
}
