package com.swp391.se2006.g2.vmfruit.repository;

import com.swp391.se2006.g2.vmfruit.entity.OrderItem;
import jakarta.mail.FetchProfile;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface OrderItemRepository extends JpaRepository<OrderItem, Integer> {

    @Query("SELECT oi FROM OrderItem oi JOIN oi.order o " +
           "WHERE o.user.userId = :userId AND oi.product.productId = :productId " +
           "AND o.orderStatus = 'DELIVERED' ORDER BY o.orderDate DESC")
    List<OrderItem> findDeliveredByUserAndProduct(@Param("userId") Integer userId, @Param("productId") Integer productId);

    @Query("SELECT COUNT(oi) > 0 FROM OrderItem oi " +
           "JOIN oi.order o " +
           "WHERE o.user.userId = :userId AND oi.product.productId = :productId " +
           "AND o.orderStatus = 'DELIVERED'")
    boolean existsByUserAndProductAndDelivered(@Param("userId") Integer userId, @Param("productId") Integer productId);

    List<OrderItem> findByOrder_OrderId(int id);
}