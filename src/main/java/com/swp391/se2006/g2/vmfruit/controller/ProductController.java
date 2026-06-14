package com.swp391.se2006.g2.vmfruit.controller;

import com.swp391.se2006.g2.vmfruit.dto.request.ReviewRequest;
import com.swp391.se2006.g2.vmfruit.entity.Category;
import com.swp391.se2006.g2.vmfruit.entity.Product;
import com.swp391.se2006.g2.vmfruit.entity.Review;
import com.swp391.se2006.g2.vmfruit.entity.User;
import com.swp391.se2006.g2.vmfruit.repository.CategoryRepository;
import com.swp391.se2006.g2.vmfruit.service.ReviewService;
import com.swp391.se2006.g2.vmfruit.service.ProductService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;

@Controller
public class ProductController {

    @Autowired
    private ProductService productService;

    @Autowired
    private CategoryRepository categoryRepository;

    @Autowired
    private ReviewService reviewService;

    @GetMapping("/products")
    public String productList(
            @RequestParam(required = false) Integer categoryId,
            @RequestParam(defaultValue = "0") BigDecimal minPrice,
            @RequestParam(defaultValue = "100000000") BigDecimal maxPrice,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "6") int size,
            @RequestParam(defaultValue = "basePrice") String sortBy,
            @RequestParam(defaultValue = "asc") String sortDir,
            Model model) {
        Page<Product> productPage = productService.getFilteredProducts(
                categoryId, minPrice, maxPrice, page, size, sortBy, sortDir);

        List<Category> categories = categoryRepository.findAll();

        model.addAttribute("products", productPage.getContent());
        model.addAttribute("totalPages", productPage.getTotalPages());
        model.addAttribute("currentPage", page);
        model.addAttribute("categories", categories);
        model.addAttribute("selectedCategory", categoryId);
        model.addAttribute("minPrice", minPrice);
        model.addAttribute("maxPrice", maxPrice);
        model.addAttribute("sortBy", sortBy);
        model.addAttribute("sortDir", sortDir);

        return "product-list";
    }

    @GetMapping("/products/{productId}")
    public String productDetail(@PathVariable Integer productId, Model model, HttpSession session) {
        Optional<Product> productOpt = productService.getProductById(productId);
        if (productOpt.isEmpty()) {
            return "redirect:/products";
        }

        Product product = productOpt.get();
        Double stock = productService.getProductStock(productId);
        List<Review> reviews = productService.getProductReviews(productId);
        Double avgRating = productService.getAverageRating(productId);
        long reviewCount = productService.getReviewCount(productId);

        model.addAttribute("product", product);
        model.addAttribute("stock", stock);
        model.addAttribute("reviews", reviews);
        model.addAttribute("avgRating", avgRating);
        model.addAttribute("reviewCount", reviewCount);

        User currentUser = (User) session.getAttribute("currentUser");
        boolean canReview = currentUser != null
                && !reviewService.hasReviewedProduct(currentUser.getUserId(), productId);
        model.addAttribute("canReview", canReview);
        model.addAttribute("isLoggedIn", currentUser != null);

        return "product-detail";
    }

    @PostMapping("/products/{productId}/review")
    public String submitReview(@PathVariable Integer productId,
                               @ModelAttribute ReviewRequest reviewRequest,
                               HttpSession session,
                               RedirectAttributes redirectAttributes) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null) {
            return "redirect:/login";
        }

        if (reviewRequest.getRating() == null || reviewRequest.getRating() < 1 || reviewRequest.getRating() > 5) {
            redirectAttributes.addFlashAttribute("reviewError", "Vui lòng chọn số sao đánh giá từ 1 đến 5");
            return "redirect:/products/" + productId;
        }

        if (reviewRequest.getComment() == null || reviewRequest.getComment().trim().isEmpty()) {
            redirectAttributes.addFlashAttribute("reviewError", "Vui lòng nhập nội dung đánh giá");
            return "redirect:/products/" + productId;
        }

        if (reviewService.hasReviewedProduct(currentUser.getUserId(), productId)) {
            redirectAttributes.addFlashAttribute("reviewError", "Bạn đã đánh giá sản phẩm này rồi");
            return "redirect:/products/" + productId;
        }

        try {
            reviewService.createReview(currentUser.getUserId(), productId,
                    reviewRequest.getRating(), reviewRequest.getComment().trim());
            redirectAttributes.addFlashAttribute("reviewSuccess", "Cảm ơn bạn đã đánh giá sản phẩm!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("reviewError", "Đã xảy ra lỗi khi gửi đánh giá: " + e.getMessage());
        }

        return "redirect:/products/" + productId;
    }
}
