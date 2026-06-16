package com.swp391.se2006.g2.vmfruit.dto.response;

import java.math.BigDecimal;

public class OrderItemDTO {
    private String productName;
    private BigDecimal quantity; // Dùng BigDecimal (hoặc Integer tùy theo Entity của bạn)
    private BigDecimal unitPrice;
    private BigDecimal lineTotal;


    public OrderItemDTO(String productName, BigDecimal quantity, BigDecimal unitPrice) {
        this.productName = productName;
        this.quantity = quantity;
        this.unitPrice = unitPrice;

        if (quantity != null && unitPrice != null) {
            this.lineTotal = unitPrice.multiply(quantity);
        } else {
            this.lineTotal = BigDecimal.ZERO;
        }
    }

    public OrderItemDTO(String productName, BigDecimal quantity, BigDecimal unitPrice, BigDecimal lineTotal) {
        this.productName = productName;
        this.quantity = quantity;
        this.unitPrice = unitPrice;
        this.lineTotal = lineTotal;
    }


    public String getProductName() { return productName; }
    public BigDecimal getQuantity() { return quantity; }
    public BigDecimal getUnitPrice() { return unitPrice; }
    public BigDecimal getLineTotal() { return lineTotal; }
}