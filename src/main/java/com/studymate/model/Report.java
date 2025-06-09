package com.studymate.model;

import java.util.Date;

public class Report {
    private int reportId;
    private int reporterId;
    private int reportedPostId;
    private String reason;
    private Date createdAt;

    public Report() {}

    // getters và setters
    public int getReportId() { return reportId; }
    public void setReportId(int reportId) { this.reportId = reportId; }
    public int getReporterId() { return reporterId; }
    public void setReporterId(int reporterId) { this.reporterId = reporterId; }
    public int getReportedPostId() { return reportedPostId; }
    public void setReportedPostId(int reportedPostId) { this.reportedPostId = reportedPostId; }
    public String getReason() { return reason; }
    public void setReason(String reason) { this.reason = reason; }
    public Date getCreatedAt() { return createdAt; }
    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }
}
