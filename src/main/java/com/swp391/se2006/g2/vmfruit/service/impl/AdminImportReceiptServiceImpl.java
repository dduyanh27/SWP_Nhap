package com.swp391.se2006.g2.vmfruit.service.impl;

import com.swp391.se2006.g2.vmfruit.dto.response.ImportReceiptRowResponse;
import com.swp391.se2006.g2.vmfruit.entity.ImportReceipt;
import com.swp391.se2006.g2.vmfruit.entity.Supplier;
import com.swp391.se2006.g2.vmfruit.repository.ImportReceiptDetailRepository;
import com.swp391.se2006.g2.vmfruit.repository.ImportReceiptRepository;
import com.swp391.se2006.g2.vmfruit.repository.InboundBatchRepository;
import com.swp391.se2006.g2.vmfruit.repository.SupplierRepository;
import com.swp391.se2006.g2.vmfruit.service.AdminImportReceiptService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.format.DateTimeFormatter;
import java.util.Comparator;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;

@Service
public class AdminImportReceiptServiceImpl implements AdminImportReceiptService {

    private static final String STATUS_RECEIVED = "RECEIVED";
    private static final String STATUS_CANCELLED = "CANCELLED";
    private static final DateTimeFormatter DATE_DISPLAY = DateTimeFormatter.ofPattern("dd/MM/yyyy");

    private final ImportReceiptRepository importReceiptRepository;
    private final ImportReceiptDetailRepository importReceiptDetailRepository;
    private final InboundBatchRepository inboundBatchRepository;
    private final SupplierRepository supplierRepository;

    public AdminImportReceiptServiceImpl(ImportReceiptRepository importReceiptRepository,
            ImportReceiptDetailRepository importReceiptDetailRepository,
            InboundBatchRepository inboundBatchRepository,
            SupplierRepository supplierRepository) {
        this.importReceiptRepository = importReceiptRepository;
        this.importReceiptDetailRepository = importReceiptDetailRepository;
        this.inboundBatchRepository = inboundBatchRepository;
        this.supplierRepository = supplierRepository;
    }

    @Override
    @Transactional(readOnly = true)
    public long getTotalCount() {
        return importReceiptRepository.count();
    }

    @Override
    @Transactional(readOnly = true)
    public long getPendingCount() {
        Set<Integer> receivedIds = getReceivedReceiptIds();
        return importReceiptRepository.findAll().stream()
                .filter(ir -> !receivedIds.contains(ir.getImportReceiptId()))
                .filter(ir -> !STATUS_CANCELLED.equalsIgnoreCase(ir.getStatus()))
                .filter(ir -> !STATUS_RECEIVED.equalsIgnoreCase(ir.getStatus()))
                .count();
    }

    @Override
    @Transactional(readOnly = true)
    public long getReceivedCount() {
        Set<Integer> receivedIds = getReceivedReceiptIds();
        return importReceiptRepository.findAll().stream()
                .filter(ir -> receivedIds.contains(ir.getImportReceiptId())
                        || STATUS_RECEIVED.equalsIgnoreCase(ir.getStatus()))
                .count();
    }

    @Override
    @Transactional(readOnly = true)
    public BigDecimal getTotalQuantity() {
        BigDecimal total = importReceiptDetailRepository.sumTotalExpectedQuantity();
        return total != null ? total : BigDecimal.ZERO;
    }

    @Override
    @Transactional(readOnly = true)
    public List<Supplier> getActiveSuppliers() {
        return supplierRepository.findByStatusOrderBySupplierNameAsc("ACTIVE");
    }

    @Override
    @Transactional(readOnly = true)
    public List<ImportReceiptRowResponse> getReceiptRows(Integer supplierId, String sortDate) {
        Set<Integer> receivedIds = getReceivedReceiptIds();
        Map<Integer, BigDecimal> quantityByReceipt = loadQuantityByReceipt();

        List<ImportReceiptRowResponse> rows = importReceiptRepository.findAllWithSupplier(supplierId).stream()
                .map(ir -> toRow(ir, quantityByReceipt.getOrDefault(ir.getImportReceiptId(), BigDecimal.ZERO), receivedIds))
                .collect(Collectors.toList());

        Comparator<ImportReceiptRowResponse> byDate = Comparator.comparing(
                ImportReceiptRowResponse::getCreatedDate,
                Comparator.nullsLast(Comparator.naturalOrder()));

        if ("oldest".equalsIgnoreCase(sortDate)) {
            rows.sort(byDate);
        } else {
            rows.sort(byDate.reversed());
        }

        return rows;
    }

    private Map<Integer, BigDecimal> loadQuantityByReceipt() {
        Map<Integer, BigDecimal> map = new HashMap<>();
        for (Object[] row : importReceiptDetailRepository.sumQuantityByReceipt()) {
            map.put((Integer) row[0], toBigDecimal(row[1]));
        }
        return map;
    }

    private ImportReceiptRowResponse toRow(ImportReceipt receipt, BigDecimal totalQty, Set<Integer> receivedIds) {
        ImportReceiptRowResponse row = new ImportReceiptRowResponse(
                receipt.getImportReceiptId(),
                receipt.getSupplier().getSupplierName(),
                receipt.getCreatedDate(),
                totalQty,
                receipt.getStatus());

        row.setImportIdDisplay(String.format("PO%03d", receipt.getImportReceiptId()));
        if (receipt.getCreatedDate() != null) {
            row.setCreatedDateDisplay(receipt.getCreatedDate().format(DATE_DISPLAY));
        }
        row.setStatusKey(resolveStatusKey(receipt.getStatus(), receivedIds.contains(receipt.getImportReceiptId())));
        return row;
    }

    private Set<Integer> getReceivedReceiptIds() {
        return new HashSet<>(inboundBatchRepository.findAllImportReceiptIds());
    }

    private static String resolveStatusKey(String dbStatus, boolean hasInboundBatch) {
        if (hasInboundBatch || STATUS_RECEIVED.equalsIgnoreCase(dbStatus)) {
            return "received";
        }
        if (STATUS_CANCELLED.equalsIgnoreCase(dbStatus)) {
            return "cancelled";
        }
        return "pending";
    }

    private static BigDecimal toBigDecimal(Object value) {
        if (value == null) {
            return BigDecimal.ZERO;
        }
        if (value instanceof BigDecimal decimal) {
            return decimal;
        }
        if (value instanceof Number number) {
            return BigDecimal.valueOf(number.doubleValue());
        }
        return BigDecimal.ZERO;
    }
}
