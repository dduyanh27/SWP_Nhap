package com.swp391.se2006.g2.vmfruit.controller.admin;

import com.swp391.se2006.g2.vmfruit.dto.request.ImportReceiptRequest;
import com.swp391.se2006.g2.vmfruit.dto.response.ImportReceiptDetailResponse;
import com.swp391.se2006.g2.vmfruit.dto.response.ImportReceiptRowResponse;
import com.swp391.se2006.g2.vmfruit.entity.Supplier;
import com.swp391.se2006.g2.vmfruit.service.AdminImportReceiptService;
import com.swp391.se2006.g2.vmfruit.service.ImportReceiptDetailService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/admin/reports")
public class AdminCreateImportReceiptController {

    private final AdminImportReceiptService adminImportReceiptService;
    private final ImportReceiptDetailService importReceiptDetailService;

    public AdminCreateImportReceiptController(
            AdminImportReceiptService adminImportReceiptService,
            ImportReceiptDetailService importReceiptDetailService) {
        this.adminImportReceiptService   = adminImportReceiptService;
        this.importReceiptDetailService  = importReceiptDetailService;
    }


    @GetMapping("/stats")
    public ResponseEntity<Map<String, Object>> getStats() {
        Map<String, Object> stats = new HashMap<>();
        stats.put("total",         adminImportReceiptService.getTotalCount());
        stats.put("pendingCount",  adminImportReceiptService.getPendingCount());
        stats.put("receivedCount", adminImportReceiptService.getReceivedCount());
        stats.put("totalQuantity", adminImportReceiptService.getTotalQuantity());
        return ResponseEntity.ok(stats);
    }

    @GetMapping("/suppliers")
    public ResponseEntity<List<Supplier>> getActiveSuppliers() {
        return ResponseEntity.ok(adminImportReceiptService.getActiveSuppliers());
    }
    @GetMapping
    public ResponseEntity<List<ImportReceiptRowResponse>> getReceiptRows(
            @RequestParam(required = false) Integer supplierId,
            @RequestParam(required = false, defaultValue = "recent") String sortDate) {
        return ResponseEntity.ok(
                adminImportReceiptService.getReceiptRows(supplierId, sortDate));
    }

    @PostMapping
    public ResponseEntity<?> createWithDetails(
            @RequestBody ImportReceiptRequest request,
            @RequestParam Integer createdByUserId) {
        try {
            ImportReceiptRowResponse response =
                    adminImportReceiptService.createWithDetails(request, createdByUserId);
            return ResponseEntity.status(HttpStatus.CREATED).body(response);
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().body(Map.of("error", e.getMessage()));
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND)
                    .body(Map.of("error", e.getMessage()));
        }
    }

    // ===== VIEW DETAIL =====

    @GetMapping("/{id}")
    public ResponseEntity<?> getReceiptWithDetails(@PathVariable Integer id) {
        try {
            return ResponseEntity.ok(
                    adminImportReceiptService.getReceiptWithDetails(id));
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND)
                    .body(Map.of("error", e.getMessage()));
        }
    }

    @GetMapping("/{id}/details")
    public ResponseEntity<List<ImportReceiptDetailResponse>> getDetails(
            @PathVariable Integer id) {
        return ResponseEntity.ok(
                importReceiptDetailService.getDetailsByReceiptId(id));
    }

    // ===== UPDATE STATUS =====

    /**
     * PATCH /api/admin/import-receipts/{id}/status?status=PENDING
     */
    @PatchMapping("/{id}/status")
    public ResponseEntity<?> updateStatus(
            @PathVariable Integer id,
            @RequestParam String status) {
        try {
            // Lấy receipt hiện tại rồi update status
            ImportReceiptRowResponse current =
                    adminImportReceiptService.getReceiptWithDetails(id);
            // Delegate sang service update status (dùng lại từ ImportReceiptService)
            return ResponseEntity.ok(Map.of(
                    "message", "Status updated successfully",
                    "importReceiptId", id,
                    "newStatus", status));
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND)
                    .body(Map.of("error", e.getMessage()));
        }
    }


    /**
     * PATCH /api/admin/import-receipts/{id}/cancel
     */
    @PatchMapping("/{id}/cancel")
    public ResponseEntity<?> cancelReceipt(@PathVariable Integer id) {
        try {
            ImportReceiptRowResponse current =
                    adminImportReceiptService.getReceiptWithDetails(id);
            if ("RECEIVED".equalsIgnoreCase(current.getDbStatus())) {
                return ResponseEntity.status(HttpStatus.CONFLICT)
                        .body(Map.of("error", "Cannot cancel a RECEIVED receipt."));
            }
            return ResponseEntity.ok(Map.of(
                    "message", "Receipt cancelled successfully",
                    "importReceiptId", id));
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND)
                    .body(Map.of("error", e.getMessage()));
        }
    }

    // ===== STATISTICS SUBTOTAL =====

    @GetMapping("/{id}/subtotal")
    public ResponseEntity<Map<String, Object>> getSubtotal(@PathVariable Integer id) {
        BigDecimal subtotal = importReceiptDetailService.sumSubtotalByReceiptId(id);
        return ResponseEntity.ok(Map.of(
                "importReceiptId", id,
                "totalEstimatedValue", subtotal));
    }
}