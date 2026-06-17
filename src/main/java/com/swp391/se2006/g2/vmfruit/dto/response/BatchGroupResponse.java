package com.swp391.se2006.g2.vmfruit.dto.response;

import java.time.LocalDateTime;
import java.util.List;

public class BatchGroupResponse {
    private Integer batchId;
    private String poCode;
    private String supplierName;
    private LocalDateTime receivedDate;
    private String batchStatus;
    private List<BatchItemResponse> batchItems;

    public BatchGroupResponse() {
    }

    public BatchGroupResponse(Integer batchId, String poCode, String supplierName, LocalDateTime receivedDate, String batchStatus, List<BatchItemResponse> batchItems) {
        this.batchId = batchId;
        this.poCode = poCode;
        this.supplierName = supplierName;
        this.receivedDate = receivedDate;
        this.batchStatus = batchStatus;
        this.batchItems = batchItems;
    }

    public Integer getBatchId() { return batchId; }
    public void setBatchId(Integer batchId) { this.batchId = batchId; }
    public String getPoCode() { return poCode; }
    public void setPoCode(String poCode) { this.poCode = poCode; }
    public String getSupplierName() { return supplierName; }
    public void setSupplierName(String supplierName) { this.supplierName = supplierName; }
    public LocalDateTime getReceivedDate() { return receivedDate; }
    public void setReceivedDate(LocalDateTime receivedDate) { this.receivedDate = receivedDate; }
    public String getBatchStatus() { return batchStatus; }
    public void setBatchStatus(String batchStatus) { this.batchStatus = batchStatus; }
    public List<BatchItemResponse> getBatchItems() { return batchItems; }
    public void setBatchItems(List<BatchItemResponse> batchItems) { this.batchItems = batchItems; }
}