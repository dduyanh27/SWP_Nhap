package com.swp391.se2006.g2.vmfruit.dto.response;

import java.math.BigDecimal;
import java.time.LocalDate;

public class BatchItemResponse {
    private Integer batchItemId;
    private String productName;
    private BigDecimal importPrice;
    private BigDecimal remainingQuantity;
    private BigDecimal acceptedQuantity;
    private String unit;
    private LocalDate expiryDate;
    private long daysLeft;

    public BatchItemResponse() {
    }

    public BatchItemResponse(String unit, long daysLeft, LocalDate expiryDate, BigDecimal acceptedQuantity, BigDecimal remainingQuantity, BigDecimal importPrice, String productName, Integer batchItemId) {
        this.unit = unit;
        this.daysLeft = daysLeft;
        this.expiryDate = expiryDate;
        this.acceptedQuantity = acceptedQuantity;
        this.remainingQuantity = remainingQuantity;
        this.importPrice = importPrice;
        this.productName = productName;
        this.batchItemId = batchItemId;
    }

    public Integer getBatchItemId() { return batchItemId; }
    public void setBatchItemId(Integer batchItemId) { this.batchItemId = batchItemId; }
    public String getProductName() { return productName; }
    public void setProductName(String productName) { this.productName = productName; }
    public BigDecimal getImportPrice() { return importPrice; }
    public void setImportPrice(BigDecimal importPrice) { this.importPrice = importPrice; }
    public BigDecimal getRemainingQuantity() { return remainingQuantity; }
    public void setRemainingQuantity(BigDecimal remainingQuantity) { this.remainingQuantity = remainingQuantity; }
    public BigDecimal getAcceptedQuantity() { return acceptedQuantity; }
    public void setAcceptedQuantity(BigDecimal acceptedQuantity) { this.acceptedQuantity = acceptedQuantity; }
    public LocalDate getExpiryDate() { return expiryDate; }
    public void setExpiryDate(LocalDate expiryDate) { this.expiryDate = expiryDate; }
    public long getDaysLeft() { return daysLeft; }
    public void setDaysLeft(long daysLeft) { this.daysLeft = daysLeft; }
    public String getUnit() { return unit; }
    public void setUnit(String unit) { this.unit = unit; }
}