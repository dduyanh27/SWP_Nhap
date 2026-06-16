package com.swp391.se2006.g2.vmfruit.controller.admin;

import com.swp391.se2006.g2.vmfruit.dto.response.BatchStatsResponse;
import com.swp391.se2006.g2.vmfruit.dto.response.ProductRowResponse;
import com.swp391.se2006.g2.vmfruit.dto.response.ProductStatsResponse;
import com.swp391.se2006.g2.vmfruit.entity.Category;
import com.swp391.se2006.g2.vmfruit.entity.Product;
import com.swp391.se2006.g2.vmfruit.entity.User;
import com.swp391.se2006.g2.vmfruit.repository.CategoryRepository;
import com.swp391.se2006.g2.vmfruit.service.AdminBatchService;
import com.swp391.se2006.g2.vmfruit.service.AdminCategoryService;
import com.swp391.se2006.g2.vmfruit.service.AdminProductService;
import com.swp391.se2006.g2.vmfruit.service.AdminService;
import com.swp391.se2006.g2.vmfruit.service.UserService;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Controller
@RequestMapping("/admin")
public class AdminController {

    private final AdminService adminService;
    private final AdminProductService adminProductService;
    private final UserService userService;
    private final AdminBatchService adminBatchService;
    private final CategoryRepository categoryRepository;
    private final AdminCategoryService adminCategoryService;

    public AdminController(AdminService adminService,
                           AdminProductService adminProductService,
                           UserService userService,
                           AdminBatchService adminBatchService,
                           CategoryRepository categoryRepository,
                           AdminCategoryService adminCategoryService) {
        this.adminService           = adminService;
        this.adminProductService    = adminProductService;
        this.userService            = userService;
        this.adminBatchService      = adminBatchService;
        this.categoryRepository     = categoryRepository;
        this.adminCategoryService   = adminCategoryService;
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

    @GetMapping("/products")
    public String showProductManagement(@RequestParam(value = "sort",  required = false, defaultValue = "stock_asc") String sort,
                                        @RequestParam(value = "price", required = false, defaultValue = "")          String price,
                                        Model model) {
        ProductStatsResponse stats = adminProductService.getProductStats();
        model.addAttribute("lowStockCount",    stats.getLowStockCount());
        model.addAttribute("expiringSoonCount", stats.getExpiringSoonCount());
        model.addAttribute("hiddenCount",      stats.getHiddenItemsCount());
        model.addAttribute("totalProducts",    stats.getTotalProductsCount());

        List<ProductRowResponse> list = adminProductService.getAllProductRows(sort, price);
        model.addAttribute("productList", list);

        // Giữ lại giá trị đã chọn để JSP hiển thị đúng option
        model.addAttribute("currentSort",  sort);
        model.addAttribute("currentPrice", price);

        model.addAttribute("contentPage", "admin/products");
        model.addAttribute("activeMenu", "fruit-manage");
        return "layouts/admin-layout";
    }

    @GetMapping("/products/new")
    public String showAddProduct(Model model) {
        List<Category> categories = categoryRepository.findAll()
                .stream()
                .filter(c -> "ACTIVE".equalsIgnoreCase(c.getStatus()))
                .collect(Collectors.toList());
        model.addAttribute("categories", categories);
        model.addAttribute("contentPage", "admin/nproducts");
        model.addAttribute("activeMenu", "fruit-manage");
        return "layouts/admin-layout";
    }

    @GetMapping("/products/toggle")
    public String toggleProductStatus(@RequestParam("id") Integer id) {
        try {
            adminProductService.toggleProductStatus(id);
        } catch (Exception ignored) {}
        return "redirect:/admin/products";
    }

    /**
     * POST /admin/categories/create
     * Tạo category mới rồi redirect về trang New/Edit Product.
     * Tham số "returnId" nếu có → redirect về trang Edit Product (id=returnId).
     */
    @PostMapping("/categories/create")
    public String createCategory(@RequestParam("categoryName")           String categoryName,
                                 @RequestParam(value = "returnId", required = false) Integer returnId,
                                 RedirectAttributes redirectAttributes) {
        try {
            adminCategoryService.createCategory(categoryName);
            redirectAttributes.addFlashAttribute("catMsg", "Category \"" + categoryName.trim() + "\" đã được tạo!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("catError", "Lỗi: " + e.getMessage());
        }

        if (returnId != null) {
            return "redirect:/admin/products/edit?id=" + returnId;
        }
        return "redirect:/admin/products/new";
    }

    @GetMapping("/products/edit")
    public String showEditProduct(@RequestParam("id") Integer id, Model model) {
        try {
            Product product = adminProductService.getProductById(id);

            List<Integer> selectedCategoryIds = product.getProductCategories().stream()
                    .map(pc -> pc.getCategory().getCategoryId())
                    .collect(Collectors.toList());

            List<Category> categories = categoryRepository.findAll()
                    .stream()
                    .filter(c -> "ACTIVE".equalsIgnoreCase(c.getStatus()))
                    .collect(Collectors.toList());

            model.addAttribute("product", product);
            model.addAttribute("selectedCategoryIds", selectedCategoryIds);
            model.addAttribute("categories", categories);
            model.addAttribute("contentPage", "admin/nproducts");
            model.addAttribute("activeMenu", "fruit-manage");
            return "layouts/admin-layout";
        } catch (RuntimeException e) {
            return "redirect:/admin/products";
        }

    }

    @GetMapping("/batches")
    public String showBatchManagement(Model model) {
        BatchStatsResponse stats = adminBatchService.getBatchStats();
        model.addAttribute("activeBatchesCount",   stats.getActiveBatchesCount());
        model.addAttribute("expiringBatchesCount", stats.getExpiringBatchesCount());
        model.addAttribute("liquidatedLotsCount",  stats.getLiquidatedLotsCount());
        List<com.swp391.se2006.g2.vmfruit.dto.response.BatchGroupResponse> batchList =
                adminBatchService.getBatchManagementData();
        model.addAttribute("batchGroups", batchList);
        model.addAttribute("contentPage", "admin/batches");
        model.addAttribute("activeMenu", "batch-manage");
        return "layouts/admin-layout";
    }

//    @GetMapping("/orders")
//    public String showOrders(Model model) {
//        model.addAttribute("contentPage", "admin/orders");
//        model.addAttribute("activeMenu", "order-manage");
//        return "layouts/admin-layout";
//    }

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
