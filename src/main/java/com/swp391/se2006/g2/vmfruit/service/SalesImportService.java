package com.swp391.se2006.g2.vmfruit.service;

import com.swp391.se2006.g2.vmfruit.dto.response.ImportReceiptRowResponse;
import java.util.List;

public interface SalesImportService {
    List<ImportReceiptRowResponse> getPendingImportsForSales();

    long getPendingCount();
}