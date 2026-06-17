package com.swp391.se2006.g2.vmfruit.repository;

import com.swp391.se2006.g2.vmfruit.entity.DiscountCode;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

public interface DiscountCodeRepository extends JpaRepository<DiscountCode, Integer> {

    Optional<DiscountCode> findByCodeIgnoreCase(String code);

    List<DiscountCode> findAllByOrderByEndDateDesc();

    List<DiscountCode> findAllByOrderByUsedCountAsc();

    long countByStatus(String status);

    @Query("SELECT d FROM DiscountCode d WHERE d.status = 'ACTIVE' AND d.startDate <= ?1 AND d.endDate >= ?1")
    List<DiscountCode> findActiveDiscounts(LocalDateTime now);
}
