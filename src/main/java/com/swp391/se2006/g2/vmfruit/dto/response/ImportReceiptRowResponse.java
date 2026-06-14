package com.swp391.se2006.g2.vmfruit.dto.response;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public class ImportReceiptRowResponse {

    private Integer importReceiptId;
    private String importIdDisplay;
    private String supplierName;
    private LocalDateTime createdDate;
    private String createdDateDisplay;
    private BigDecimal totalExpectedQuantity;
    private String dbStatus;
    private String statusKey;

    public ImportReceiptRowResponse(Integer importReceiptId, String supplierName, LocalDateTime createdDate,
            BigDecimal totalExpectedQuantity, String status) {
        this.importReceiptId = importReceiptId;
        this.supplierName = supplierName;
        this.createdDate = createdDate;
        this.totalExpectedQuantity = totalExpectedQuantity;
        this.dbStatus = status;
    }

    public Integer getImportReceiptId() {
        return importReceiptId;
    }

    public void setImportReceiptId(Integer importReceiptId) {
        this.importReceiptId = importReceiptId;
    }

    public String getImportIdDisplay() {
        return importIdDisplay;
    }

    public void setImportIdDisplay(String importIdDisplay) {
        this.importIdDisplay = importIdDisplay;
    }

    public String getSupplierName() {
        return supplierName;
    }

    public void setSupplierName(String supplierName) {
        this.supplierName = supplierName;
    }

    public LocalDateTime getCreatedDate() {
        return createdDate;
    }

    public void setCreatedDate(LocalDateTime createdDate) {
        this.createdDate = createdDate;
    }

    public String getCreatedDateDisplay() {
        return createdDateDisplay;
    }

    public void setCreatedDateDisplay(String createdDateDisplay) {
        this.createdDateDisplay = createdDateDisplay;
    }

    public BigDecimal getTotalExpectedQuantity() {
        return totalExpectedQuantity;
    }

    public void setTotalExpectedQuantity(BigDecimal totalExpectedQuantity) {
        this.totalExpectedQuantity = totalExpectedQuantity;
    }

    public String getStatusKey() {
        return statusKey;
    }

    public void setStatusKey(String statusKey) {
        this.statusKey = statusKey;
    }

    public String getDbStatus() {
        return dbStatus;
    }

    public void setDbStatus(String dbStatus) {
        this.dbStatus = dbStatus;
    }
}
