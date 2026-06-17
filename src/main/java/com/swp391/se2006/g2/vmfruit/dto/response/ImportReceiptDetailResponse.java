package com.swp391.se2006.g2.vmfruit.dto.response;


import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDate;

@Data
public class ImportReceiptDetailResponse {
    private Integer importDetailId;
    private Integer productId;
    private String productName;
    private String productUnit;
    private BigDecimal expectedQuantity;
    private BigDecimal importPrice;
    private BigDecimal subtotalValue;
    private LocalDate expectedExpiryDate;
    private String note;
    public ImportReceiptDetailResponse() {}

    public ImportReceiptDetailResponse(Integer importDetailId, Integer productId,
                                       String productName, String productUnit, BigDecimal expectedQuantity,
                                       BigDecimal importPrice, LocalDate expectedExpiryDate, String note) {
        this.importDetailId = importDetailId;
        this.productId = productId;
        this.productName = productName;
        this.productUnit = productUnit;
        this.expectedQuantity = expectedQuantity;
        this.importPrice = importPrice;
        this.subtotalValue = (expectedQuantity != null && importPrice != null)
                ? expectedQuantity.multiply(importPrice) : BigDecimal.ZERO;
        this.expectedExpiryDate = expectedExpiryDate;
        this.note = note;
    }


    public Integer getImportDetailId() { return importDetailId; }
    public void setImportDetailId(Integer importDetailId) {
        this.importDetailId = importDetailId;
    }

    public Integer getProductId() { return productId; }
    public void setProductId(Integer productId) { this.productId = productId; }

    public String getProductName() { return productName; }
    public void setProductName(String productName) { this.productName = productName; }

    public String getProductUnit() { return productUnit; }
    public void setProductUnit(String productUnit) { this.productUnit = productUnit; }

    public BigDecimal getExpectedQuantity() { return expectedQuantity; }
    public void setExpectedQuantity(BigDecimal expectedQuantity) {
        this.expectedQuantity = expectedQuantity;
        recalcSubtotal();
    }

    public BigDecimal getImportPrice() { return importPrice; }
    public void setImportPrice(BigDecimal importPrice) {
        this.importPrice = importPrice;
        recalcSubtotal();
    }

    public BigDecimal getSubtotalValue() { return subtotalValue; }
    public void setSubtotalValue(BigDecimal subtotalValue) {
        this.subtotalValue = subtotalValue;
    }

    public LocalDate getExpectedExpiryDate() { return expectedExpiryDate; }
    public void setExpectedExpiryDate(LocalDate expectedExpiryDate) {
        this.expectedExpiryDate = expectedExpiryDate;
    }

    public String getNote() { return note; }
    public void setNote(String note) { this.note = note; }

    // Auto recalc subtotal khi set quantity hoặc price
    private void recalcSubtotal() {
        if (this.expectedQuantity != null && this.importPrice != null) {
            this.subtotalValue = this.expectedQuantity.multiply(this.importPrice);
        }
    }
}