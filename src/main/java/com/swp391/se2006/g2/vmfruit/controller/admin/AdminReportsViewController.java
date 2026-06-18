package com.swp391.se2006.g2.vmfruit.controller.admin;

import com.swp391.se2006.g2.vmfruit.service.AdminImportReceiptService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.time.LocalDate;

@Controller
@RequestMapping("/admin/reports")
public class AdminReportsViewController {

    private final AdminImportReceiptService adminImportReceiptService;

    public AdminReportsViewController(AdminImportReceiptService adminImportReceiptService) {
        this.adminImportReceiptService = adminImportReceiptService;
    }

    // TÍNH NĂNG 1: TRANG TẠO MỚI (Giờ đây sẽ chạy ở đúng URL /admin/reports)
    @GetMapping
    public String showCreatePage(Model model) {
        model.addAttribute("suppliers", adminImportReceiptService.getActiveSuppliers());
        model.addAttribute("products",  adminImportReceiptService.getActiveProducts());
        model.addAttribute("defaultDate", LocalDate.now().plusDays(7).toString());
        return "create-import"; // Trả về đúng file create-import.jsp của bạn
    }

    // TÍNH NĂNG 2: TRANG DANH SÁCH (Được dời sang URL /admin/reports/list)
    @GetMapping("/list")
    public String showReportsPage(
            @RequestParam(value = "supplier", required = false) Integer supplier,
            @RequestParam(value = "sortDate", required = false, defaultValue = "recent") String sortDate,
            Model model) {

        model.addAttribute("suppliers", adminImportReceiptService.getActiveSuppliers());
        model.addAttribute("totalCount",    adminImportReceiptService.getTotalCount());
        model.addAttribute("pendingCount",  adminImportReceiptService.getPendingCount());
        model.addAttribute("receivedCount", adminImportReceiptService.getReceivedCount());
        model.addAttribute("totalQuantity", adminImportReceiptService.getTotalQuantity());

        model.addAttribute("receiptRows",   adminImportReceiptService.getReceiptRows(supplier, sortDate));
        model.addAttribute("selectedSupplier", supplier);
        model.addAttribute("selectedSortDate", sortDate);

        return "admin/import-receipts"; // Trả về file import-receipts.jsp
    }
}