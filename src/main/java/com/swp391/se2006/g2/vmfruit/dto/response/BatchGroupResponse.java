package com.swp391.se2006.g2.vmfruit.dto.response;

import java.time.LocalDateTime;
import java.util.List;

public class BatchGroupResponse {
    private Integer batchId;
    private Integer importReceiptId;
    private String supplierName;
    private LocalDateTime receivedDate;
    private String batchStatus;
    private List<BatchItemResponse> batchItems;

    public BatchGroupResponse(Integer batchId, Integer importReceiptId, String supplierName,
                              LocalDateTime receivedDate, String batchStatus) {
        this.batchId = batchId;
        this.importReceiptId = importReceiptId;
        this.supplierName = supplierName;
        this.receivedDate = receivedDate;
        this.batchStatus = batchStatus;
    }

    public Integer getBatchId() { return batchId; }
    public Integer getImportReceiptId() { return importReceiptId; }
    public String getSupplierName() { return supplierName; }
    public LocalDateTime getReceivedDate() { return receivedDate; }
    public String getBatchStatus() { return batchStatus; }

    public List<BatchItemResponse> getBatchItems() { return batchItems; }
    public void setBatchItems(List<BatchItemResponse> batchItems) { this.batchItems = batchItems; }
}