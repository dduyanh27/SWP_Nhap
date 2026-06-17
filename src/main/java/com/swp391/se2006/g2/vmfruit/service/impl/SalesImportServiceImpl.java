package com.swp391.se2006.g2.vmfruit.service.impl;

import com.swp391.se2006.g2.vmfruit.dto.response.ImportReceiptRowResponse;
import com.swp391.se2006.g2.vmfruit.dto.response.SalesImportProcessItemResponse;
import com.swp391.se2006.g2.vmfruit.dto.response.SalesImportProcessResponse;
import com.swp391.se2006.g2.vmfruit.entity.ImportReceipt;
import com.swp391.se2006.g2.vmfruit.entity.ImportReceiptDetail;
import com.swp391.se2006.g2.vmfruit.entity.InboundBatch;
import com.swp391.se2006.g2.vmfruit.entity.InboundBatchItem;
import com.swp391.se2006.g2.vmfruit.entity.User;
import com.swp391.se2006.g2.vmfruit.entity.Wastage;
import com.swp391.se2006.g2.vmfruit.repository.ImportReceiptDetailRepository;
import com.swp391.se2006.g2.vmfruit.repository.ImportReceiptRepository;
import com.swp391.se2006.g2.vmfruit.repository.InboundBatchItemsRepository;
import com.swp391.se2006.g2.vmfruit.repository.InboundBatchRepository;
import com.swp391.se2006.g2.vmfruit.service.AdminImportReceiptService;
import com.swp391.se2006.g2.vmfruit.service.SalesImportService;
import jakarta.persistence.EntityManager;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
public class SalesImportServiceImpl implements SalesImportService {

    private static final String STATUS_CANCELLED = "CANCELLED";
    private static final String STATUS_RECEIVED = "RECEIVED";
    private static final DateTimeFormatter DATE_DISPLAY = DateTimeFormatter.ofPattern("dd/MM/yyyy");

    private final AdminImportReceiptService adminImportReceiptService;
    private final ImportReceiptRepository importReceiptRepository;
    private final ImportReceiptDetailRepository importReceiptDetailRepository;
    private final InboundBatchRepository inboundBatchRepository;
    private final InboundBatchItemsRepository inboundBatchItemsRepository;
    private final EntityManager entityManager;

