package com.swp391.se2006.g2.vmfruit.controller.sales;

import com.swp391.se2006.g2.vmfruit.entity.Notification;
import com.swp391.se2006.g2.vmfruit.entity.Order;
import com.swp391.se2006.g2.vmfruit.entity.OrderItem;
import com.swp391.se2006.g2.vmfruit.entity.User;
import com.swp391.se2006.g2.vmfruit.repository.NotificationRepository;
import com.swp391.se2006.g2.vmfruit.repository.OrderItemRepository;
import com.swp391.se2006.g2.vmfruit.repository.OrderRepository;
import com.swp391.se2006.g2.vmfruit.service.SalesImportService;
import com.swp391.se2006.g2.vmfruit.repository.ShippingProviderRepository;
import jakarta.servlet.http.HttpSession;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import com.swp391.se2006.g2.vmfruit.entity.ShippingProvider;
import com.swp391.se2006.g2.vmfruit.repository.ShippingProviderRepository;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
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
    private final SalesImportService salesImportService;
    private final NotificationRepository notificationRepository;
    // ✅ Chỉ 1 constructor duy nhất, đủ 4 tham số
    public SalesController(OrderRepository orderRepository,
                           OrderItemRepository orderItemRepository,
                           ShippingProviderRepository shippingProviderRepository,
                           SalesImportService salesImportService,
                           NotificationRepository notificationRepository) {
        this.orderRepository = orderRepository;
        this.orderItemRepository = orderItemRepository;
        this.shippingProviderRepository = shippingProviderRepository;
        this.salesImportService = salesImportService;
        this.notificationRepository = notificationRepository;
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

    @GetMapping("/imports/process")
    public String importProcessPage(@RequestParam(value = "id", required = false) Integer receiptId,
                                    HttpSession session,
                                    Model model) {
        User user = (User) session.getAttribute("currentUser");
        Boolean isSale = (Boolean) session.getAttribute("isSalesStaff");
        if (user == null || isSale == null || !isSale) return "redirect:/login";
        if (receiptId == null) return "redirect:/sales/imports";

        return salesImportService.getProcessPage(receiptId)
                .map(processPage -> {
                    model.addAttribute("user", user);
                    model.addAttribute("importProcess", processPage);
                    return "sales/import-process";
                })
                .orElse("redirect:/sales/imports");
    }

    @PostMapping("/imports/process")
    public String confirmImportProcess(@RequestParam Integer importReceiptId,
                                       @RequestParam List<Integer> importDetailIds,
                                       @RequestParam List<BigDecimal> actualQuantities,
                                       @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) List<LocalDate> expiryDates,
                                       @RequestParam(required = false) String inspectionNote,
                                       HttpSession session,
                                       RedirectAttributes redirectAttributes) {
        User user = (User) session.getAttribute("currentUser");
        Boolean isSale = (Boolean) session.getAttribute("isSalesStaff");
        if (user == null || isSale == null || !isSale) return "redirect:/login";

        try {
            salesImportService.confirmImportProcess(importReceiptId, importDetailIds, actualQuantities,
                    expiryDates, inspectionNote, user);
            redirectAttributes.addFlashAttribute("successMessage", "Import receipt processed successfully.");
            return "redirect:/sales/imports";
        } catch (RuntimeException ex) {
            redirectAttributes.addFlashAttribute("errorMessage", ex.getMessage());
            return "redirect:/sales/imports/process?id=" + importReceiptId;
        }
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

    // ===== HỦY ĐƠN (PENDING → CANCELLED) =====
    @PostMapping("/orders/{id}/cancel")
    public String cancelOrder(@PathVariable("id") Integer id, HttpSession session) {
        User user = (User) session.getAttribute("currentUser");
        Boolean isSale = (Boolean) session.getAttribute("isSalesStaff");
        if (user == null || isSale == null || !isSale) return "redirect:/login";

        orderRepository.findById(id).ifPresent(order -> {
            if ("PENDING".equals(order.getOrderStatus())) {
                order.setOrderStatus("CANCELLED");
                orderRepository.save(order);

                Notification noti = new Notification();
                noti.setUser(order.getUser());
                noti.setTitle("Đơn hàng #" + id + " đã bị hủy");
                noti.setMessage("Đơn hàng #" + id + " của bạn đã bị hủy bởi nhân viên.");
                noti.setType("ORDER");
                noti.setIsRead(false);
                noti.setCreatedAt(LocalDateTime.now());
                notificationRepository.save(noti);
            }
        });
        return "redirect:/sales/orders";
    }
    @GetMapping("/orders/{id}/detail")
    @ResponseBody
    public Map<String, Object> getOrderDetail(@PathVariable("id") Integer id, HttpSession session) {
        Map<String, Object> result = new HashMap<>();

        User user = (User) session.getAttribute("currentUser");
        Boolean isSale = (Boolean) session.getAttribute("isSalesStaff");
        if (user == null || isSale == null || !isSale) {
            result.put("success", false);
            return result;
        }

        Order order = orderRepository.findById(id).orElse(null);
        if (order == null) {
            result.put("success", false);
            return result;
        }

        result.put("success", true);
        result.put("orderId", order.getOrderId());
        result.put("customerName", order.getUser().getFullName());
        result.put("customerPhone", order.getUser().getPhone());
        result.put("customerEmail", order.getUser().getEmail());
        result.put("receiverName", order.getAddress().getReceiverName());
        result.put("receiverPhone", order.getAddress().getPhone());
        result.put("address", order.getAddress().getFullAddress());
        result.put("orderDate", order.getOrderDate().toString());
        result.put("orderStatus", order.getOrderStatus());
        result.put("paymentStatus", order.getPaymentStatus());
        result.put("subtotalAmount", order.getSubtotalAmount());
        result.put("shippingFee", order.getShippingFee());
        result.put("totalAmount", order.getTotalAmount());
        result.put("expectedDeliveryDate", order.getExpectedDeliveryDate() != null ? order.getExpectedDeliveryDate().toString() : "");
        result.put("shippingCode", order.getShippingCode() != null ? order.getShippingCode() : "");
        result.put("shippingProvider", order.getShippingProvider() != null ? order.getShippingProvider().getProviderName() : "");
        result.put("discountCode", order.getDiscount() != null ? order.getDiscount().getCode() : "");

        List<Map<String, Object>> items = new ArrayList<>();
        for (OrderItem item : orderItemRepository.findByOrder_OrderId(id)) {
            Map<String, Object> m = new HashMap<>();
            m.put("productName", item.getProduct().getProductName());
            m.put("origin", item.getProduct().getOrigin());
            m.put("unit", item.getProduct().getUnit());
            m.put("quantity", item.getQuantity());
            m.put("unitPrice", item.getUnitPrice());
            m.put("lineTotal", item.getLineTotal());
            items.add(m);
        }
        result.put("items", items);

        return result;
    }
    @PostMapping("/orders/{id}/complete")
    public String completeOrder(@PathVariable("id") Integer id, HttpSession session) {
        User user = (User) session.getAttribute("currentUser");
        Boolean isSale = (Boolean) session.getAttribute("isSalesStaff");
        if (user == null || isSale == null || !isSale) return "redirect:/login";

        orderRepository.findById(id).ifPresent(order -> {
            if ("DELIVERING".equals(order.getOrderStatus())) {
                // ✅ Chỉ gửi thông báo, KHÔNG đổi status
                Notification noti = new Notification();
                noti.setUser(order.getUser());
                noti.setTitle("Hàng đã đến nơi! 🎉");
                noti.setMessage("Đơn hàng #" + id + " đã được giao đến nơi. Vui lòng xác nhận đã nhận hàng!");
                noti.setType("ORDER");
                noti.setIsRead(false);
                noti.setCreatedAt(LocalDateTime.now());
                notificationRepository.save(noti);
            }
        });
        return "redirect:/sales/orders";
    }
}
