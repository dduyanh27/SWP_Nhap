package com.swp391.se2006.g2.vmfruit.repository;

import com.swp391.se2006.g2.vmfruit.entity.Order;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.math.BigDecimal;
import java.util.List;

public interface OrderRepository extends JpaRepository<Order, Integer> {

    long countByOrderStatus(String orderStatus);

    @Query("SELECT COALESCE(SUM(o.totalAmount), 0) FROM Order o WHERE o.paymentStatus = :paymentStatus")
    BigDecimal sumTotalAmountByPaymentStatus(@Param("paymentStatus") String paymentStatus);

    List<Order> findTop5ByOrderByCreatedAtDesc();
}