    public SalesImportServiceImpl(AdminImportReceiptService adminImportReceiptService,
                                  ImportReceiptRepository importReceiptRepository,
                                  ImportReceiptDetailRepository importReceiptDetailRepository,
                                  InboundBatchRepository inboundBatchRepository,
                                  InboundBatchItemsRepository inboundBatchItemsRepository,
                                  EntityManager entityManager) {
        this.adminImportReceiptService = adminImportReceiptService;
        this.importReceiptRepository = importReceiptRepository;
        this.importReceiptDetailRepository = importReceiptDetailRepository;
        this.inboundBatchRepository = inboundBatchRepository;
        this.inboundBatchItemsRepository = inboundBatchItemsRepository;
        this.entityManager = entityManager;
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

    @Override
    @Transactional(readOnly = true)
    public Optional<SalesImportProcessResponse> getProcessPage(Integer receiptId) {
        return importReceiptRepository.findById(receiptId)
                .filter(this::isPendingReceipt)
                .map(this::toProcessResponse);
    }

    @Override
    @Transactional
    public void confirmImportProcess(Integer receiptId,
                                     List<Integer> importDetailIds,
                                     List<BigDecimal> actualQuantities,
                                     List<LocalDate> expiryDates,
                                     String inspectionNote,
                                     User receivedByUser) {
        if (receivedByUser == null) {
            throw new IllegalArgumentException("Missing sales user.");
        }
        if (importDetailIds == null || actualQuantities == null || expiryDates == null
                || importDetailIds.isEmpty()
                || importDetailIds.size() != actualQuantities.size()
                || importDetailIds.size() != expiryDates.size()) {
            throw new IllegalArgumentException("Invalid import inspection data.");
        }

        ImportReceipt receipt = importReceiptRepository.findById(receiptId)
                .orElseThrow(() -> new IllegalArgumentException("Import receipt not found."));
        if (!isPendingReceipt(receipt)) {
            throw new IllegalStateException("Import receipt is not pending.");
        }
        User managedReceivedByUser = entityManager.getReference(User.class, receivedByUser.getUserId());

        Map<Integer, ImportReceiptDetail> detailsById = importReceiptDetailRepository
                .findByReceiptIdWithProduct(receiptId)
                .stream()
                .collect(Collectors.toMap(ImportReceiptDetail::getImportDetailId, detail -> detail));

        InboundBatch batch = new InboundBatch();
        batch.setImportReceipt(receipt);
        batch.setReceivedByUser(managedReceivedByUser);
        batch.setReceivedDate(LocalDateTime.now());
        batch.setBatchStatus("ACTIVE");
        batch.setNote(truncate(inspectionNote, 255));
        batch = inboundBatchRepository.save(batch);

        LocalDateTime now = LocalDateTime.now();
        for (int i = 0; i < importDetailIds.size(); i++) {
            Integer detailId = importDetailIds.get(i);
            ImportReceiptDetail detail = detailsById.get(detailId);
            if (detail == null) {
                throw new IllegalArgumentException("Import detail does not belong to this receipt.");
            }

            BigDecimal actualAccepted = normalizeQuantity(actualQuantities.get(i));
            BigDecimal expectedQuantity = normalizeQuantity(detail.getExpectedQuantity());
            BigDecimal lossQuantity = expectedQuantity.subtract(actualAccepted);
            if (lossQuantity.signum() < 0) {
                lossQuantity = BigDecimal.ZERO;
            }

            InboundBatchItem batchItem = new InboundBatchItem();
            batchItem.setBatch(batch);
            batchItem.setImportDetail(detail);
            batchItem.setProduct(detail.getProduct());
            batchItem.setActualQuantity(actualAccepted.add(lossQuantity));
            batchItem.setAcceptedQuantity(actualAccepted);
            batchItem.setDamagedQuantity(lossQuantity);
            batchItem.setRemainingQuantity(actualAccepted);
            batchItem.setExpiryDate(expiryDates.get(i));
            batchItem.setQualityStatus(lossQuantity.signum() > 0 ? "CHECKED" : "FRESH");
            batchItem.setItemStatus("ACTIVE");
            batchItem.setCreatedAt(now);
            batchItem = inboundBatchItemsRepository.save(batchItem);

            if (lossQuantity.signum() > 0) {
                Wastage wastage = new Wastage();
                wastage.setBatchItem(batchItem);
                wastage.setProduct(detail.getProduct());
                wastage.setQuantity(lossQuantity);
                wastage.setReason("IMPORT_LOSS");
                wastage.setCreatedByUser(managedReceivedByUser);
                wastage.setCreatedAt(now);
                wastage.setNote(truncate(inspectionNote, 255));
                entityManager.persist(wastage);
            }
        }

        receipt.setStatus(STATUS_RECEIVED);
        importReceiptRepository.save(receipt);
    }

    private SalesImportProcessResponse toProcessResponse(ImportReceipt receipt) {
        List<SalesImportProcessItemResponse> items = importReceiptDetailRepository
                .findByReceiptIdWithProduct(receipt.getImportReceiptId())
                .stream()
                .map(this::toProcessItem)
                .collect(Collectors.toList());

        SalesImportProcessResponse response = new SalesImportProcessResponse();
        response.setImportReceiptId(receipt.getImportReceiptId());
        response.setImportIdDisplay(String.format("#PO%03d", receipt.getImportReceiptId()));
        response.setSupplierName(receipt.getSupplier().getSupplierName());
        response.setCreatedDateDisplay(receipt.getCreatedDate() != null ? receipt.getCreatedDate().format(DATE_DISPLAY) : "");
        response.setTotalExpectedVarieties(items.size());
        response.setItems(items);
        return response;
    }

    private SalesImportProcessItemResponse toProcessItem(ImportReceiptDetail detail) {
        SalesImportProcessItemResponse item = new SalesImportProcessItemResponse();
        item.setImportDetailId(detail.getImportDetailId());
        item.setProductName(detail.getProduct().getProductName());
        item.setUnit(detail.getProduct().getUnit());
        item.setExpectedQuantity(detail.getExpectedQuantity());
        item.setExpectedExpiryDate(detail.getExpectedExpiryDate());
        return item;
    }

    private boolean isPendingReceipt(ImportReceipt receipt) {
        boolean hasInboundBatch = inboundBatchRepository.findAllImportReceiptIds().contains(receipt.getImportReceiptId());
        return !hasInboundBatch
                && !STATUS_RECEIVED.equalsIgnoreCase(receipt.getStatus())
                && !STATUS_CANCELLED.equalsIgnoreCase(receipt.getStatus());
    }

    private static BigDecimal normalizeQuantity(BigDecimal value) {
        if (value == null || value.signum() < 0) {
            return BigDecimal.ZERO;
        }
        return value;
    }

    private static String truncate(String value, int maxLength) {
        if (value == null || value.isBlank()) {
            return null;
        }
        String trimmed = value.trim();
        return trimmed.length() <= maxLength ? trimmed : trimmed.substring(0, maxLength);
    }
}
