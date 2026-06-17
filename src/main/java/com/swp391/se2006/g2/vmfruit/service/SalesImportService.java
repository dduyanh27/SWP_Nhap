package com.swp391.se2006.g2.vmfruit.service;

import com.swp391.se2006.g2.vmfruit.dto.response.ImportReceiptRowResponse;
import com.swp391.se2006.g2.vmfruit.dto.response.SalesImportProcessResponse;
import com.swp391.se2006.g2.vmfruit.entity.User;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

public interface SalesImportService {
    List<ImportReceiptRowResponse> getPendingImportsForSales();

    long getPendingCount();

    Optional<SalesImportProcessResponse> getProcessPage(Integer receiptId);

    void confirmImportProcess(Integer receiptId,
                              List<Integer> importDetailIds,
                              List<BigDecimal> actualQuantities,
                              List<LocalDate> expiryDates,
                              String inspectionNote,
                              User receivedByUser);
}
