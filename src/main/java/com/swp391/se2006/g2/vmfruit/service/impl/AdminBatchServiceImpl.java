package com.swp391.se2006.g2.vmfruit.service.impl;

import com.swp391.se2006.g2.vmfruit.dto.response.BatchGroupResponse;
import com.swp391.se2006.g2.vmfruit.dto.response.BatchItemResponse;
import com.swp391.se2006.g2.vmfruit.dto.response.BatchStatsResponse;
import com.swp391.se2006.g2.vmfruit.entity.InboundBatch;
import com.swp391.se2006.g2.vmfruit.entity.InboundBatchItem;
import com.swp391.se2006.g2.vmfruit.repository.InboundBatchRepository;
import com.swp391.se2006.g2.vmfruit.repository.InboundBatchItemsRepository;
import com.swp391.se2006.g2.vmfruit.service.AdminBatchService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class AdminBatchServiceImpl implements AdminBatchService {

    private final InboundBatchRepository inboundBatchRepository;
    private final InboundBatchItemsRepository inboundBatchItemsRepository;

    public AdminBatchServiceImpl(InboundBatchRepository inboundBatchRepository,
                                 InboundBatchItemsRepository inboundBatchItemsRepository) {
        this.inboundBatchRepository = inboundBatchRepository;
        this.inboundBatchItemsRepository = inboundBatchItemsRepository;
    }

    @Override
    public List<BatchGroupResponse> getBatchManagementData() {
        // 1. Lấy tất cả lô hàng từ database
        // Lưu ý: Đảm bảo InboundBatch đã có @OneToMany(fetch = FetchType.EAGER) hoặc dùng JOIN FETCH
        List<InboundBatch> batches = inboundBatchRepository.findAll();

        return batches.stream().map(batch -> {
            // 2. Map thông tin Lô cha (BatchGroupResponse)
            BatchGroupResponse group = new BatchGroupResponse();
            group.setBatchId(batch.getBatchId());

            // Kiểm tra null trước khi truy xuất các thuộc tính liên quan
            if (batch.getImportReceipt() != null) {
                group.setPoCode("PO#" + batch.getImportReceipt().getImportReceiptId());
                if (batch.getImportReceipt().getSupplier() != null) {
                    group.setSupplierName(batch.getImportReceipt().getSupplier().getSupplierName());
                }
            }

            group.setReceivedDate(batch.getReceivedDate());
            group.setBatchStatus(batch.getBatchStatus());

            // 3. Map danh sách sản phẩm con (chỉ lấy item chưa bị CANCELLED)
            List<BatchItemResponse> itemResponses = batch.getBatchItems().stream()
                    .filter(item -> !"CANCELLED".equals(item.getItemStatus()))
                    .map(item -> {
                BatchItemResponse itemDto = new BatchItemResponse();
                itemDto.setBatchItemId(item.getBatchItemId());

                // Lấy thông tin từ Product
                if (item.getProduct() != null) {
                    itemDto.setProductName(item.getProduct().getProductName());
                    itemDto.setUnit(item.getProduct().getUnit()); // BỔ SUNG: Gán unit từ Product
                } else {
                    itemDto.setProductName("Unknown");
                    itemDto.setUnit(""); // Giá trị mặc định
                }

                // Lấy giá từ ImportReceiptDetail
                itemDto.setImportPrice(item.getImportDetail() != null ? item.getImportDetail().getImportPrice() : BigDecimal.ZERO);

                itemDto.setRemainingQuantity(item.getRemainingQuantity());
                itemDto.setAcceptedQuantity(item.getAcceptedQuantity());
                itemDto.setExpiryDate(item.getExpiryDate());

                // TÍNH TOÁN NGÀY HẾT HẠN
                if (item.getExpiryDate() != null) {
                    long daysLeft = ChronoUnit.DAYS.between(LocalDate.now(), item.getExpiryDate());
                    itemDto.setDaysLeft(daysLeft);
                }
                return itemDto;
            }).collect(Collectors.toList());

            group.setBatchItems(itemResponses);
            return group;
        }).collect(Collectors.toList());
    }

    @Override
    public BatchStatsResponse getBatchStats() {
        long activeBatches = inboundBatchItemsRepository.countRealActiveBatches();
        LocalDate today = LocalDate.now();
        LocalDate threeDaysLater = today.plusDays(3);
        long expiringBatches = inboundBatchItemsRepository.countExpiringSoonLotes(today, threeDaysLater);
        long liquidatedLots = inboundBatchItemsRepository.countLiquidatedLots();
        return new BatchStatsResponse(activeBatches, expiringBatches, liquidatedLots);
    }

    @Override
    @Transactional
    public void deleteBatch(Integer batchId) {
        InboundBatch batch = inboundBatchRepository.findById(batchId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy lô hàng"));
        batch.setBatchStatus("DELETED");
        inboundBatchRepository.save(batch);
    }

    // ── Remove Item: chuyển 1 BatchItem sang CANCELLED ──────────────
    @Override
    @Transactional
    public void cancelBatchItem(Integer batchId, Integer batchItemId) {
        // Kiểm tra lô cha tồn tại
        InboundBatch batch = inboundBatchRepository.findById(batchId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy lô hàng ID=" + batchId));

        // Lấy item và kiểm tra nó thuộc lô cha
        InboundBatchItem item = inboundBatchItemsRepository.findById(batchItemId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy item ID=" + batchItemId));

        if (!item.getBatch().getBatchId().equals(batchId)) {
            throw new RuntimeException("Item này không thuộc lô hàng ID=" + batchId);
        }

        if ("CANCELLED".equals(item.getItemStatus())) {
            throw new RuntimeException("Item này đã ở trạng thái CANCELLED.");
        }

        // Chuyển sang CANCELLED — giữ nguyên lịch sử, không xóa dữ liệu
        item.setItemStatus("CANCELLED");
        inboundBatchItemsRepository.save(item);
    }

    // ── Cancel Batch: hủy toàn bộ lô (chỉ khi chưa xuất bán) ───────
    @Override
    @Transactional
    public void cancelBatch(Integer batchId) {
        InboundBatch batch = inboundBatchRepository.findById(batchId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy lô hàng ID=" + batchId));

        if ("CANCELLED".equals(batch.getBatchStatus())) {
            throw new RuntimeException("Lô hàng này đã ở trạng thái CANCELLED.");
        }

        // Kiểm tra bảo vệ: không được hủy lô đã xuất bán
        boolean hasSoldItems = batch.getBatchItems().stream()
                .filter(i -> !"CANCELLED".equals(i.getItemStatus()))
                .anyMatch(i -> i.getRemainingQuantity().compareTo(i.getAcceptedQuantity()) < 0);

        if (hasSoldItems) {
            throw new IllegalStateException(
                "Không thể hủy lô hàng: có sản phẩm đã được xuất bán trong lô này."
            );
        }

        // Hủy toàn bộ items ACTIVE/INACTIVE
        batch.getBatchItems().stream()
                .filter(i -> !"CANCELLED".equals(i.getItemStatus()))
                .forEach(i -> {
                    i.setItemStatus("CANCELLED");
                    inboundBatchItemsRepository.save(i);
                });

        // Hủy lô cha
        batch.setBatchStatus("CANCELLED");
        inboundBatchRepository.save(batch);
    }

}