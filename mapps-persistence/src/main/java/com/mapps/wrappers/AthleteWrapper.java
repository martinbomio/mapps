package com.mapps.wrappers;

import java.util.Date;

import org.joda.time.LocalDate;
import org.joda.time.Years;

import com.mapps.model.Athlete;
import com.mapps.model.Gender;

/**
 * Wrappes the information of the Athlete.
 */
public class AthleteWrapper {
    private String name;
    private int age;
    private double weight;
    private double height;
    private Gender gender;

    public AthleteWrapper(String name, int age, double weight, double height, Gender gender) {
        this.name = name;
        this.age = age;
        this.weight = weight;
        this.height = height;
        this.gender = gender;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public int getAge() {
        return age;
    }

    public void setAge(int age) {
        this.age = age;
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

    public Gender getGender() {
        return gender;
    }

    public void setGender(Gender gender) {
        this.gender = gender;
    }

    public static class Builder{
        private Athlete athlete;

        public Builder setAthlete(Athlete athlete){
            this.athlete = athlete;
            return this;
        }

        public AthleteWrapper build(){
            return new AthleteWrapper(athlete.getName(), getAge(athlete.getBirth()), athlete.getHeight(),
                                      athlete.getWeight(),athlete.getGender());
        }

        private int getAge(Date birth){
            LocalDate birthdate = new LocalDate (birth);
            LocalDate now = new LocalDate();
            Years age = Years.yearsBetween(birthdate, now);
            return age.getYears();
        }
    }
}
