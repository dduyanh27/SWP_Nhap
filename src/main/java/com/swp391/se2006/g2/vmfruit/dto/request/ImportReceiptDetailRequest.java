package com.swp391.se2006.g2.vmfruit.dto.request;



import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDate;

@Data
public class ImportReceiptDetailRequest {
    private Integer productId;
    private BigDecimal expectedQuantity;
    private BigDecimal importPrice;
    private LocalDate expectedExpiryDate;
    private String note;
    private String productName;
}