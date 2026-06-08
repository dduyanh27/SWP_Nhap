package com.swp391.se2006.g2.vmfruit.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Entity
@Table(name = "InboundBatchItems")
public class InboundBatchItem {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "batch_item_id")
    private Integer batchItemId;

    @ManyToOne
    @JoinColumn(name = "batch_id", nullable = false)
    private InboundBatch batch;

    @ManyToOne
    @JoinColumn(name = "import_detail_id", nullable = false)
    private ImportReceiptDetail importDetail;

    @ManyToOne
    @JoinColumn(name = "product_id", nullable = false)
    private Product product;

    @Column(name = "actual_quantity", nullable = false, precision = 10, scale = 2)
    private BigDecimal actualQuantity;

    @Column(name = "accepted_quantity", nullable = false, precision = 10, scale = 2)
    private BigDecimal acceptedQuantity;

    @Column(name = "damaged_quantity", nullable = false, precision = 10, scale = 2)
    private BigDecimal damagedQuantity = BigDecimal.ZERO;

    @Column(name = "remaining_quantity", nullable = false, precision = 10, scale = 2)
    private BigDecimal remainingQuantity;

    @Column(name = "expiry_date", nullable = false)
    private LocalDate expiryDate;

    @Column(name = "quality_status", nullable = false, length = 30)
    private String qualityStatus = "FRESH";

    @Column(name = "item_status", nullable = false, length = 30)
    private String itemStatus = "ACTIVE";

    @Column(name = "created_at", nullable = false)
    private LocalDateTime createdAt;

    public Integer getBatchItemId() {
        return batchItemId;
    }

    public void setBatchItemId(Integer batchItemId) {
        this.batchItemId = batchItemId;
    }

    public InboundBatch getBatch() {
        return batch;
    }

    public void setBatch(InboundBatch batch) {
        this.batch = batch;
    }

    public ImportReceiptDetail getImportDetail() {
        return importDetail;
    }

    public void setImportDetail(ImportReceiptDetail importDetail) {
        this.importDetail = importDetail;
    }

    public Product getProduct() {
        return product;
    }

    public void setProduct(Product product) {
        this.product = product;
    }

    public BigDecimal getActualQuantity() {
        return actualQuantity;
    }

    public void setActualQuantity(BigDecimal actualQuantity) {
        this.actualQuantity = actualQuantity;
    }

    public BigDecimal getAcceptedQuantity() {
        return acceptedQuantity;
    }

    public void setAcceptedQuantity(BigDecimal acceptedQuantity) {
        this.acceptedQuantity = acceptedQuantity;
    }

    public BigDecimal getDamagedQuantity() {
        return damagedQuantity;
    }

    public void setDamagedQuantity(BigDecimal damagedQuantity) {
        this.damagedQuantity = damagedQuantity;
    }

    public BigDecimal getRemainingQuantity() {
        return remainingQuantity;
    }

    public void setRemainingQuantity(BigDecimal remainingQuantity) {
        this.remainingQuantity = remainingQuantity;
    }

    public LocalDate getExpiryDate() {
        return expiryDate;
    }

    public void setExpiryDate(LocalDate expiryDate) {
        this.expiryDate = expiryDate;
    }

    public String getQualityStatus() {
        return qualityStatus;
    }

    public void setQualityStatus(String qualityStatus) {
        this.qualityStatus = qualityStatus;
    }

    public String getItemStatus() {
        return itemStatus;
    }

    public void setItemStatus(String itemStatus) {
        this.itemStatus = itemStatus;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
}
