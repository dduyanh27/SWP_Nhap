package com.swp391.se2006.g2.vmfruit.controller.admin;

import com.swp391.se2006.g2.vmfruit.dto.response.OrderItemDTO;
import com.swp391.se2006.g2.vmfruit.entity.Order;
import com.swp391.se2006.g2.vmfruit.repository.OrderItemRepository;
import com.swp391.se2006.g2.vmfruit.service.OrderService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;

@Controller
@RequestMapping("/admin/orders")
public class OrderManagementController {

    private final OrderService orderService;
    private final OrderItemRepository orderItemRepository;

    public OrderManagementController(OrderService orderService,
                                     OrderItemRepository orderItemRepository) {
        this.orderService = orderService;
        this.orderItemRepository = orderItemRepository;
    }

    @GetMapping
    public String showOrderManagement(
            @RequestParam(required = false) String status,
            @RequestParam(required = false) Integer year,
            @RequestParam(required = false) Integer month,
            Model model) {

        List<Order> orders = orderService.getFilteredOrders(status, year, month);

        List<Order> allOrders = orderService.getAllOrders();

        double totalRevenue = orders.stream()
                .filter(o -> "COMPLETED".equals(o.getOrderStatus()))
                .mapToDouble(o -> o.getTotalAmount().doubleValue())
                .sum();

        long pendingOrders = allOrders.stream()
                .filter(o -> "PENDING".equals(o.getOrderStatus()))
                .count();

        model.addAttribute("orders",        orders);
        model.addAttribute("totalRevenue",  totalRevenue);
        model.addAttribute("totalOrders",   allOrders.size());
        model.addAttribute("pendingOrders", pendingOrders);

        model.addAttribute("filterStatus", status  == null ? "" : status);
        model.addAttribute("filterYear",   year);
        model.addAttribute("filterMonth",  month);

        return "admin/orders";
    }
    @PostMapping("/{orderId}/update-status")
    public String updateOrderStatus(@PathVariable Integer orderId,
                                    @RequestParam("status") String newStatus,
                                    RedirectAttributes redirectAttributes) {
        try {
            orderService.updateOrderStatus(orderId, newStatus);
            redirectAttributes.addFlashAttribute("successMessage", "Cập nhật trạng thái đơn hàng thành công!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Cập nhật thất bại: " + e.getMessage());
        }
        return "redirect:/admin/orders";
    }

    @GetMapping("/{orderId}/detail")
    @ResponseBody
    public Order getOrderDetail(@PathVariable Integer orderId) {
        return orderService.getOrderById(orderId);
    }

    @GetMapping("/{orderId}/items")
    @ResponseBody
    public List<OrderItemDTO> getOrderItems(@PathVariable Integer orderId) {
        return orderItemRepository.findByOrder_OrderId(orderId)
                .stream()
                .map(item -> new OrderItemDTO(
                        item.getProduct().getProductName(),
                        item.getQuantity(),
                        item.getUnitPrice()
                ))
                .toList();
    }
}