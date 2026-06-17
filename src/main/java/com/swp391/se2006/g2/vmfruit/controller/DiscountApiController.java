package com.swp391.se2006.g2.vmfruit.controller;

import com.swp391.se2006.g2.vmfruit.entity.DiscountCode;
import com.swp391.se2006.g2.vmfruit.entity.User;
import com.swp391.se2006.g2.vmfruit.repository.DiscountCodeRepository;
import jakarta.servlet.http.HttpSession;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/discounts")
public class DiscountApiController {

    private final DiscountCodeRepository discountCodeRepository;

    public DiscountApiController(DiscountCodeRepository discountCodeRepository) {
        this.discountCodeRepository = discountCodeRepository;
    }

    @PostMapping("/validate")
    public Map<String, Object> validateDiscount(@RequestParam String code,
                                                 @RequestParam(defaultValue = "0") BigDecimal cartTotal,
                                                 HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        User user = (User) session.getAttribute("currentUser");
        if (user == null) {
            result.put("valid", false);
            result.put("message", "Vui lòng đăng nhập.");
            return result;
        }

        try {
            DiscountCode discount = discountCodeRepository.findByCodeIgnoreCase(code.trim())
                    .orElse(null);

            if (discount == null) {
                result.put("valid", false);
                result.put("message", "Mã giảm giá không tồn tại.");
                return result;
            }

            if (!"ACTIVE".equalsIgnoreCase(discount.getStatus())) {
                result.put("valid", false);
                result.put("message", "Mã giảm giá đã bị vô hiệu hóa.");
                return result;
            }

            LocalDateTime now = LocalDateTime.now();
            if (now.isBefore(discount.getStartDate())) {
                result.put("valid", false);
                result.put("message", "Mã giảm giá chưa đến hạn sử dụng.");
                return result;
            }
            if (now.isAfter(discount.getEndDate())) {
                result.put("valid", false);
                result.put("message", "Mã giảm giá đã hết hạn.");
                return result;
            }

            if (discount.getUsageLimit() != null && discount.getUsedCount() >= discount.getUsageLimit()) {
                result.put("valid", false);
                result.put("message", "Mã giảm giá đã hết lượt sử dụng.");
                return result;
            }

            if (cartTotal.compareTo(discount.getMinOrderAmount()) < 0) {
                result.put("valid", false);
                result.put("message", "Đơn hàng tối thiểu "
                        + String.format("%,.0f", discount.getMinOrderAmount()) + "đ để sử dụng mã này.");
                return result;
            }

            result.put("valid", true);
            result.put("discountType", discount.getDiscountType());
            result.put("discountValue", discount.getDiscountValue());
            result.put("maxDiscountAmount", discount.getMaxDiscountAmount());
            result.put("minOrderAmount", discount.getMinOrderAmount());
            result.put("message", "Áp dụng mã giảm giá thành công!");
        } catch (Exception e) {
            result.put("valid", false);
            result.put("message", "Lỗi khi áp dụng mã giảm giá.");
        }

        return result;
    }
}
