package com.swp391.se2006.g2.vmfruit.controller;


import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class InventoryBatchController {

    @GetMapping("/inventory-batches")
    public String viewInventoryBatches(Model model) {
        // Đảm bảo truyền đúng tên thuộc tính sang thẻ <c:forEach items="${inventoryBatchesList}">
        // Hiện tại tạm thời để null để JSTL tự nhảy vào khối <c:otherwise> hiển thị data mockup chuẩn 2026
        model.addAttribute("inventoryBatchesList", null);

        model.addAttribute("totalActiveBatches", 42);
        model.addAttribute("nearExpiryCount", 5);
        model.addAttribute("urgentClearanceCount", 2);

        return "inventory/inventory-batches"; // Sẽ tìm đến /WEB-INF/views/inventory/inventory-batches.jsp
    }
}