package com.swp391.se2006.g2.vmfruit.controller;

import com.swp391.se2006.g2.vmfruit.dto.request.UserRequest;
import com.swp391.se2006.g2.vmfruit.dto.response.OrderItemDTO;
import com.swp391.se2006.g2.vmfruit.entity.Order;
import com.swp391.se2006.g2.vmfruit.entity.User;
import com.swp391.se2006.g2.vmfruit.repository.OrderItemRepository;
import com.swp391.se2006.g2.vmfruit.service.UserService;
import com.swp391.se2006.g2.vmfruit.service.CustomerAddressService;
import com.swp391.se2006.g2.vmfruit.service.NotificationService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import com.swp391.se2006.g2.vmfruit.service.OrderService;
import java.io.File;
import java.time.LocalDate;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/profile")
public class ProfileController {

    private final UserService userService;
    private final OrderService orderService;
    private final CustomerAddressService addressService;
    private final NotificationService notificationService;
    private final OrderItemRepository orderItemRepository;

    public ProfileController(UserService userService, OrderService orderService,
                             CustomerAddressService addressService,
                             NotificationService notificationService,
                             OrderItemRepository orderItemRepository) {
        this.userService = userService;
        this.orderService = orderService;
        this.addressService = addressService;
        this.notificationService = notificationService;
        this.orderItemRepository = orderItemRepository;
    }
    @GetMapping
    public String showProfilePage(@RequestParam(value = "tab", required = false) String tab,
                                  @RequestParam(value = "status", required = false) String status,
                                  HttpSession session, Model model) {
        User currentUser = (User) session.getAttribute("currentUser");

        if (currentUser == null) {
            return "redirect:/login";
        }

        Integer userId = currentUser.getUserId();
        User user = userService.getUserById(userId);

        if (user == null) {
            return "redirect:/login";
        }

        model.addAttribute("user", user);
        model.addAttribute("tab", tab != null ? tab : "profile");

        if ("orders".equals(tab)) {
            if (status == null || status.isBlank()) {
                // Tất cả đơn hàng
                model.addAttribute("orderList", orderService.getOrdersByUser(userId));
            } else if ("PENDING".equals(status)) {
                // Chờ xác nhận = PENDING + CONFIRMED
                model.addAttribute("orderList", orderService.getOrdersByUserAndStatuses(userId,
                        Arrays.asList("PENDING", "CONFIRMED")));
            } else if ("SHIPPING".equals(status)) {
                // Đang giao = DELIVERING
                model.addAttribute("orderList", orderService.getOrdersByUserAndStatus(userId, "DELIVERING"));
            } else if ("DELIVERED".equals(status)) {
                // Hoàn thành = COMPLETED
                model.addAttribute("orderList", orderService.getOrdersByUserAndStatus(userId, "COMPLETED"));
            } else {
                model.addAttribute("orderList", orderService.getOrdersByUserAndStatus(userId, status));
            }
        } else if ("address".equals(tab)) {
            model.addAttribute("addressList", addressService.getAddressesByUserId(userId));
        } else if ("notification".equals(tab)) {
            model.addAttribute("notificationList", notificationService.getNotificationsByUser(userId));
        }

        return "profile";
    }

    @GetMapping("/orders/{orderId}/details")
    @ResponseBody
    public ResponseEntity<?> getOrderDetails(@PathVariable Integer orderId, HttpSession session) {
        User currentUser = (User) session.getAttribute("currentUser");

        if (currentUser == null) {
            return ResponseEntity.status(401).body(Map.of("error", "Bạn cần đăng nhập"));
        }

        try {
            Order order = orderService.getOrderById(orderId);

            if (order == null) {
                return ResponseEntity.notFound().build();
            }


            if (order.getUser() == null || !order.getUser().getUserId().equals(currentUser.getUserId()))  {
                return ResponseEntity.status(403).body(Map.of("error", "Bạn không có quyền xem đơn hàng này"));
            }

            List<OrderItemDTO> items = orderItemRepository.findByOrder_OrderId(orderId)
                    .stream()
                    .map(item -> new OrderItemDTO(
                            item.getProduct().getProductName(),
                            item.getQuantity(),
                            item.getUnitPrice(),
                            item.getLineTotal()
                    ))
                    .toList();
            Map<String, Object> response = new HashMap<>();
            response.put("orderId", order.getOrderId());
            response.put("orderStatus", formatOrderStatus(order.getOrderStatus()));
            response.put("totalAmount", order.getTotalAmount());
            response.put("items", items);

            return ResponseEntity.ok(response);

        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(500).body(Map.of("error", "Lỗi khi tải chi tiết đơn hàng: " + e.getMessage()));
        }
    }


