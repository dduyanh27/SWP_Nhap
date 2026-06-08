package com.swp391.se2006.g2.vmfruit.service.impl;

import com.swp391.se2006.g2.vmfruit.repository.CategoryRepository;
import com.swp391.se2006.g2.vmfruit.repository.OrderRepository;
import com.swp391.se2006.g2.vmfruit.repository.ProductRepository;
import com.swp391.se2006.g2.vmfruit.repository.UserRepository;
import com.swp391.se2006.g2.vmfruit.service.AdminService;
import org.springframework.stereotype.Service;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.HashMap;
import java.util.Map;

@Service
public class AdminServiceImpl implements AdminService {

    private static final Logger log = LoggerFactory.getLogger(AdminServiceImpl.class);

    private final UserRepository userRepository;
    private final ProductRepository productRepository;
    private final OrderRepository orderRepository;
    private final CategoryRepository categoryRepository;

    public AdminServiceImpl(UserRepository userRepository,
                            ProductRepository productRepository,
                            OrderRepository orderRepository,
                            CategoryRepository categoryRepository) {
        this.userRepository = userRepository;
        this.productRepository = productRepository;
        this.orderRepository = orderRepository;
        this.categoryRepository = categoryRepository;
    }

    @Override
    public Map<String, Object> getDashboardStats() {
        Map<String, Object> stats = new HashMap<>();
        try {
            stats.put("totalUsers", userRepository.count());
            stats.put("totalProducts", productRepository.count());
            stats.put("totalCategories", categoryRepository.count());
            stats.put("totalOrders", orderRepository.count());
            stats.put("pendingOrders", orderRepository.countByOrderStatus("PENDING_APPROVAL"));
            stats.put("totalRevenue", orderRepository.sumTotalAmountByPaymentStatus("PAID"));
            stats.put("recentOrders", orderRepository.findTop5ByOrderByCreatedAtDesc());
            stats.put("recentUsers", userRepository.findTop5ByOrderByCreatedAtDesc());
        } catch (Exception e) {
            log.warn("Dashboard DB query failed, using fallback data: {}", e.getMessage());
            stats.put("totalUsers", 0L);
            stats.put("totalProducts", 0L);
            stats.put("totalCategories", 0L);
            stats.put("totalOrders", 0L);
            stats.put("pendingOrders", 0L);
            stats.put("totalRevenue", 0.0);
            stats.put("recentOrders", java.util.Collections.emptyList());
            stats.put("recentUsers", java.util.Collections.emptyList());
        }
        return stats;
    }
}
