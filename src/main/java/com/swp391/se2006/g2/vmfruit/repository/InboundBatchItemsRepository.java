package com.swp391.se2006.g2.vmfruit.repository;

import com.swp391.se2006.g2.vmfruit.entity.InboundBatchItem;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.time.LocalDate;

public interface InboundBatchItemsRepository extends JpaRepository<InboundBatchItem, Integer> {
    long countByItemStatusAndRemainingQuantityLessThanEqual(String itemStatus, java.math.BigDecimal threshold);

    @Query("SELECT COUNT(i) FROM InboundBatchItem i WHERE i.itemStatus = 'ACTIVE' AND i.expiryDate >= :today AND i.expiryDate <= :targetDate")
    long countExpiringSoonLotes(@Param("today") LocalDate today, @Param("targetDate") LocalDate targetDate);
}

