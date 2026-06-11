package com.swp391.se2006.g2.vmfruit.dto.response;

import java.math.BigDecimal;

public class ProductRowResponse {
    private Integer productId;
    private String productName;
    private String imageUrl;
    private BigDecimal basePrice;
    private String unit;
    private BigDecimal stock;
    private String sellingStatus;

    public ProductRowResponse(Integer productId, String productName, String imageUrl,
                              BigDecimal basePrice, String unit, BigDecimal stock, String sellingStatus) {
        this.productId = productId;
        this.productName = productName;
        this.imageUrl = imageUrl;
        this.basePrice = basePrice != null ? basePrice : BigDecimal.ZERO;
        this.unit = unit;
        // SUM trả về null khi không có lô nào → mặc định 0
        this.stock = stock != null ? stock : BigDecimal.ZERO;
        this.sellingStatus = sellingStatus;
    }

    public Integer getProductId() { return productId; }
    public String getProductName() { return productName; }
    public String getImageUrl() { return imageUrl; }
    public BigDecimal getBasePrice() { return basePrice; }
    public String getUnit() { return unit; }
    public BigDecimal getStock() { return stock; }
    public String getStatus() { return sellingStatus; }
}
