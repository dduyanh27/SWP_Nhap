package com.swp391.se2006.g2.vmfruit.controller;

import com.swp391.se2006.g2.vmfruit.entity.User;
import com.swp391.se2006.g2.vmfruit.service.CartService;
import jakarta.servlet.http.HttpSession;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.math.BigDecimal;
import java.util.Map;
@Controller
@RequestMapping("/cart")
public class CartController {

    private final CartService cartService;

    public CartController(CartService cartService) {
        this.cartService = cartService;
    }

    private User getCurrentUser(HttpSession session) {
        return (User) session.getAttribute("currentUser");
    }

    @GetMapping("/count")
    @ResponseBody
    public ResponseEntity<Map<String, Long>> getCartCount(HttpSession session) {
        User user = getCurrentUser(session);
        if (user == null) {
            return ResponseEntity.ok(Map.of("count", 0L));
        }
        long count = cartService.countCartItems(user.getUserId());
        return ResponseEntity.ok(Map.of("count", count));
    }

    @GetMapping
    public String viewCart(Model model, HttpSession session) {
        User user = getCurrentUser(session);
        if (user == null) return "redirect:/login";

        model.addAttribute("cartItems", cartService.getCartItemsByEmail(user.getEmail()));
        model.addAttribute("cartTotal", cartService.getCartTotal(user.getUserId()));
        model.addAttribute("cartCount", cartService.countCartItems(user.getUserId()));
        return "cart";
    }

    @PostMapping("/add")
    public String addToCart(@RequestParam Integer productId,
                            @RequestParam(defaultValue = "1") BigDecimal quantity,
                            HttpSession session,
                            RedirectAttributes redirectAttributes) {
        User user = getCurrentUser(session);
        if (user == null) return "redirect:/login";

        try {
            cartService.addToCart(user.getUserId(), productId, quantity);
            redirectAttributes.addFlashAttribute("successMessage", "Đã thêm sản phẩm vào giỏ hàng!");
        } catch (RuntimeException e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
        }
        return "redirect:/cart";
    }


    @PostMapping("/update/{cartItemId}")
    public String updateQuantity(@PathVariable Integer cartItemId,
                                 @RequestParam BigDecimal quantity,
                                 HttpSession session,
                                 RedirectAttributes redirectAttributes) {
        User user = getCurrentUser(session);
        if (user == null) return "redirect:/login";

        try {
            cartService.updateQuantity(cartItemId, quantity);
        } catch (RuntimeException e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
        }
        return "redirect:/cart";
    }

    @PostMapping("/remove/{cartItemId}")
    public String removeFromCart(@PathVariable Integer cartItemId,
                                 HttpSession session,
                                 RedirectAttributes redirectAttributes) {
        User user = getCurrentUser(session);
        if (user == null) return "redirect:/login";

        try {
            cartService.removeCartItem(cartItemId);
        } catch (RuntimeException e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
        }
        return "redirect:/cart";
    }
}