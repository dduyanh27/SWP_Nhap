package com.swp391.se2006.g2.vmfruit.controller.admin;

import com.swp391.se2006.g2.vmfruit.dto.request.ProductRequest;
import com.swp391.se2006.g2.vmfruit.dto.response.ProductRowResponse;
import com.swp391.se2006.g2.vmfruit.dto.response.ProductStatsResponse;
import com.swp391.se2006.g2.vmfruit.entity.Category;
import com.swp391.se2006.g2.vmfruit.entity.Product;
import com.swp391.se2006.g2.vmfruit.repository.CategoryRepository;
import com.swp391.se2006.g2.vmfruit.service.AdminCategoryService;
import com.swp391.se2006.g2.vmfruit.service.AdminProductService;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Controller
@RequestMapping("/admin")
public class AdminProductController {

    private final AdminProductService adminProductService;
    private final AdminCategoryService adminCategoryService;
    private final CategoryRepository categoryRepository;

    public AdminProductController(AdminProductService adminProductService,
                                  AdminCategoryService adminCategoryService,
                                  CategoryRepository categoryRepository) {
        this.adminProductService = adminProductService;
        this.adminCategoryService = adminCategoryService;
        this.categoryRepository = categoryRepository;
    }

    @GetMapping("/products")
    public String showProductManagement(@RequestParam(value = "sort", required = false, defaultValue = "stock_asc") String sort,
                                        @RequestParam(value = "price", required = false, defaultValue = "") String price,
                                        Model model) {
        ProductStatsResponse stats = adminProductService.getProductStats();
        model.addAttribute("lowStockCount", stats.getLowStockCount());
        model.addAttribute("expiringSoonCount", stats.getExpiringSoonCount());
        model.addAttribute("hiddenCount", stats.getHiddenItemsCount());
        model.addAttribute("totalProducts", stats.getTotalProductsCount());

        List<ProductRowResponse> list = adminProductService.getAllProductRows(sort, price);
        model.addAttribute("productList", list);
        model.addAttribute("currentSort", sort);
        model.addAttribute("currentPrice", price);

        model.addAttribute("contentPage", "admin/products");
        model.addAttribute("activeMenu", "fruit-manage");
        return "layouts/admin-layout";
    }

    @GetMapping("/products/new")
    public String showAddProduct(Model model) {
        model.addAttribute("categories", getActiveCategories());
        model.addAttribute("contentPage", "admin/nproducts");
        model.addAttribute("activeMenu", "fruit-manage");
        return "layouts/admin-layout";
    }

    @GetMapping("/products/edit")
    public String showEditProduct(@RequestParam("id") Integer id, Model model) {
        try {
            Product product = adminProductService.getProductById(id);
            List<Integer> selectedCategoryIds = product.getProductCategories().stream()
                    .map(pc -> pc.getCategory().getCategoryId())
                    .collect(Collectors.toList());

            model.addAttribute("product", product);
            model.addAttribute("selectedCategoryIds", selectedCategoryIds);
            model.addAttribute("categories", getActiveCategories());
            model.addAttribute("contentPage", "admin/nproducts");
            model.addAttribute("activeMenu", "fruit-manage");
            return "layouts/admin-layout";
        } catch (RuntimeException e) {
            return "redirect:/admin/products";
        }
    }

    @GetMapping("/products/toggle")
    public String toggleProductStatus(@RequestParam("id") Integer id) {
        try {
            adminProductService.toggleProductStatus(id);
        } catch (Exception ignored) {
        }
        return "redirect:/admin/products";
    }

    @PostMapping("/categories/create")
    public String createCategory(@RequestParam("categoryName") String categoryName,
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

    @GetMapping("/products/categories")
    @ResponseBody
    public ResponseEntity<List<Map<String, Object>>> getCategories() {
        List<Map<String, Object>> result = getActiveCategories().stream()
                .map(c -> {
                    Map<String, Object> m = new HashMap<>();
                    m.put("id", c.getCategoryId());
                    m.put("name", c.getCategoryName());
                    return m;
                })
                .collect(Collectors.toList());
        return ResponseEntity.ok(result);
    }

    @GetMapping("/products/{id}")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> getProduct(@PathVariable Integer id) {
        try {
            Product p = adminProductService.getProductById(id);
            Map<String, Object> data = new HashMap<>();
            data.put("productId", p.getProductId());
            data.put("productName", p.getProductName());
            data.put("description", p.getDescription());
            data.put("imageUrl", p.getImageUrl());
            data.put("unit", p.getUnit());
            data.put("basePrice", p.getBasePrice());
            data.put("origin", p.getOrigin());
            data.put("sellingStatus", p.getSellingStatus());

            List<Integer> catIds = p.getProductCategories().stream()
                    .map(pc -> pc.getCategory().getCategoryId())
                    .collect(Collectors.toList());
            data.put("categoryIds", catIds);
            return ResponseEntity.ok(data);
        } catch (RuntimeException e) {
            return ResponseEntity.notFound().build();
        }
    }

    @PostMapping("/products/create")
    public String createProduct(@ModelAttribute ProductRequest request,
                                RedirectAttributes redirectAttributes) {
        try {
            adminProductService.createProduct(request);
            redirectAttributes.addFlashAttribute("message", "Tạo sản phẩm thành công!");
            return "redirect:/admin/products";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Lỗi: " + e.getMessage());
            return "redirect:/admin/products/new";
        }
    }

    @PostMapping("/products/update")
    public String updateProduct(@ModelAttribute ProductRequest request,
                                RedirectAttributes redirectAttributes) {
        try {
            adminProductService.updateProduct(request);
            redirectAttributes.addFlashAttribute("message", "Cập nhật sản phẩm thành công!");
            return "redirect:/admin/products";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Lỗi: " + e.getMessage());
            return "redirect:/admin/products/edit?id=" + request.getProductId();
        }
    }

    @PatchMapping("/products/{id}/toggle-status")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> toggleStatus(@PathVariable Integer id) {
        Map<String, Object> resp = new HashMap<>();
        try {
            adminProductService.toggleProductStatus(id);
            resp.put("success", true);
            resp.put("message", "Đã thay đổi trạng thái sản phẩm.");
            return ResponseEntity.ok(resp);
        } catch (Exception e) {
            resp.put("success", false);
            resp.put("message", "Lỗi: " + e.getMessage());
            return ResponseEntity.badRequest().body(resp);
        }
    }

    @DeleteMapping("/products/{id}")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> deleteProduct(@PathVariable Integer id) {
        Map<String, Object> resp = new HashMap<>();
        try {
            adminProductService.deleteProduct(id);
            resp.put("success", true);
            resp.put("message", "Xoá sản phẩm thành công!");
            return ResponseEntity.ok(resp);
        } catch (Exception e) {
            resp.put("success", false);
            resp.put("message", "Lỗi: " + e.getMessage());
            return ResponseEntity.badRequest().body(resp);
        }
    }

    private List<Category> getActiveCategories() {
        return categoryRepository.findAll().stream()
                .filter(c -> "ACTIVE".equalsIgnoreCase(c.getStatus()))
                .collect(Collectors.toList());
    }
}
