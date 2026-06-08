package com.swp391.se2006.g2.vmfruit.controller;

import com.swp391.se2006.g2.vmfruit.dto.response.ProductRowResponse;
import com.swp391.se2006.g2.vmfruit.dto.response.ProductStatsResponse;
import com.swp391.se2006.g2.vmfruit.service.AdminProductService;
import com.swp391.se2006.g2.vmfruit.service.AdminService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/admin")
public class AdminController {

    private final AdminService adminService;
    private final AdminProductService adminProductService;

    public AdminController(AdminService adminService, AdminProductService adminProductService) {
        this.adminService = adminService;
        this.adminProductService = adminProductService;
    }

    @GetMapping("/dashboard")
    public String showDashboard(Model model) {
        Map<String, Object> stats = adminService.getDashboardStats();
        model.addAllAttributes(stats);
        model.addAttribute("contentPage", "admin/dashboard");
        model.addAttribute("activeMenu", "dashboard");
        return "layouts/admin-layout";
    }

    @GetMapping("/products")
    public String showProductManagement(Model model) {
        ProductStatsResponse stats = adminProductService.getProductStats();
        model.addAttribute("lowStockCount", stats.getLowStockCount());
        model.addAttribute("expiringSoonCount", stats.getExpiringSoonCount());
        model.addAttribute("hiddenCount", stats.getHiddenItemsCount());
        model.addAttribute("totalProducts", stats.getTotalProductsCount());

        List<ProductRowResponse> list = adminProductService.getAllProductRows();

        model.addAttribute("productList", list);
        model.addAttribute("contentPage", "admin/products");
        model.addAttribute("activeMenu", "fruit-manage");
        return "layouts/admin-layout";
    }

    @GetMapping("/users")
    public String showUsers(Model model) {
        model.addAttribute("contentPage", "admin/users");
        model.addAttribute("activeMenu", "user-manage");
        return "layouts/admin-layout";
    }

    @GetMapping("/orders")
    public String showOrders(Model model) {
        model.addAttribute("contentPage", "admin/orders");
        model.addAttribute("activeMenu", "order-manage");
        return "layouts/admin-layout";
    }

    @GetMapping("/reviews")
    public String showReviews(Model model) {
        model.addAttribute("contentPage", "admin/reviews");
        model.addAttribute("activeMenu", "review-manage");
        return "layouts/admin-layout";
    }

    @GetMapping("/discounts")
    public String showDiscounts(Model model) {
        model.addAttribute("contentPage", "admin/discounts");
        model.addAttribute("activeMenu", "discount-code");
        return "layouts/admin-layout";
    }

    @GetMapping("/payments")
    public String showPayments(Model model) {
        model.addAttribute("contentPage", "admin/payments");
        model.addAttribute("activeMenu", "payment-manage");
        return "layouts/admin-layout";
    }

    @GetMapping("/reports")
    public String showReports(Model model) {
        model.addAttribute("contentPage", "admin/reports");
        model.addAttribute("activeMenu", "report-manage");
        return "layouts/admin-layout";
    }
}
