package com.swp391.se2006.g2.vmfruit.dto.response;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

public class ImportReceiptRowResponse {

    private Integer importReceiptId;
    private String importIdDisplay;
    private String supplierName;
    private LocalDateTime createdDate;
    private String createdDateDisplay;
    private BigDecimal unitCost;
    private Integer totalExpectedQuantity;
    private String dbStatus;
    private String statusKey;

    private static final DateTimeFormatter DATE_FORMATTER =
            DateTimeFormatter.ofPattern("dd/MM/yyyy");

    public ImportReceiptRowResponse(Integer importReceiptId, String supplierName,
                                    LocalDateTime createdDate, BigDecimal unitCost,
                                    String status) {
        this.importReceiptId = importReceiptId;
        this.supplierName = supplierName;
        this.createdDate = createdDate;
        this.unitCost = unitCost;
        this.dbStatus = status;

        this.importIdDisplay = String.format("PO%03d", importReceiptId);
        this.createdDateDisplay = (createdDate != null)
                ? createdDate.format(DATE_FORMATTER) : "";
        this.statusKey = mapStatusKey(status);
    }

    private String mapStatusKey(String status) {
        if (status == null) return "UNKNOWN";
        return switch (status.toUpperCase()) {
            case "DRAFT"     -> "DRAFT";
            case "PENDING"   -> "PENDING";
            case "RECEIVED"  -> "RECEIVED";
            case "CANCELLED" -> "CANCELLED";
            default          -> "UNKNOWN";
        };
    }


    public Integer getImportReceiptId() { return importReceiptId; }
    public void setImportReceiptId(Integer importReceiptId) {
        this.importReceiptId = importReceiptId;
        this.importIdDisplay = String.format("PO%03d", importReceiptId);
    }

    public String getImportIdDisplay() { return importIdDisplay; }
    public void setImportIdDisplay(String importIdDisplay) {
        this.importIdDisplay = importIdDisplay;
    }

    public String getSupplierName() { return supplierName; }
    public void setSupplierName(String supplierName) {
        this.supplierName = supplierName;
    }

    public LocalDateTime getCreatedDate() { return createdDate; }
    public void setCreatedDate(LocalDateTime createdDate) {
        this.createdDate = createdDate;
        this.createdDateDisplay = (createdDate != null)
                ? createdDate.format(DATE_FORMATTER) : "";
    }

    public String getCreatedDateDisplay() { return createdDateDisplay; }
    public void setCreatedDateDisplay(String createdDateDisplay) {
        this.createdDateDisplay = createdDateDisplay;
    }

    public BigDecimal getUnitCost() { return unitCost; }
    public void setUnitCost(BigDecimal unitCost) { this.unitCost = unitCost; }

    public Integer getTotalExpectedQuantity() { return totalExpectedQuantity; }
    public void setTotalExpectedQuantity(Integer totalExpectedQuantity) {
        this.totalExpectedQuantity = totalExpectedQuantity;
    }

    public String getDbStatus() { return dbStatus; }
    public void setDbStatus(String dbStatus) {
        this.dbStatus = dbStatus;
        this.statusKey = mapStatusKey(dbStatus);
    }

    public String getStatusKey() { return statusKey; }
    public void setStatusKey(String statusKey) { this.statusKey = statusKey; }
}