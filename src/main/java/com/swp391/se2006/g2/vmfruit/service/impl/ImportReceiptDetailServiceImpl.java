package com.swp391.se2006.g2.vmfruit.service.impl;

import com.swp391.se2006.g2.vmfruit.dto.request.ImportReceiptDetailRequest;
import com.swp391.se2006.g2.vmfruit.dto.response.ImportReceiptDetailResponse;
import com.swp391.se2006.g2.vmfruit.entity.ImportReceipt;
import com.swp391.se2006.g2.vmfruit.entity.ImportReceiptDetail;
import com.swp391.se2006.g2.vmfruit.entity.Product;
import com.swp391.se2006.g2.vmfruit.repository.ImportReceiptDetailRepository;
import com.swp391.se2006.g2.vmfruit.repository.ImportReceiptRepository;
import com.swp391.se2006.g2.vmfruit.repository.ProductRepository;
import com.swp391.se2006.g2.vmfruit.service.ImportReceiptDetailService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class ImportReceiptDetailServiceImpl implements ImportReceiptDetailService {

    private final ImportReceiptDetailRepository detailRepository;
    private final ImportReceiptRepository receiptRepository;
    private final ProductRepository productRepository;


    @Override
    @Transactional
    public List<ImportReceiptDetailResponse> createDetails(Integer importReceiptId,
                                                             List<ImportReceiptDetailRequest> requests) {

        ImportReceipt receipt = receiptRepository.findById(importReceiptId)
                .orElseThrow(() -> new RuntimeException(
                        "ImportReceipt not found: " + importReceiptId));

        if (!"DRAFT".equals(receipt.getStatus())) {
            throw new IllegalStateException(
                    "Cannot add details to receipt with status: " + receipt.getStatus());
        }

        if (requests == null || requests.isEmpty()) {
            throw new IllegalArgumentException("Detail list must not be empty.");
        }

        // Kiểm tra trùng productId trong cùng 1 request
        long distinctCount = requests.stream()
                .map(ImportReceiptDetailRequest::getProductId)
                .distinct().count();
        if (distinctCount != requests.size()) {
            throw new IllegalArgumentException("Duplicate products in the same receipt.");
        }

        List<ImportReceiptDetail> details = requests.stream().map(req -> {
            com.swp391.se2006.g2.vmfruit.entity.Product product;

            if (req.getProductId() != null) {

                product = productRepository.findById(req.getProductId())
                        .orElseThrow(() -> new RuntimeException(
                                "Không tìm thấy sản phẩm ID: " + req.getProductId()));
            } else {
                product = new com.swp391.se2006.g2.vmfruit.entity.Product();
                product.setProductName(req.getProductName());
                product.setUnit("kg");
                product.setBasePrice(req.getImportPrice());
                product.setSellingStatus("ACTIVE");
                product.setCreatedAt(java.time.LocalDateTime.now());
                product = productRepository.save(product);
            }

            ImportReceiptDetail detail = new ImportReceiptDetail();
            detail.setImportReceipt(receipt);
            detail.setProduct(product);
            detail.setExpectedQuantity(req.getExpectedQuantity());
            detail.setImportPrice(req.getImportPrice());
            detail.setExpectedExpiryDate(req.getExpectedExpiryDate());
            detail.setNote(req.getNote());
            return detail;
        }).collect(Collectors.toList());

        List<ImportReceiptDetail> saved = detailRepository.saveAll(details);
        return saved.stream().map(this::toResponse).collect(Collectors.toList());
    }


    @Override
    @Transactional(readOnly = true)
    public List<ImportReceiptDetailResponse> getDetailsByReceiptId(Integer importReceiptId) {
        return detailRepository.findByReceiptIdWithProduct(importReceiptId)
                .stream().map(this::toResponse).collect(Collectors.toList());
    }

    @Override
    @Transactional(readOnly = true)
    public ImportReceiptDetailResponse getDetailById(Integer importDetailId) {
        ImportReceiptDetail detail = detailRepository.findById(importDetailId)
                .orElseThrow(() -> new RuntimeException(
                        "ImportReceiptDetail not found: " + importDetailId));
        return toResponse(detail);
    }



    @Override
    @Transactional
    public List<ImportReceiptDetailResponse> updateDetails(Integer importReceiptId,
                                                           List<ImportReceiptDetailRequest> requests) {

        ImportReceipt receipt = receiptRepository.findById(importReceiptId)
                .orElseThrow(() -> new RuntimeException(
                        "ImportReceipt not found: " + importReceiptId));

        if (!"DRAFT".equals(receipt.getStatus())) {
            throw new IllegalStateException(
                    "Cannot edit details of receipt with status: " + receipt.getStatus());
        }


        detailRepository.deleteByImportReceiptId(importReceiptId);
        detailRepository.flush();

        return createDetails(importReceiptId, requests);
    }



    @Override
    @Transactional
    public void deleteDetail(Integer importDetailId) {
        if (!detailRepository.existsById(importDetailId)) {
            throw new RuntimeException("ImportReceiptDetail not found: " + importDetailId);
        }
        detailRepository.deleteById(importDetailId);
    }

    @Override
    @Transactional
    public void deleteAllByReceiptId(Integer importReceiptId) {
        detailRepository.deleteByImportReceiptId(importReceiptId);
    }


    @Override
    @Transactional(readOnly = true)
    public BigDecimal sumTotalExpectedQuantity() {
        return detailRepository.sumTotalExpectedQuantity();
    }

    @Override
    @Transactional(readOnly = true)
    public BigDecimal sumSubtotalByReceiptId(Integer importReceiptId) {
        return detailRepository.sumSubtotalByReceiptId(importReceiptId);
    }

    @Override
    @Transactional(readOnly = true)
    public boolean isProductExistsInReceipt(Integer importReceiptId, Integer productId) {
        return detailRepository.existsByImportReceipt_ImportReceiptIdAndProduct_ProductId(
                importReceiptId, productId);
    }



    private ImportReceiptDetailResponse toResponse(ImportReceiptDetail detail) {
        return new ImportReceiptDetailResponse(
                detail.getImportDetailId(),
                detail.getProduct().getProductId(),
                detail.getProduct().getProductName(),
                detail.getProduct().getUnit(),
                detail.getExpectedQuantity(),
                detail.getImportPrice(),
                detail.getExpectedExpiryDate(),
                detail.getNote()
        );
    }
}