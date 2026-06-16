package com.swp391.se2006.g2.vmfruit.service.impl;

import com.swp391.se2006.g2.vmfruit.entity.Order;
import com.swp391.se2006.g2.vmfruit.repository.OrderRepository;
import com.swp391.se2006.g2.vmfruit.service.OrderService;
import jakarta.transaction.Transactional;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class OrderServiceImpl implements OrderService {

    private final OrderRepository orderRepository;

    public OrderServiceImpl(OrderRepository orderRepository) {
        this.orderRepository = orderRepository;
    }

    @Override
    public List<Order> getOrdersByUser(Integer userId) {
        return orderRepository.findByUser_UserId(userId);
    }

    @Override
    public List<Order> getOrdersByUserAndStatus(Integer userId, String status) {
        return orderRepository.findByUser_UserIdAndOrderStatus(userId, status);
    }

    @Override
    public List<Order> getOrdersByUserAndStatuses(Integer userId, List<String> statuses) {
        return orderRepository.findByUserIdAndOrderStatusIn(userId, statuses);
    }

    @Override
    public Order getOrderById(Integer orderId) {
        return orderRepository.findById(orderId).orElse(null);
    }

    @Override
    public long countOrdersByUserAndStatus(Integer userId, String orderStatus) {
        return orderRepository.countByUser_UserIdAndOrderStatus(userId, orderStatus);
    }

    @Override
    public List<Order> getAllOrders() {
        return orderRepository.findByStatusAndDate(null, null, null);
    }

    /**
     * BUG FIX: original code wrongly called order.setCreatedAt(LocalDateTime.now())
     * inside updateOrderStatus(), which overwrites the original creation timestamp.
     * Removed that line – only orderStatus should change here.
     */
    @Override
    @Transactional
    public void updateOrderStatus(Integer orderId, String status) {
        Order order = orderRepository.findById(orderId)
                .orElseThrow(() -> new RuntimeException("Đơn hàng không tồn tại: " + orderId));
        order.setOrderStatus(status);
        // DO NOT touch createdAt here – it records when the order was created, not updated.
        orderRepository.save(order);
    }

    /**
     * Returns orders filtered by optional status, year and month.
     * Any null parameter is ignored (treated as "all").
     */
    @Override
    public List<Order> getFilteredOrders(String status, Integer year, Integer month) {
        // Normalise empty-string to null so the JPQL IS NULL check works
        String normalizedStatus = (status == null || status.isBlank()) ? null : status;
        return orderRepository.findByStatusAndDate(normalizedStatus, year, month);
    }
}