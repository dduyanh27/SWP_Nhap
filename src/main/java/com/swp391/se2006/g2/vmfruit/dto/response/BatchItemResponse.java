package com.swp391.se2006.g2.vmfruit.dto.response;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;

public class BatchItemResponse {
    private Integer batchItemId;
    private String productName;
    private String unit;
    private BigDecimal importPrice;
    private BigDecimal remainingQuantity;
    private BigDecimal acceptedQuantity;
    private LocalDate expiryDate;
    private String itemStatus;
    private long daysLeft;

    public BatchItemResponse(Integer batchItemId, String productName, String unit, BigDecimal importPrice,
                             BigDecimal remainingQuantity, BigDecimal acceptedQuantity, LocalDate expiryDate, String itemStatus) {
        this.batchItemId = batchItemId;
        this.productName = productName;
        this.unit = unit;
        this.importPrice = importPrice;
        this.remainingQuantity = remainingQuantity;
        this.acceptedQuantity = acceptedQuantity;
        this.expiryDate = expiryDate;
        this.itemStatus = itemStatus;
        if (expiryDate != null) {
            this.daysLeft = ChronoUnit.DAYS.between(LocalDate.now(), expiryDate);
        }
    }

    public Integer getBatchItemId() { return batchItemId; }
    public String getProductName() { return productName; }
    public String getUnit() { return unit; }
    public BigDecimal getImportPrice() { return importPrice; }
    public BigDecimal getRemainingQuantity() { return remainingQuantity; }
    public BigDecimal getAcceptedQuantity() { return acceptedQuantity; }
    public LocalDate getExpiryDate() { return expiryDate; }
    public String getItemStatus() { return itemStatus; }
    public long getDaysLeft() { return daysLeft; }
}