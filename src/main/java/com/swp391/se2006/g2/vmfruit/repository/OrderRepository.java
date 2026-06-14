package com.swp391.se2006.g2.vmfruit.repository;

import com.swp391.se2006.g2.vmfruit.entity.Order;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

import java.math.BigDecimal;
import java.util.List;

public interface OrderRepository extends JpaRepository<Order, Integer> {

    long countByOrderStatus(String orderStatus);

    @Query("SELECT COALESCE(SUM(o.totalAmount), 0) FROM Order o WHERE o.paymentStatus = :paymentStatus")
    BigDecimal sumTotalAmountByPaymentStatus(@Param("paymentStatus") String paymentStatus);

    List<Order> findTop5ByOrderByCreatedAtDesc();
    List<Order> findByUser_UserId(Integer UserId);
    long countByUser_UserIdAndOrderStatus(Integer userId, String orderStatus);
    Page<Order> findAllByOrderByOrderDateDesc(Pageable pageable);
    Page<Order> findByOrderStatusOrderByOrderDateDesc(String orderStatus, Pageable pageable);

    @Query("SELECT o FROM Order o WHERE o.address.phone LIKE CONCAT('%', :phone, '%') ORDER BY o.orderDate DESC")
    Page<Order> findByAddressPhone(@Param("phone") String phone, Pageable pageable);

    @Query("SELECT o FROM Order o WHERE o.address.phone LIKE CONCAT('%', :phone, '%') AND o.orderStatus = :status ORDER BY o.orderDate DESC")
    Page<Order> findByAddressPhoneAndStatus(@Param("phone") String phone, @Param("status") String status, Pageable pageable);
    boolean existsByShippingCode(String shippingCode);

}
