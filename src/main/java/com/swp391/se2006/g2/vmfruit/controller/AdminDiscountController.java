package com.swp391.se2006.g2.vmfruit.controller;

import com.swp391.se2006.g2.vmfruit.entity.DiscountCode;
import com.swp391.se2006.g2.vmfruit.entity.User;
import com.swp391.se2006.g2.vmfruit.exception.AdminUserException;
import com.swp391.se2006.g2.vmfruit.repository.DiscountCodeRepository;
import com.swp391.se2006.g2.vmfruit.service.AdminDiscountService;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.math.BigDecimal;

@Controller
@RequestMapping("/admin/discounts")
public class AdminDiscountController {

    private final AdminDiscountService adminDiscountService;
    private final DiscountCodeRepository discountCodeRepository;

    public AdminDiscountController(AdminDiscountService adminDiscountService,
                                   DiscountCodeRepository discountCodeRepository) {
        this.adminDiscountService = adminDiscountService;
        this.discountCodeRepository = discountCodeRepository;
    }

    @GetMapping
    public String listDiscounts(@RequestParam(required = false) String sort,
                                HttpSession session,
                                Model model) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null) {
            return "redirect:/login";
        }

        model.addAttribute("discounts", adminDiscountService.getAllDiscounts(sort));
        model.addAttribute("activeCount", adminDiscountService.getActiveCount());
        model.addAttribute("expiredCount", adminDiscountService.getExpiredCount());
        model.addAttribute("totalCount", adminDiscountService.getTotalCount());
        model.addAttribute("currentSort", sort);
        model.addAttribute("contentPage", "admin/discounts");
        model.addAttribute("activeMenu", "discount-code");
        return "layouts/admin-layout";
    }

    @GetMapping("/create")
    public String showCreateForm(Model model) {
        if (!model.containsAttribute("discount")) {
            DiscountCode discount = new DiscountCode();
            discount.setDiscountType("PERCENTAGE");
            discount.setTargetUserType("ALL");
            discount.setMinOrderAmount(BigDecimal.ZERO);
            model.addAttribute("discount", discount);
        }
        model.addAttribute("contentPage", "admin/discount-form");
        model.addAttribute("activeMenu", "discount-code");
        return "layouts/admin-layout";
    }

    @PostMapping("/create")
    public String createDiscount(@ModelAttribute DiscountCode discount,
                                 RedirectAttributes redirectAttributes) {
        try {
            adminDiscountService.createDiscount(discount);
            redirectAttributes.addFlashAttribute("success", "Đã tạo mã giảm giá mới.");
            return "redirect:/admin/discounts";
        } catch (AdminUserException ex) {
            redirectAttributes.addFlashAttribute("error", ex.getMessage());
            redirectAttributes.addFlashAttribute("discount", discount);
            return "redirect:/admin/discounts/create";
        }
    }

    @GetMapping("/edit")
    public String showEditForm(@RequestParam Integer id, Model model) {
        try {
            model.addAttribute("discount", adminDiscountService.getDiscountById(id));
            model.addAttribute("contentPage", "admin/discount-form");
            model.addAttribute("activeMenu", "discount-code");
            return "layouts/admin-layout";
        } catch (AdminUserException e) {
            return "redirect:/admin/discounts";
        }
    }

    @PostMapping("/edit")
    public String updateDiscount(@ModelAttribute DiscountCode discount,
                                 RedirectAttributes redirectAttributes) {
        try {
            adminDiscountService.updateDiscount(discount);
            redirectAttributes.addFlashAttribute("success", "Đã cập nhật mã giảm giá.");
            return "redirect:/admin/discounts";
        } catch (AdminUserException ex) {
            redirectAttributes.addFlashAttribute("error", ex.getMessage());
            return "redirect:/admin/discounts/edit?id=" + discount.getDiscountId();
        }
    }

    @GetMapping("/toggle")
    public String toggleDiscount(@RequestParam Integer id,
                                 RedirectAttributes redirectAttributes) {
        try {
            DiscountCode dc = adminDiscountService.getDiscountById(id);
            adminDiscountService.toggleStatus(id);
            String msg = "ACTIVE".equalsIgnoreCase(dc.getStatus())
                    ? "Đã vô hiệu hóa mã giảm giá."
                    : "Đã kích hoạt mã giảm giá.";
            redirectAttributes.addFlashAttribute("success", msg);
        } catch (AdminUserException ex) {
            redirectAttributes.addFlashAttribute("error", ex.getMessage());
        }
        return "redirect:/admin/discounts";
    }

}
