package rr.beans;

public class HistoryRecord {
    private String applicationDate;
    private String applicationDesc;
    private String serviceAddress;
    private String jobDescription;

    public HistoryRecord(String applicationDate, String applicationDesc, String serviceAddress, String jobDescription) {
        this.applicationDate = applicationDate;
        this.applicationDesc = applicationDesc;
        this.serviceAddress = serviceAddress;
        this.jobDescription = jobDescription;
    }

    // Getters and setters
    public String getApplicationDate() {
        return applicationDate;
    }

    public void setApplicationDate(String applicationDate) {
        this.applicationDate = applicationDate;
    }

    public String getApplicationDesc() {
        return applicationDesc;
    }

    public void setApplicationDesc(String applicationDesc) {
        this.applicationDesc = applicationDesc;
    }

    public String getServiceAddress() {
        return serviceAddress;
    }

    public void setServiceAddress(String serviceAddress) {
        this.serviceAddress = serviceAddress;
    }

    public String getJobDescription() {
        return jobDescription;
    }

    public void setJobDescription(String jobDescription) {
        this.jobDescription = jobDescription;
    }
}

