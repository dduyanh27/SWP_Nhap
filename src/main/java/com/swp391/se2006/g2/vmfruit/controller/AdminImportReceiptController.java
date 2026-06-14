package com.swp391.se2006.g2.vmfruit.controller;

import com.swp391.se2006.g2.vmfruit.service.AdminImportReceiptService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.math.RoundingMode;

@Controller
@RequestMapping("/admin/import-receipts")
public class AdminImportReceiptController {

    private final AdminImportReceiptService adminImportReceiptService;

    public AdminImportReceiptController(AdminImportReceiptService adminImportReceiptService) {
        this.adminImportReceiptService = adminImportReceiptService;
    }

    @GetMapping
    public String listImportReceipts(@RequestParam(required = false) Integer supplier,
            @RequestParam(defaultValue = "recent") String sortDate,
            Model model) {
        model.addAttribute("totalCount", adminImportReceiptService.getTotalCount());
        model.addAttribute("pendingCount", String.format("%02d", adminImportReceiptService.getPendingCount()));
        model.addAttribute("receivedCount", String.format("%02d", adminImportReceiptService.getReceivedCount()));
        model.addAttribute("totalQuantity", adminImportReceiptService.getTotalQuantity()
                .setScale(0, RoundingMode.HALF_UP));
        model.addAttribute("suppliers", adminImportReceiptService.getActiveSuppliers());
        model.addAttribute("receiptList", adminImportReceiptService.getReceiptRows(supplier, sortDate));
        model.addAttribute("selectedSupplier", supplier);
        model.addAttribute("sortDate", sortDate);
        model.addAttribute("contentPage", "admin/import-receipts");
        model.addAttribute("activeMenu", "import-receipt-manage");
        return "layouts/admin-layout";
    }
}
