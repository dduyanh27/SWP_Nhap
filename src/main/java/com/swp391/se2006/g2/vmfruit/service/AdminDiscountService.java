package com.swp391.se2006.g2.vmfruit.service;

import com.swp391.se2006.g2.vmfruit.entity.DiscountCode;

import java.math.BigDecimal;
import java.util.List;

public interface AdminDiscountService {

    List<DiscountCode> getAllDiscounts(String sortBy);

    DiscountCode getDiscountById(Integer id);

    void createDiscount(DiscountCode discount);

    void updateDiscount(DiscountCode discount);

    void toggleStatus(Integer id);

    long getActiveCount();

    long getExpiredCount();

    long getTotalCount();
}
