package com.swp391.se2006.g2.vmfruit.controller.sales;

import com.swp391.se2006.g2.vmfruit.entity.Order;
import com.swp391.se2006.g2.vmfruit.entity.OrderItem;
import com.swp391.se2006.g2.vmfruit.entity.User;
import com.swp391.se2006.g2.vmfruit.repository.OrderItemRepository;
import com.swp391.se2006.g2.vmfruit.repository.OrderRepository;
import jakarta.servlet.http.HttpSession;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import com.swp391.se2006.g2.vmfruit.entity.ShippingProvider;
import com.swp391.se2006.g2.vmfruit.repository.ShippingProviderRepository;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/sales")
public class SalesController {

    private final OrderRepository orderRepository;
    private final OrderItemRepository orderItemRepository;
    private final ShippingProviderRepository shippingProviderRepository;

    public SalesController(OrderRepository orderRepository,
                           OrderItemRepository orderItemRepository,
                           ShippingProviderRepository shippingProviderRepository) {
        this.orderRepository = orderRepository;
        this.orderItemRepository = orderItemRepository;
        this.shippingProviderRepository = shippingProviderRepository;
    }


    @GetMapping("/dashboard")
    public String salesDashboard(HttpSession session, Model model) {
        User user = (User) session.getAttribute("currentUser");
        Boolean isSale = (Boolean) session.getAttribute("isSalesStaff");
        if (user == null || isSale == null || !isSale) return "redirect:/login";
        model.addAttribute("user", user);
        return "sales/dashboard";
    }

    @GetMapping("/orders")
    public String orderList(HttpSession session, Model model,
                            @RequestParam(defaultValue = "") String phone,
                            @RequestParam(defaultValue = "") String status,
                            @RequestParam(defaultValue = "0") int page) {

        User user = (User) session.getAttribute("currentUser");
        Boolean isSale = (Boolean) session.getAttribute("isSalesStaff");
        if (user == null || isSale == null || !isSale) return "redirect:/login";

        Pageable pageable = PageRequest.of(page, 10);
        Page<Order> orders;

        boolean hasPhone = !phone.isBlank();
        boolean hasStatus = !status.isBlank();

        if (hasPhone && hasStatus) {
            orders = orderRepository.findByAddressPhoneAndStatus(phone, status, pageable);
        } else if (hasPhone) {
            orders = orderRepository.findByAddressPhone(phone, pageable);
        } else if (hasStatus) {
            orders = orderRepository.findByOrderStatus(status, pageable);
        } else {
            orders = orderRepository.findAllByOrderByOrderDateDesc(pageable);
        }

        model.addAttribute("user", user);
        model.addAttribute("orders", orders);
        model.addAttribute("phone", phone);
        model.addAttribute("status", status);
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", orders.getTotalPages());
        return "sales/orders";
    }

    @GetMapping("/orders/{id}/items")
    @ResponseBody
    public List<Map<String, Object>> getOrderItems(@PathVariable("id") Integer id, HttpSession session) {
        User user = (User) session.getAttribute("currentUser");
        Boolean isSale = (Boolean) session.getAttribute("isSalesStaff");
        if (user == null || isSale == null || !isSale) {
            return new ArrayList<>();
        }



        List<OrderItem> items = orderItemRepository.findByOrder_OrderId(id);
        List<Map<String, Object>> result = new ArrayList<>();
        for (OrderItem item : items) {
            Map<String, Object> m = new HashMap<>();
            m.put("productName", item.getProduct().getProductName());
            m.put("unit", item.getProduct().getUnit());
            m.put("quantity", item.getQuantity());
            m.put("unitPrice", item.getUnitPrice());
            m.put("lineTotal", item.getLineTotal());
            m.put("orderItemId", item.getOrderItemId());
            m.put("preparedStatus", item.getIsPrepared());
            result.add(m);

        }
        return result;
    }