    private String formatOrderStatus(String status) {
        if (status == null) return "N/A";

        return switch (status) {
            case "PENDING", "PENDING_APPROVAL" -> "Chờ xác nhận";
            case "CONFIRMED" -> "Đã xác nhận";
            case "SHIPPING", "DELIVERING" -> "Đang giao";
            case "DELIVERED", "COMPLETED" -> "Hoàn thành";
            case "CANCELLED" -> "Đã hủy";
            default -> status;
        };
    }

    @PostMapping("/update")
    public String updateProfile(
            @RequestParam("fullName") String fullName,
            @RequestParam(value = "gender", required = false) String gender,
            @RequestParam(value = "dateOfBirth", required = false) String dateOfBirthStr,
            @RequestParam(value = "phone", required = false) String phone,
            @RequestParam(value = "avatarFile", required = false) MultipartFile avatarFile,
            HttpSession session,
            HttpServletRequest requestHttp,
            RedirectAttributes redirectAttributes) {

        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null) {
            return "redirect:/login";
        }

        Integer userId = currentUser.getUserId();

        try {
            UserRequest request = new UserRequest();
            request.setFullName(fullName);
            request.setGender(gender);
            request.setPhoneNumber(phone);

            if (dateOfBirthStr != null && !dateOfBirthStr.isEmpty()) {
                request.setDateOfBirth(LocalDate.parse(dateOfBirthStr));
            }

            String avatarUrl = null;
            if (avatarFile != null && !avatarFile.isEmpty()) {
                String fileName = System.currentTimeMillis() + "_" + avatarFile.getOriginalFilename();
                String uploadDir = requestHttp.getServletContext().getRealPath("/images/avatars/");
                File dir = new File(uploadDir);
                if (!dir.exists()) {
                    dir.mkdirs();
                }

                File serverFile = new File(dir.getAbsolutePath() + File.separator + fileName);
                avatarFile.transferTo(serverFile);
                avatarUrl = "/images/avatars/" + fileName;
            }

            userService.updateUserProfile(userId, request, avatarUrl);

            // Cập nhật lại session
            User updatedUser = userService.getUserById(userId);
            session.setAttribute("currentUser", updatedUser);

            redirectAttributes.addFlashAttribute("successMessage", "Cập nhật hồ sơ thành công!");
        } catch (Exception e) {
            e.printStackTrace();
            redirectAttributes.addFlashAttribute("errorMessage", "Cập nhật thất bại: " + e.getMessage());
        }

        return "redirect:/profile";
    }

    @PostMapping("/change-password")
    public String changePassword(
            @RequestParam("oldPassword") String oldPassword,
            @RequestParam("newPassword") String newPassword,
            @RequestParam("confirmPassword") String confirmPassword,
            HttpSession session,
            RedirectAttributes redirectAttributes) {

        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null) {
            return "redirect:/login";
        }

        Integer userId = currentUser.getUserId();

        if (!newPassword.equals(confirmPassword)) {
            redirectAttributes.addFlashAttribute("errorMessage", "Mật khẩu xác nhận không khớp!");
            return "redirect:/profile?tab=password";
        }

        if (newPassword == null || newPassword.length() < 8) {
            redirectAttributes.addFlashAttribute("errorMessage", "Mật khẩu mới phải có tối thiểu 8 ký tự!");
            return "redirect:/profile?tab=password";
        }

        try {
            userService.changePassword(userId, oldPassword, newPassword);
            redirectAttributes.addFlashAttribute("successMessage", "Đổi mật khẩu thành công!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
        }

        return "redirect:/profile?tab=password";
    }

    @PostMapping("/address/add")
    public String addAddress(
            @RequestParam("receiverName") String receiverName,
            @RequestParam("phone") String phone,
            @RequestParam("fullAddress") String fullAddress,
            @RequestParam(value = "isDefault", required = false) String isDefault,
            HttpSession session,
            RedirectAttributes redirectAttributes) {

        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null) {
            return "redirect:/login";
        }

        try {
            addressService.addAddress(currentUser.getUserId(), receiverName, phone, fullAddress, "1".equals(isDefault));
            redirectAttributes.addFlashAttribute("successMessage", "Thêm địa chỉ thành công!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Thêm địa chỉ thất bại: " + e.getMessage());
        }

        return "redirect:/profile?tab=address";
    }

    @PostMapping("/address/delete/{addressId}")
    public String deleteAddress(
            @PathVariable Integer addressId,
            HttpSession session,
            RedirectAttributes redirectAttributes) {

        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null) {
            return "redirect:/login";
        }

        try {
            addressService.deleteAddress(addressId);
            redirectAttributes.addFlashAttribute("successMessage", "Xóa địa chỉ thành công!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Xóa địa chỉ thất bại: " + e.getMessage());
        }

        return "redirect:/profile?tab=address";
    }
}