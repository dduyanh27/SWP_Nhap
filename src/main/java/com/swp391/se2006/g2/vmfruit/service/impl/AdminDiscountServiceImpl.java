package com.swp391.se2006.g2.vmfruit.service.impl;

import com.swp391.se2006.g2.vmfruit.entity.DiscountCode;
import com.swp391.se2006.g2.vmfruit.exception.AdminUserException;
import com.swp391.se2006.g2.vmfruit.repository.DiscountCodeRepository;
import com.swp391.se2006.g2.vmfruit.service.AdminDiscountService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;

@Service
public class AdminDiscountServiceImpl implements AdminDiscountService {

    private final DiscountCodeRepository discountCodeRepository;

    public AdminDiscountServiceImpl(DiscountCodeRepository discountCodeRepository) {
        this.discountCodeRepository = discountCodeRepository;
    }

    @Override
    @Transactional(readOnly = true)
    public List<DiscountCode> getAllDiscounts(String sortBy) {
        if ("usage".equalsIgnoreCase(sortBy)) {
            return discountCodeRepository.findAllByOrderByUsedCountAsc();
        }
        return discountCodeRepository.findAllByOrderByEndDateDesc();
    }

    @Override
    @Transactional(readOnly = true)
    public DiscountCode getDiscountById(Integer id) {
        return discountCodeRepository.findById(id)
                .orElseThrow(() -> new AdminUserException("Không tìm thấy mã giảm giá."));
    }

    @Override
    @Transactional
    public void createDiscount(DiscountCode discount) {
        validateDiscount(discount);

        if (discountCodeRepository.findByCodeIgnoreCase(discount.getCode()).isPresent()) {
            throw new AdminUserException("Mã giảm giá đã tồn tại.");
        }

        discount.setUsedCount(0);
        discount.setStatus("ACTIVE");
        discountCodeRepository.save(discount);
    }

    @Override
    @Transactional
    public void updateDiscount(DiscountCode discount) {
        DiscountCode existing = discountCodeRepository.findById(discount.getDiscountId())
                .orElseThrow(() -> new AdminUserException("Không tìm thấy mã giảm giá."));

        discountCodeRepository.findByCodeIgnoreCase(discount.getCode()).ifPresent(d -> {
            if (!d.getDiscountId().equals(discount.getDiscountId())) {
                throw new AdminUserException("Mã giảm giá đã tồn tại.");
            }
        });

        validateDiscount(discount);

        existing.setCode(discount.getCode());
        existing.setDiscountType(discount.getDiscountType());
        existing.setDiscountValue(discount.getDiscountValue());
        existing.setMinOrderAmount(discount.getMinOrderAmount());
        existing.setMaxDiscountAmount(discount.getMaxDiscountAmount());
        existing.setStartDate(discount.getStartDate());
        existing.setEndDate(discount.getEndDate());
        existing.setUsageLimit(discount.getUsageLimit());
        existing.setPerUserLimit(discount.getPerUserLimit());
        existing.setTargetUserType(discount.getTargetUserType());
        discountCodeRepository.save(existing);
    }

    @Override
    @Transactional
    public void toggleStatus(Integer id) {
        DiscountCode discount = discountCodeRepository.findById(id)
                .orElseThrow(() -> new AdminUserException("Không tìm thấy mã giảm giá."));
        if ("ACTIVE".equalsIgnoreCase(discount.getStatus())) {
            discount.setStatus("DISABLED");
        } else {
            discount.setStatus("ACTIVE");
        }
        discountCodeRepository.save(discount);
    }

    @Override
    @Transactional(readOnly = true)
    public long getActiveCount() {
        return discountCodeRepository.countByStatus("ACTIVE");
    }

    @Override
    @Transactional(readOnly = true)
    public long getExpiredCount() {
        LocalDateTime now = LocalDateTime.now();
        return discountCodeRepository.findAll().stream()
                .filter(d -> d.getEndDate().isBefore(now))
                .count();
    }

    @Override
    @Transactional(readOnly = true)
    public long getTotalCount() {
        return discountCodeRepository.count();
    }

    private void validateDiscount(DiscountCode discount) {
        if (discount.getCode() == null || discount.getCode().isBlank()) {
            throw new AdminUserException("Mã giảm giá không được để trống.");
        }
        if (discount.getDiscountValue() == null || discount.getDiscountValue().compareTo(java.math.BigDecimal.ZERO) <= 0) {
            throw new AdminUserException("Giá trị giảm phải lớn hơn 0.");
        }
        if (discount.getStartDate() == null) {
            throw new AdminUserException("Ngày bắt đầu không được để trống.");
        }
        if (discount.getEndDate() == null) {
            throw new AdminUserException("Ngày kết thúc không được để trống.");
        }
        if (discount.getEndDate().isBefore(discount.getStartDate())) {
            throw new AdminUserException("Ngày kết thúc phải sau ngày bắt đầu.");
        }
        if (!"PERCENTAGE".equalsIgnoreCase(discount.getDiscountType())
                && !"FIXED".equalsIgnoreCase(discount.getDiscountType())) {
            throw new AdminUserException("Loại giảm giá không hợp lệ.");
        }
        if ("PERCENTAGE".equalsIgnoreCase(discount.getDiscountType())
                && discount.getDiscountValue().compareTo(new java.math.BigDecimal("100")) > 0) {
            throw new AdminUserException("Phần trăm giảm không được vượt quá 100%.");
        }
    }
}
