package com.swp391.se2006.g2.vmfruit.service;

import com.swp391.se2006.g2.vmfruit.entity.Product;
import org.springframework.data.domain.Page;

import java.math.BigDecimal;
import java.util.List;

public interface ProductService {
    List<Product> getActiveProductsForHome();

    Page<Product> getFilteredProducts(
            Integer categoryId,
            BigDecimal minPrice,
            BigDecimal maxPrice,
            int page,
            int size,
            String sortBy,
            String sortDir);
}