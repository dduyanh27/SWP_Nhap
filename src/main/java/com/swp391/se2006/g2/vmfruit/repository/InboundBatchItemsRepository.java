package com.swp391.se2006.g2.vmfruit.repository;

import com.swp391.se2006.g2.vmfruit.entity.InboundBatchItem;
import com.swp391.se2006.g2.vmfruit.dto.response.BatchItemResponse;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.time.LocalDate;
import java.util.List;

public interface InboundBatchItemsRepository extends JpaRepository<InboundBatchItem, Integer> {
    long countByItemStatusAndRemainingQuantityLessThanEqual(String itemStatus, java.math.BigDecimal threshold);

    @Query("SELECT COUNT(i) FROM InboundBatchItem i WHERE i.itemStatus = 'ACTIVE' AND i.expiryDate >= :today AND i.expiryDate <= :targetDate")
    long countExpiringSoonLotes(@Param("today") LocalDate today, @Param("targetDate") LocalDate targetDate);

    @Query("SELECT new com.swp391.se2006.g2.vmfruit.dto.response.BatchItemResponse(" +
            "bi.batchItemId, bi.product.productName, bi.product.unit, bi.importDetail.importPrice, " +
            "bi.remainingQuantity, bi.acceptedQuantity, bi.expiryDate, bi.itemStatus) " +
            "FROM InboundBatchItem bi WHERE bi.batch.batchId = :batchId")
    List<BatchItemResponse> getItemsByBatchId(@Param("batchId") Integer batchId);

    @Query("SELECT COUNT(bi) FROM InboundBatchItem bi WHERE bi.itemStatus = 'ACTIVE' AND bi.remainingQuantity > 0")
    long countRealActiveBatches();

    @Query("SELECT COUNT(bi) FROM InboundBatchItem bi WHERE bi.itemStatus = 'LIQUIDATED'")
    long countLiquidatedLots();
}