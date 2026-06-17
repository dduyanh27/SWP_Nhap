package com.swp391.se2006.g2.vmfruit.controller.admin;

import com.swp391.se2006.g2.vmfruit.dto.request.ProductRequest;
import com.swp391.se2006.g2.vmfruit.entity.Category;
import com.swp391.se2006.g2.vmfruit.entity.Product;
import com.swp391.se2006.g2.vmfruit.entity.ProductCategory;
import com.swp391.se2006.g2.vmfruit.repository.CategoryRepository;
import com.swp391.se2006.g2.vmfruit.service.AdminProductService;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;


@Controller
@RequestMapping("/admin/products")
public class AdminProductController {

    private final AdminProductService adminProductService;
    private final CategoryRepository categoryRepository;

    public AdminProductController(AdminProductService adminProductService,
                                  CategoryRepository categoryRepository) {
        this.adminProductService = adminProductService;
        this.categoryRepository = categoryRepository;
    }

    // ── GET: lấy danh sách categories để đổ vào dropdown ──────────────
    @GetMapping("/categories")
    @ResponseBody
    public ResponseEntity<List<Map<String, Object>>> getCategories() {
        List<Map<String, Object>> result = categoryRepository.findAll().stream()
                .filter(c -> "ACTIVE".equalsIgnoreCase(c.getStatus()))
                .map(c -> {
                    Map<String, Object> m = new HashMap<>();
                    m.put("id", c.getCategoryId());
                    m.put("name", c.getCategoryName());
                    return m;
                })
                .collect(Collectors.toList());
        return ResponseEntity.ok(result);
    }

    @GetMapping("/{id}")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> getProduct(@PathVariable Integer id) {
        try {
            Product p = adminProductService.getProductById(id);
            Map<String, Object> data = new HashMap<>();
            data.put("productId",     p.getProductId());
            data.put("productName",   p.getProductName());
            data.put("description",   p.getDescription());
            data.put("imageUrl",      p.getImageUrl());
            data.put("unit",          p.getUnit());
            data.put("basePrice",     p.getBasePrice());
            data.put("origin",        p.getOrigin());
            data.put("sellingStatus", p.getSellingStatus());
            // Trả về danh sách tất cả categoryId của sản phẩm
            List<Integer> catIds = p.getProductCategories().stream()
                    .map(pc -> pc.getCategory().getCategoryId())
                    .collect(Collectors.toList());
            data.put("categoryIds", catIds);
            return ResponseEntity.ok(data);
        } catch (RuntimeException e) {
            return ResponseEntity.notFound().build();
        }
    }

    // ── POST: tạo mới sản phẩm ────────────────────────────────────────
    @PostMapping("/create")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> createProduct(@RequestBody ProductRequest request) {
        Map<String, Object> resp = new HashMap<>();
        try {
            Product saved = adminProductService.createProduct(request);
            resp.put("success", true);
            resp.put("productId", saved.getProductId());
            resp.put("message", "Tạo sản phẩm thành công!");
            return ResponseEntity.ok(resp);
        } catch (Exception e) {
            resp.put("success", false);
            resp.put("message", "Lỗi: " + e.getMessage());
            return ResponseEntity.badRequest().body(resp);
        }
    }

    // ── PUT: cập nhật sản phẩm ────────────────────────────────────────
    @PutMapping("/update")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> updateProduct(@RequestBody ProductRequest request) {
        Map<String, Object> resp = new HashMap<>();
        try {
            adminProductService.updateProduct(request);
            resp.put("success", true);
            resp.put("message", "Cập nhật sản phẩm thành công!");
            return ResponseEntity.ok(resp);
        } catch (Exception e) {
            resp.put("success", false);
            resp.put("message", "Lỗi: " + e.getMessage());
            return ResponseEntity.badRequest().body(resp);
        }
    }

    // ── PATCH: toggle trạng thái ẩn/hiện ────────────────────────────
    @PatchMapping("/{id}/toggle-status")
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

    // ── DELETE: xoá sản phẩm ─────────────────────────────────────────
    @DeleteMapping("/{id}")
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
}
