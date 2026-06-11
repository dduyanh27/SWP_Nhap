package com.swp391.se2006.g2.vmfruit.dto.request;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

public class ProductRequest {

    private Integer productId;

    private String productName;

    private String description;

    private String imageUrl;

    private String unit;

    private BigDecimal basePrice;

    private String origin;

    private String sellingStatus;       // ACTIVE | INACTIVE

    private List<Integer> categoryIds = new ArrayList<>();  // hỗ trợ nhiều danh mục

    // ── Getters & Setters ──────────────────────────────────────────────

    public Integer getProductId() { return productId; }
    public void setProductId(Integer productId) { this.productId = productId; }

    public String getProductName() { return productName; }
    public void setProductName(String productName) { this.productName = productName; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }

    public String getUnit() { return unit; }
    public void setUnit(String unit) { this.unit = unit; }

    public BigDecimal getBasePrice() { return basePrice; }
    public void setBasePrice(BigDecimal basePrice) { this.basePrice = basePrice; }

    public String getOrigin() { return origin; }
    public void setOrigin(String origin) { this.origin = origin; }

    public String getSellingStatus() { return sellingStatus; }
    public void setSellingStatus(String sellingStatus) { this.sellingStatus = sellingStatus; }

    public List<Integer> getCategoryIds() { return categoryIds; }
    public void setCategoryIds(List<Integer> categoryIds) {
        this.categoryIds = categoryIds != null ? categoryIds : new ArrayList<>();
    }
}
