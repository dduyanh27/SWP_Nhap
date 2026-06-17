package com.swp391.se2006.g2.vmfruit.service.impl;

import com.swp391.se2006.g2.vmfruit.dto.request.ImportReceiptRequest;
import com.swp391.se2006.g2.vmfruit.dto.response.ImportReceiptDetailResponse;
import com.swp391.se2006.g2.vmfruit.dto.response.ImportReceiptRowResponse;
import com.swp391.se2006.g2.vmfruit.entity.ImportReceipt;
import com.swp391.se2006.g2.vmfruit.entity.Product;
import com.swp391.se2006.g2.vmfruit.entity.Supplier;
import com.swp391.se2006.g2.vmfruit.entity.User;
import com.swp391.se2006.g2.vmfruit.repository.*;
import com.swp391.se2006.g2.vmfruit.service.AdminImportReceiptService;
import com.swp391.se2006.g2.vmfruit.service.ImportReceiptDetailService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.stream.Collectors;

@Service
public class AdminImportReceiptServiceImpl implements AdminImportReceiptService {
    private final ProductRepository productRepository;
    private static final String STATUS_RECEIVED  = "RECEIVED";
    private static final String STATUS_CANCELLED = "CANCELLED";
    private static final DateTimeFormatter DATE_DISPLAY =
            DateTimeFormatter.ofPattern("dd/MM/yyyy");

    private final ImportReceiptRepository       importReceiptRepository;
    private final ImportReceiptDetailRepository importReceiptDetailRepository;
    private final InboundBatchRepository        inboundBatchRepository;
    private final SupplierRepository            supplierRepository;
    private final UserRepository                userRepository;          // ← fix 1: inject đúng
    private final ImportReceiptDetailService    importReceiptDetailService; // ← fix 2: inject đúng

