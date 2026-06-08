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

@Entity
@Table(name = "OrderItemBatches")
public class OrderItemBatch {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "order_item_batch_id")
    private Integer orderItemBatchId;

    @ManyToOne
    @JoinColumn(name = "order_item_id", nullable = false)
    private OrderItem orderItem;

    @ManyToOne
    @JoinColumn(name = "batch_item_id", nullable = false)
    private InboundBatchItem batchItem;

    @Column(name = "quantity_allocated", nullable = false, precision = 10, scale = 2)
    private BigDecimal quantityAllocated;

    public Integer getOrderItemBatchId() {
        return orderItemBatchId;
    }

    public void setOrderItemBatchId(Integer orderItemBatchId) {
        this.orderItemBatchId = orderItemBatchId;
    }

    public OrderItem getOrderItem() {
        return orderItem;
    }

    public void setOrderItem(OrderItem orderItem) {
        this.orderItem = orderItem;
    }

    public InboundBatchItem getBatchItem() {
        return batchItem;
    }

    public void setBatchItem(InboundBatchItem batchItem) {
        this.batchItem = batchItem;
    }

    public BigDecimal getQuantityAllocated() {
        return quantityAllocated;
    }

    public void setQuantityAllocated(BigDecimal quantityAllocated) {
        this.quantityAllocated = quantityAllocated;
    }
}