    @PostMapping("/orders/items/{itemId}/prepare")
    @ResponseBody
    public Map<String, Object> updatePreparedStatus(@PathVariable("itemId") Integer itemId,
                                                    @RequestParam boolean prepared,
                                                    HttpSession session) {
        Map<String, Object> result = new HashMap<>();

        User user = (User) session.getAttribute("currentUser");
        Boolean isSale = (Boolean) session.getAttribute("isSalesStaff");
        if (user == null || isSale == null || !isSale) {
            result.put("success", false);
            return result;
        }

        return orderItemRepository.findById(itemId)
                .map(item -> {
                    item.setIsPrepared(prepared);
                    orderItemRepository.save(item);
                    result.put("success", true);
                    result.put("preparedStatus", item.getIsPrepared());
                    return result;
                })
                .orElseGet(() -> {
                    result.put("success", false);
                    return result;
                });
    }
    @PostMapping("/orders/{id}/confirm")
    public String confirmOrder(@PathVariable("id") Integer id, HttpSession session) {
        User user = (User) session.getAttribute("currentUser");
        Boolean isSale = (Boolean) session.getAttribute("isSalesStaff");
        if (user == null || isSale == null || !isSale) return "redirect:/login";

        orderRepository.findById(id).ifPresent(order -> {
            if ("PENDING".equals(order.getOrderStatus())) {
                order.setOrderStatus("CONFIRMED");
                orderRepository.save(order);
            }
        });
        return "redirect:/sales/orders";
    }

    @PostMapping("/orders/{id}/deliver")
    @ResponseBody
    public Map<String, Object> deliverOrder(@PathVariable("id") Integer id,
                                            @RequestParam Integer providerId,
                                            @RequestParam String shippingCode,
                                            @RequestParam String deliveryDate,
                                            HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        User user = (User) session.getAttribute("currentUser");
        Boolean isSale = (Boolean) session.getAttribute("isSalesStaff");
        if (user == null || isSale == null || !isSale) {
            result.put("success", false);
            return result;
        }

        // Validate format server-side
        Map<String, String> regexMap = new HashMap<>();
        regexMap.put("GHN",            "^GHN\\d{8}$");
        regexMap.put("GHTK",           "^GHTK\\d{8}$");
        regexMap.put("J&T Express",    "^JT\\d{10}$");
        regexMap.put("Viettel Post",   "^VTP\\d{9}$");
        regexMap.put("VNPost",         "^VN\\d{9}$");
        regexMap.put("Shopee Express", "^SPX\\d{10}$");

        // Lấy tên provider để validate
        String providerName = shippingProviderRepository.findById(providerId)
                .map(p -> p.getProviderName()).orElse("");
        String pattern = regexMap.get(providerName);
        if (pattern != null && !shippingCode.matches(pattern)) {
            result.put("success", false);
            result.put("errorCode", "INVALID_FORMAT");
            return result;
        }

        // Check trùng mã
        if (orderRepository.existsByShippingCode(shippingCode)) {
            result.put("success", false);
            result.put("errorCode", "DUPLICATE_CODE");
            return result;
        }

        return orderRepository.findById(id).map(order -> {
            shippingProviderRepository.findById(providerId).ifPresent(order::setShippingProvider);
            order.setShippingCode(shippingCode);
            order.setExpectedDeliveryDate(java.time.LocalDate.parse(deliveryDate));
            order.setOrderStatus("DELIVERING");
            orderRepository.save(order);
            result.put("success", true);
            return result;
        }).orElseGet(() -> { result.put("success", false); return result; });
    }
    @GetMapping("/orders/{id}/ready")
    @ResponseBody
    public Map<String, Object> checkOrderReady(@PathVariable("id") Integer id, HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        User user = (User) session.getAttribute("currentUser");
        Boolean isSale = (Boolean) session.getAttribute("isSalesStaff");
        if (user == null || isSale == null || !isSale) {
            result.put("ready", false);
            return result;
        }
        List<OrderItem> items = orderItemRepository.findByOrder_OrderId(id);
        boolean allReady = !items.isEmpty() && items.stream().allMatch(OrderItem::getIsPrepared);
        result.put("ready", allReady);
        return result;
    }
    @GetMapping("/shipping-providers")
    @ResponseBody
    public List<Map<String, Object>> getShippingProviders(HttpSession session) {
        User user = (User) session.getAttribute("currentUser");
        Boolean isSale = (Boolean) session.getAttribute("isSalesStaff");
        if (user == null || isSale == null || !isSale) return new ArrayList<>();

        List<Map<String, Object>> result = new ArrayList<>();
        shippingProviderRepository.findAll().forEach(sp -> {
            Map<String, Object> m = new HashMap<>();
            m.put("id", sp.getShippingProviderId());
            m.put("name", sp.getProviderName());
            result.add(m);
        });
        return result;
    }



}