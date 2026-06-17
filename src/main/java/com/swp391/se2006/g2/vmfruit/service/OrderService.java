package com.swp391.se2006.g2.vmfruit.service;

import com.swp391.se2006.g2.vmfruit.entity.Order;
import java.util.List;

public interface OrderService {

    List<Order> getOrdersByUser(Integer userId);
    Order getOrderById(Integer orderId);


    /**
     * Bug fix: removed bogus createdAt update from updateOrderStatus().
     */
    void updateOrderStatus(Integer orderId, String status);

     List<Order> getOrdersByUserAndStatus(Integer userId, String status);

     List<Order> getOrdersByUserAndStatuses(Integer userId, List<String> statuses);


    List<Order> getAllOrders();

    List<Order> getFilteredOrders(String status, Integer year, Integer month);

    long countOrdersByUserAndStatus(Integer userId, String orderStatus);
}