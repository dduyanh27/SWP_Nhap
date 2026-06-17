package com.swp391.se2006.g2.vmfruit.dto.request;
import lombok.Data;
import java.time.LocalDate;
import java.util.List;

@Data
public class ImportReceiptRequest {
    private Integer supplierId;
    private LocalDate expectedDeliveryDate;
    private String note;
    private List<ImportReceiptDetailRequest> details;
}