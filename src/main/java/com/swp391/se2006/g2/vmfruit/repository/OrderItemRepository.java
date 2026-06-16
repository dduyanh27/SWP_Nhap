package com.swp391.se2006.g2.vmfruit.repository;

import com.swp391.se2006.g2.vmfruit.entity.OrderItem;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface OrderItemRepository extends JpaRepository<OrderItem, Integer> {

    List<OrderItem> findByOrder_OrderId(Integer orderId);


    @Query("SELECT oi FROM OrderItem oi " +
            "WHERE oi.order.user.userId = :userId " +
            "AND oi.product.productId = :productId " +
            "AND oi.order.orderStatus = 'DELIVERED'")
    List<OrderItem> findDeliveredByUserAndProduct(
            @Param("userId") Integer userId,
            @Param("productId") Integer productId);


    @Query("SELECT COUNT(oi) > 0 FROM OrderItem oi " +
            "WHERE oi.order.user.userId = :userId " +
            "AND oi.product.productId = :productId " +
            "AND oi.order.orderStatus = 'DELIVERED'")
    boolean existsByUserAndProductAndDelivered(
            @Param("userId") Integer userId,
            @Param("productId") Integer productId);
}