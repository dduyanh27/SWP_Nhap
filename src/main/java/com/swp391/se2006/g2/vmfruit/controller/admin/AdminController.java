package com.swp391.se2006.g2.vmfruit.controller.admin;

import com.swp391.se2006.g2.vmfruit.entity.User;
import com.swp391.se2006.g2.vmfruit.service.AdminService;
import com.swp391.se2006.g2.vmfruit.service.UserService;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.Map;

@Controller
@RequestMapping("/admin")
public class AdminController {

    private final AdminService adminService;
    private final UserService userService;

    public AdminController(AdminService adminService,
                           UserService userService) {
        this.adminService = adminService;
        this.userService = userService;
    }

    @GetMapping("/dashboard")
    public String showDashboard(HttpSession session, Model model) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null) {
            return "redirect:/login";
        }
        if (!userService.isAdmin(currentUser.getUserId())) {
            return "redirect:/login";
        }
        Map<String, Object> stats = adminService.getDashboardStats();
        model.addAllAttributes(stats);
        model.addAttribute("contentPage", "admin/dashboard");
        model.addAttribute("activeMenu", "dashboard");
        return "layouts/admin-layout";
    }

    @GetMapping("/payments")
    public String showPayments(Model model) {
        model.addAttribute("contentPage", "admin/payments");
        model.addAttribute("activeMenu", "payment-manage");
        return "layouts/admin-layout";
    }
}
