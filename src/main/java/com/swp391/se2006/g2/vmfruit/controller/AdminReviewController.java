package com.swp391.se2006.g2.vmfruit.controller;

import com.swp391.se2006.g2.vmfruit.dto.response.ReviewManagePageDto;
import com.swp391.se2006.g2.vmfruit.dto.response.ReviewRowDto;
import com.swp391.se2006.g2.vmfruit.exception.AdminReviewException;
import com.swp391.se2006.g2.vmfruit.service.AdminReviewService;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping("/admin/reviews")
public class AdminReviewController {

    private final AdminReviewService adminReviewService;

    public AdminReviewController(AdminReviewService adminReviewService) {
        this.adminReviewService = adminReviewService;
    }

    @GetMapping
    public String listReviews(@RequestParam(required = false) String star,
                              @RequestParam(required = false) String sort,
                              @RequestParam(required = false) String search,
                              HttpSession session,
                              Model model) {
        ReviewManagePageDto page = adminReviewService.getReviewManagePage(star, sort, search);
        model.addAttribute("overallRating", page.getOverallRating());
        model.addAttribute("totalReviews", page.getTotalReviews());
        model.addAttribute("count5Star", page.getCount5Star());
        model.addAttribute("count4Star", page.getCount4Star());
        model.addAttribute("count3Star", page.getCount3Star());
        model.addAttribute("count2Star", page.getCount2Star());
        model.addAttribute("count1Star", page.getCount1Star());
        model.addAttribute("visibleCount", page.getVisibleCount());
        model.addAttribute("hiddenCount", page.getHiddenCount());
        model.addAttribute("reviewList", page.getReviewList());
        model.addAttribute("contentPage", "admin/reviews");
        model.addAttribute("activeMenu", "review-manage");
        return "layouts/admin-layout";
    }

    @PostMapping("/hide")
    public String hideReview(@RequestParam Integer id, RedirectAttributes redirectAttributes) {
        try {
            adminReviewService.hideReview(id);
            redirectAttributes.addFlashAttribute("success", "Review has been hidden.");
        } catch (AdminReviewException e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
        }
        return "redirect:/admin/reviews";
    }

    @PostMapping("/show")
    public String showReview(@RequestParam Integer id, RedirectAttributes redirectAttributes) {
        try {
            adminReviewService.showReview(id);
            redirectAttributes.addFlashAttribute("success", "Review is now visible.");
        } catch (AdminReviewException e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
        }
        return "redirect:/admin/reviews";
    }
}
