package com.swp391.se2006.g2.vmfruit.service;

import com.swp391.se2006.g2.vmfruit.entity.Order;
import java.util.List;

public interface OrderService {

     List<Order> getOrdersByUser(Integer userId);


     Order getOrderById(Integer orderId);


    long countOrdersByUserAndStatus(Integer userId, String orderStatus);
}