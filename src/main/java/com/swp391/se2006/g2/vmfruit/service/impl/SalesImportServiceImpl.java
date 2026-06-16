package com.swp391.se2006.g2.vmfruit.service.impl;

import com.swp391.se2006.g2.vmfruit.dto.response.ImportReceiptRowResponse;
import com.swp391.se2006.g2.vmfruit.service.AdminImportReceiptService;
import com.swp391.se2006.g2.vmfruit.service.SalesImportService;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
public class SalesImportServiceImpl implements SalesImportService {

    private final AdminImportReceiptService adminImportReceiptService;
    public SalesImportServiceImpl(AdminImportReceiptService adminImportReceiptService) {
        this.adminImportReceiptService = adminImportReceiptService;
    }

    @Override
    public List<ImportReceiptRowResponse> getPendingImportsForSales() {
        List<ImportReceiptRowResponse> allReceipts = adminImportReceiptService.getReceiptRows(null, "Latest");

        return allReceipts.stream()
                .filter(receipt -> "pending".equalsIgnoreCase(receipt.getStatusKey()))
                .collect(Collectors.toList());
    }

    @Override
    public long getPendingCount() {
        return adminImportReceiptService.getPendingCount();
    }
}