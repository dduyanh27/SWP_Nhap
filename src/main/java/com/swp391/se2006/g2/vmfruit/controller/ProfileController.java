package com.swp391.se2006.g2.vmfruit.controller;

import com.swp391.se2006.g2.vmfruit.dto.request.UserRequest;
import com.swp391.se2006.g2.vmfruit.entity.User;
import com.swp391.se2006.g2.vmfruit.service.UserService;
import com.swp391.se2006.g2.vmfruit.service.OrderService;
import com.swp391.se2006.g2.vmfruit.service.CustomerAddressService;
import com.swp391.se2006.g2.vmfruit.service.NotificationService;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.io.File;
import java.time.LocalDate;

@Controller
@RequestMapping("/profile")
public class ProfileController {

    private final UserService userService;
    private final OrderService orderService;
    private final CustomerAddressService addressService;
    private final NotificationService notificationService;

    public ProfileController(UserService userService, OrderService orderService,
                             CustomerAddressService addressService, NotificationService notificationService) {
        this.userService = userService;
        this.orderService = orderService;
        this.addressService = addressService;
        this.notificationService = notificationService;
    }

    @GetMapping
    public String showProfilePage(@RequestParam(value = "tab", required = false) String tab,
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
            model.addAttribute("orderList", orderService.getOrdersByUser(userId));
        } else if ("address".equals(tab)) {
            model.addAttribute("addressList", addressService.getAddressesByUserId(userId));
        } else if ("notification".equals(tab)) {
            model.addAttribute("notificationList", notificationService.getNotificationsByUser(userId));
        }

        return "profile";
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