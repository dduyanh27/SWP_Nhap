package com.swp391.se2006.g2.vmfruit.dto.response;

import java.math.BigDecimal;

public class ProductRowResponse {
    private Integer productId;
    private String productName;
    private String imageUrl;
    private String categoryName;
    private BigDecimal price;
    private String unit;
    private BigDecimal stock;
    private String status;

    // CONSTRUCTOR BẮT BUỘC: Thứ tự tham số phải chuẩn đét để Spring Data JPA mapping từ câu Query
    public ProductRowResponse(Integer productId, String productName, String imageUrl, String categoryName,
                              BigDecimal price, String unit, BigDecimal stock, String status) {
        this.productId = productId;
        this.productName = productName;
        this.imageUrl = imageUrl;
        // MIN(categoryName) trả về null khi sản phẩm chưa có danh mục nào
        this.categoryName = (categoryName != null) ? categoryName : "";
        this.price = price;
        this.unit = unit;
        // SUM(remainingQuantity) trả về null khi sản phẩm chưa có lô hàng nào
        this.stock = (stock != null) ? stock : BigDecimal.ZERO;
        this.status = status;
    }

    // Toàn bộ Getter và Setter thuần túy (Không dùng Lombok)
    public Integer getProductId() { return productId; }
    public void setProductId(Integer productId) { this.productId = productId; }

    public String getProductName() { return productName; }
    public void setProductName(String productName) { this.productName = productName; }

    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }

    public String getCategoryName() { return categoryName; }
    public void setCategoryName(String categoryName) { this.categoryName = categoryName; }

    public BigDecimal getPrice() { return price; }
    public void setPrice(BigDecimal price) { this.price = price; }

    public String getUnit() { return unit; }
    public void setUnit(String unit) { this.unit = unit; }

    public BigDecimal getStock() { return stock; }
    public void setStock(BigDecimal stock) { this.stock = stock; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
}