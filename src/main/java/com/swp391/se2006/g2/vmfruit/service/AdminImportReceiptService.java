package com.swp391.se2006.g2.vmfruit.service;

import com.swp391.se2006.g2.vmfruit.dto.response.ImportReceiptRowResponse;
import com.swp391.se2006.g2.vmfruit.entity.Supplier;
import org.springframework.beans.factory.annotation.Autowired;

import java.math.BigDecimal;
import java.util.List;

public interface AdminImportReceiptService {

    long getTotalCount();

    long getPendingCount();

    long getReceivedCount();

    BigDecimal getTotalQuantity();

    List<Supplier> getActiveSuppliers();

    List<ImportReceiptRowResponse> getReceiptRows(Integer supplierId, String sortDate);


}