    public AdminImportReceiptServiceImpl(
            ProductRepository productRepository, ImportReceiptRepository importReceiptRepository,
            ImportReceiptDetailRepository importReceiptDetailRepository,
            InboundBatchRepository inboundBatchRepository,
            SupplierRepository supplierRepository,
            UserRepository userRepository,
            ImportReceiptDetailService importReceiptDetailService) {
        this.productRepository = productRepository;
        this.importReceiptRepository       = importReceiptRepository;
        this.importReceiptDetailRepository = importReceiptDetailRepository;
        this.inboundBatchRepository        = inboundBatchRepository;
        this.supplierRepository            = supplierRepository;
        this.userRepository                = userRepository;
        this.importReceiptDetailService    = importReceiptDetailService;
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
    public Map<String, Long> getStats() {
        Map<String, Long> stats = new HashMap<>();
        stats.put("total",     importReceiptRepository.count());
        stats.put("pending",   getPendingCount());
        stats.put("received",  getReceivedCount());
        stats.put("cancelled", importReceiptRepository.countByStatus(STATUS_CANCELLED));
        return stats;
    }

    @Override
    @Transactional(readOnly = true)
    public List<Supplier> getActiveSuppliers() {
        return supplierRepository.findByStatusOrderBySupplierNameAsc("ACTIVE");
    }

    @Override
    @Transactional(readOnly = true)
    public List<ImportReceiptRowResponse> getReceiptRows(Integer supplierId, String sortDate) {
        Set<Integer> receivedIds     = getReceivedReceiptIds();
        Map<Integer, BigDecimal> qtyMap = loadQuantityByReceipt();

        List<ImportReceiptRowResponse> rows = importReceiptRepository
                .findAllWithSupplier(supplierId)
                .stream()
                .map(ir -> toRow(ir,
                        qtyMap.getOrDefault(ir.getImportReceiptId(), BigDecimal.ZERO),
                        receivedIds))
                .collect(Collectors.toList());

        Comparator<ImportReceiptRowResponse> byDate = Comparator.comparing(
                ImportReceiptRowResponse::getCreatedDate,
                Comparator.nullsLast(Comparator.naturalOrder()));

        rows.sort("oldest".equalsIgnoreCase(sortDate) ? byDate : byDate.reversed());
        return rows;
    }

    @Override
    @Transactional(readOnly = true)
    public List<ImportReceiptRowResponse> getAllReceiptRows(Integer supplierId, String status) {
        return importReceiptRepository
                .findBySupplierAndStatus(supplierId, status)
                .stream()
                .map(ir -> {
                    // fix 3: totalExpectedQuantity là Integer, unitCost là BigDecimal
                    ImportReceiptRowResponse row = new ImportReceiptRowResponse(
                            ir.getImportReceiptId(),
                            ir.getSupplier().getSupplierName(),
                            ir.getCreatedDate(),
                            ir.getUnitCost(),           // BigDecimal
                            ir.getStatus());
                    row.setTotalExpectedQuantity(ir.getTotalExpectedQuantity()); // Integer
                    return row;
                })
                .collect(Collectors.toList());
    }


    @Override

    @Transactional
    public ImportReceiptRowResponse createWithDetails(ImportReceiptRequest request,
                                                      Integer createdByUserId) {

        if (request.getDetails() == null || request.getDetails().isEmpty()) {
            throw new IllegalArgumentException(
                    "Import receipt must have at least one detail item.");
        }

        Supplier supplier = supplierRepository.findById(request.getSupplierId())
                .orElseThrow(() -> new RuntimeException(
                        "Supplier not found: " + request.getSupplierId()));

        User createdBy = userRepository.findById(createdByUserId)
                .orElseThrow(() -> new RuntimeException(
                        "User not found: " + createdByUserId));

        // 1. TÍNH TOÁN TỔNG SỐ LƯỢNG VÀ TỔNG TIỀN TỪ DANH SÁCH SẢN PHẨM TRUYỀN LÊN
        BigDecimal totalAmount = BigDecimal.ZERO;
        BigDecimal totalQty = BigDecimal.ZERO;
        for (var detailReq : request.getDetails()) {
            BigDecimal qty = detailReq.getExpectedQuantity() != null ? detailReq.getExpectedQuantity() : BigDecimal.ZERO;
            BigDecimal price = detailReq.getImportPrice() != null ? detailReq.getImportPrice() : BigDecimal.ZERO;

            totalQty = totalQty.add(qty);
            totalAmount = totalAmount.add(qty.multiply(price)); // Thành tiền = số lượng * đơn giá
        }

        // 2. KHỞI TẠO PHIẾU NHẬP
        ImportReceipt receipt = new ImportReceipt();
        receipt.setSupplier(supplier);
        receipt.setCreatedByUser(createdBy);
        receipt.setCreatedDate(LocalDateTime.now());
        receipt.setExpectedDeliveryDate(request.getExpectedDeliveryDate());
        receipt.setStatus("DRAFT");
        receipt.setNote(request.getNote());

        // CHỖ FIX LỖI: Gán tổng số lượng và tổng tiền vào Entity trước khi save
        receipt.setTotalExpectedQuantity(totalQty.intValue());
        receipt.setUnitCost(totalAmount);

        // 3. LƯU PHIẾU NHẬP VÀO DATABASE
        ImportReceipt savedReceipt = importReceiptRepository.save(receipt);

        // 4. LƯU CHI TIẾT SẢN PHẨM (Details)
        List<ImportReceiptDetailResponse> detailResponses =
                importReceiptDetailService.createDetails(
                        savedReceipt.getImportReceiptId(), request.getDetails());

        // 5. TRẢ VỀ KẾT QUẢ
        ImportReceiptRowResponse response = new ImportReceiptRowResponse(
                savedReceipt.getImportReceiptId(),
                supplier.getSupplierName(),
                savedReceipt.getCreatedDate(),
                savedReceipt.getUnitCost(),
                savedReceipt.getStatus());
        response.setTotalExpectedQuantity(savedReceipt.getTotalExpectedQuantity());

        return response;
    }
    @Override
    @Transactional(readOnly = true)
    public ImportReceiptRowResponse getReceiptWithDetails(Integer importReceiptId) {
        ImportReceipt receipt = importReceiptRepository.findByIdWithRelations(importReceiptId)
                .orElseThrow(() -> new RuntimeException(
                        "ImportReceipt not found: " + importReceiptId));
        List<ImportReceiptDetailResponse> details =
                importReceiptDetailService.getDetailsByReceiptId(importReceiptId);

        ImportReceiptRowResponse response = new ImportReceiptRowResponse(
                receipt.getImportReceiptId(),
                receipt.getSupplier().getSupplierName(),
                receipt.getCreatedDate(),
                receipt.getUnitCost(),          // BigDecimal
                receipt.getStatus());
        response.setTotalExpectedQuantity(receipt.getTotalExpectedQuantity()); // Integer

        return response;
    }

    private ImportReceiptRowResponse toRow(ImportReceipt receipt,
                                           BigDecimal totalQty, Set<Integer> receivedIds) {
        ImportReceiptRowResponse row = new ImportReceiptRowResponse(
                receipt.getImportReceiptId(),
                receipt.getSupplier().getSupplierName(),
                receipt.getCreatedDate(),
                receipt.getUnitCost(),          // BigDecimal
                receipt.getStatus());

        row.setTotalExpectedQuantity(totalQty != null ? totalQty.intValue() : 0);
        row.setImportIdDisplay(String.format("PO%03d", receipt.getImportReceiptId()));

        if (receipt.getCreatedDate() != null) {
            row.setCreatedDateDisplay(receipt.getCreatedDate().format(DATE_DISPLAY));
        }
        row.setStatusKey(resolveStatusKey(
                receipt.getStatus(),
                receivedIds.contains(receipt.getImportReceiptId())));
        return row;
    }

    private Set<Integer> getReceivedReceiptIds() {
        return new HashSet<>(inboundBatchRepository.findAllImportReceiptIds());
    }

    private Map<Integer, BigDecimal> loadQuantityByReceipt() {
        Map<Integer, BigDecimal> map = new HashMap<>();
        for (Object[] row : importReceiptDetailRepository.sumQuantityByReceipt()) {
            map.put((Integer) row[0], toBigDecimal(row[1]));
        }
        return map;
    }

    private static String resolveStatusKey(String dbStatus, boolean hasInboundBatch) {
        if (hasInboundBatch || STATUS_RECEIVED.equalsIgnoreCase(dbStatus)) return "received";
        if (STATUS_CANCELLED.equalsIgnoreCase(dbStatus))                   return "cancelled";
        return "pending";
    }

    private static BigDecimal toBigDecimal(Object value) {
        if (value == null)                  return BigDecimal.ZERO;
        if (value instanceof BigDecimal bd) return bd;
        if (value instanceof Number n)      return BigDecimal.valueOf(n.doubleValue());
        return BigDecimal.ZERO;
    }
    @Override
    @Transactional(readOnly = true)
    public List<Product> getActiveProducts() {
        return productRepository.findBySellingStatus("ACTIVE");
    }
}