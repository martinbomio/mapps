package com.mapps.model;

import java.util.Date;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.EnumType;
import javax.persistence.Enumerated;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;

/**
 * Represents a report in the model. Report can be for trainings or per athlete.
 */
@Entity
@Table(name = "Reports")
public class Report {
    @Id
    @GeneratedValue(strategy= GenerationType.IDENTITY)
    Long id;
    @Column(nullable = false)
    private String url;
    @Column(nullable = false)
    private Date createdDate;
    @Column(nullable=false,unique=true)
    private String name;
    @Enumerated(EnumType.ORDINAL)
    private ReportType reportType;

    public Report() {
    }

    public Report(Long id, String url, Date createdDate, String name, ReportType type) {
        this.id = id;
        this.url = url;
        this.createdDate = createdDate;
        this.name = name;
        this.reportType = type;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getUrl() {
        return url;
    }

    public void setUrl(String url) {
        this.url = url;
    }

    public Date getCreatedDate() {
        return createdDate;
    }

    public void setCreatedDate(Date createdDate) {
        this.createdDate = createdDate;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public ReportType getType() {
        return reportType;
    }

    public void setType(ReportType type) {
        this.reportType = type;
    }
}
