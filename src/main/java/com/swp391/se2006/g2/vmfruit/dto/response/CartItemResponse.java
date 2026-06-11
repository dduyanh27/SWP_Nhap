package com.swp391.se2006.g2.vmfruit.dto.response;
import java.math.BigDecimal;

public class CartItemResponse {
    private Integer cartItemId;
    private String productName;
    private BigDecimal quantity;
    private BigDecimal unitPrice;
    private BigDecimal subtotal;
    private String imageUrl;
    private String unit;
    public String getUnit(){return unit;}
    public void setUnit(String unit){this.unit=unit;}
    public String getImageUrl(){return imageUrl;}
    public void setImageUrl(String imageUrl){ this.imageUrl=imageUrl;}
    public Integer getCartItemId() { return cartItemId; }
    public void setCartItemId(Integer cartItemId) { this.cartItemId = cartItemId; }
    public String getProductName() { return productName; }
    public void setProductName(String productName) { this.productName = productName; }
    public BigDecimal getQuantity() { return quantity; }
    public void setQuantity(BigDecimal quantity) { this.quantity = quantity; }
    public BigDecimal getUnitPrice() { return unitPrice; }
    public void setUnitPrice(BigDecimal unitPrice) { this.unitPrice = unitPrice; }
    public BigDecimal getSubtotal() { return subtotal; }
    public void setSubtotal(BigDecimal subtotal) { this.subtotal = subtotal; }
}