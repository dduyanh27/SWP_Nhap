package com.swp391.se2006.g2.vmfruit.controller;

import com.swp391.se2006.g2.vmfruit.dto.request.AdminUserCreateRequest;
import com.swp391.se2006.g2.vmfruit.dto.request.AdminUserUpdateRequest;
import com.swp391.se2006.g2.vmfruit.dto.response.AdminUserPageDto;
import com.swp391.se2006.g2.vmfruit.exception.AdminUserException;
import com.swp391.se2006.g2.vmfruit.service.AdminUserService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping("/admin/users")
public class AdminUserController {

    private final AdminUserService adminUserService;

    public AdminUserController(AdminUserService adminUserService) {
        this.adminUserService = adminUserService;
    }

    @GetMapping
    public String listUsers(@RequestParam(required = false) String role,
                            @RequestParam(required = false) String status,
                            Model model) {
        AdminUserPageDto page = adminUserService.getUserManagementPage(role, status);
        model.addAttribute("newUserCount", String.format("%02d", page.getNewUserCount()));
        model.addAttribute("totalCustomers", page.getTotalCustomers());
        model.addAttribute("totalStaffs", page.getTotalStaffs());
        model.addAttribute("userList", page.getUserList());
        model.addAttribute("contentPage", "admin/users");
        model.addAttribute("activeMenu", "user-manage");
        return "layouts/admin-layout";
    }

    @GetMapping("/create")
    public String showCreateForm(Model model) {
        if (!model.containsAttribute("form")) {
            AdminUserCreateRequest form = new AdminUserCreateRequest();
            form.setRole("CUSTOMER");
            form.setStatus("ACTIVE");
            model.addAttribute("form", form);
        }
        return "admin-user-create";
    }

    @PostMapping("/create")
    public String createUser(@ModelAttribute AdminUserCreateRequest request,
                             RedirectAttributes redirectAttributes) {
        try {
            adminUserService.createUser(request);
            redirectAttributes.addFlashAttribute("success", "Đã tạo người dùng mới.");
            return "redirect:/admin/users";
        } catch (AdminUserException ex) {
            redirectAttributes.addFlashAttribute("error", ex.getMessage());
            redirectAttributes.addFlashAttribute("form", request);
            return "redirect:/admin/users/create";
        }
    }

    @GetMapping("/edit")
    public String showEditForm(@RequestParam Integer id, Model model) {
        model.addAttribute("user", adminUserService.getUserForEdit(id));
        return "admin-user-edit";
    }

    @PostMapping("/edit")
    public String updateUser(@ModelAttribute AdminUserUpdateRequest request,
                             RedirectAttributes redirectAttributes) {
        try {
            adminUserService.updateUser(request);
            redirectAttributes.addFlashAttribute("success", "Đã cập nhật thông tin người dùng.");
            return "redirect:/admin/users";
        } catch (AdminUserException ex) {
            redirectAttributes.addFlashAttribute("error", ex.getMessage());
            return "redirect:/admin/users/edit?id=" + request.getUserId();
        }
    }

    @GetMapping("/lock")
    public String lockUser(@RequestParam Integer id, RedirectAttributes redirectAttributes) {
        try {
            adminUserService.lockUser(id);
            redirectAttributes.addFlashAttribute("success", "Đã khóa tài khoản.");
        } catch (AdminUserException ex) {
            redirectAttributes.addFlashAttribute("error", ex.getMessage());
        }
        return "redirect:/admin/users";
    }

    @GetMapping("/unlock")
    public String unlockUser(@RequestParam Integer id, RedirectAttributes redirectAttributes) {
        try {
            adminUserService.unlockUser(id);
            redirectAttributes.addFlashAttribute("success", "Đã mở khóa tài khoản.");
        } catch (AdminUserException ex) {
            redirectAttributes.addFlashAttribute("error", ex.getMessage());
        }
        return "redirect:/admin/users";
    }
}
