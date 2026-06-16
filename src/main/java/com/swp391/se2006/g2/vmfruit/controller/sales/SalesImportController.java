package com.swp391.se2006.g2.vmfruit.controller.sales;

import com.swp391.se2006.g2.vmfruit.dto.response.ImportReceiptRowResponse;
import com.swp391.se2006.g2.vmfruit.entity.User;
import com.swp391.se2006.g2.vmfruit.service.SalesImportService; // Gọi sang Service mới của Sales
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.List;

@Controller
@RequestMapping("/sales")
public class SalesImportController {

    private final SalesImportService salesImportService;

    public SalesImportController(SalesImportService salesImportService) {
        this.salesImportService = salesImportService;
    }

    @GetMapping("/imports")
    public String showPendingImports(HttpSession session, Model model) {
        User user = (User) session.getAttribute("currentUser");
        Boolean isSale = (Boolean) session.getAttribute("isSalesStaff");
        if (user == null || isSale == null || !isSale) {
            return "redirect:/login";
        }

        List<ImportReceiptRowResponse> pendingReceipts = salesImportService.getPendingImportsForSales();
        long pendingCount = salesImportService.getPendingCount();

        model.addAttribute("user", user);
        model.addAttribute("receipts", pendingReceipts);
        model.addAttribute("pendingCount", pendingCount);

        return "sales/imports";
    }
}