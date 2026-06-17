package com.swp391.se2006.g2.vmfruit.dto.response;

import java.math.BigDecimal;
import java.time.LocalDate;

public class SalesImportProcessItemResponse {

    private Integer importDetailId;
    private String productName;
    private String unit;
    private BigDecimal expectedQuantity;
    private LocalDate expectedExpiryDate;
    private String expiryDateValue;

    public Integer getImportDetailId() {
        return importDetailId;
    }

    public void setImportDetailId(Integer importDetailId) {
        this.importDetailId = importDetailId;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public String getUnit() {
        return unit;
    }

    public void setUnit(String unit) {
        this.unit = unit;
    }

    public BigDecimal getExpectedQuantity() {
        return expectedQuantity;
    }

    public void setExpectedQuantity(BigDecimal expectedQuantity) {
        this.expectedQuantity = expectedQuantity;
    }

    public LocalDate getExpectedExpiryDate() {
        return expectedExpiryDate;
    }

    public void setExpectedExpiryDate(LocalDate expectedExpiryDate) {
        this.expectedExpiryDate = expectedExpiryDate;
        this.expiryDateValue = expectedExpiryDate != null ? expectedExpiryDate.toString() : "";
    }

    public String getExpiryDateValue() {
        return expiryDateValue;
    }

    public void setExpiryDateValue(String expiryDateValue) {
        this.expiryDateValue = expiryDateValue;
    }
}
