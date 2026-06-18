package com.swp391.se2006.g2.vmfruit.controller.admin;

import com.swp391.se2006.g2.vmfruit.dto.response.BatchGroupResponse;
import com.swp391.se2006.g2.vmfruit.dto.response.BatchStatsResponse;
import com.swp391.se2006.g2.vmfruit.service.AdminBatchService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;

@Controller
@RequestMapping("/admin/batches")
public class AdminBatchController {
    private final AdminBatchService adminBatchService;

    public AdminBatchController(AdminBatchService adminBatchService) {
        this.adminBatchService = adminBatchService;
    }

    @GetMapping("")
    public String showBatchManagement(Model model) {
        BatchStatsResponse stats = adminBatchService.getBatchStats();
        List<BatchGroupResponse> batchList = adminBatchService.getBatchManagementData();

        model.addAttribute("stats", stats);
        model.addAttribute("batchGroups", batchList);
        model.addAttribute("contentPage", "admin/batches");
        model.addAttribute("activeMenu", "batch-manage");

        return "layouts/admin-layout";
    }

    @PostMapping("/delete/{id}")
    public String deleteBatch(@PathVariable("id") Integer id, RedirectAttributes redirectAttributes) {
        try {
            adminBatchService.deleteBatch(id);
            redirectAttributes.addFlashAttribute("message", "Đã xóa lô hàng thành công!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Không thể xóa lô hàng: " + e.getMessage());
        }
        return "redirect:/admin/batches";
    }

    @PostMapping("/{batchId}/items/{itemId}/remove")
    public String removeItem(
            @PathVariable("batchId") Integer batchId,
            @PathVariable("itemId") Integer itemId,
            RedirectAttributes redirectAttributes) {
        try {
            adminBatchService.cancelBatchItem(batchId, itemId);
            redirectAttributes.addFlashAttribute("message",
                    "Item IT" + String.format("%04d", itemId) + " đã được hủy thành công (CANCELLED).");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error",
                    "Không thể Remove Item: " + e.getMessage());
        }
        return "redirect:/admin/batches";
    }

    @PostMapping("/{batchId}/cancel")
    public String cancelBatch(
            @PathVariable("batchId") Integer batchId,
            RedirectAttributes redirectAttributes) {
        try {
            adminBatchService.cancelBatch(batchId);
            redirectAttributes.addFlashAttribute("message",
                    "Lô hàng B" + String.format("%04d", batchId) + " đã bị hủy thành công.");
        } catch (IllegalStateException e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error",
                    "Không thể hủy lô hàng: " + e.getMessage());
        }
        return "redirect:/admin/batches";
    }
}
