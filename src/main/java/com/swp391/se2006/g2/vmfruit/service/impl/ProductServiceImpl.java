package com.swp391.se2006.g2.vmfruit.service.impl;

import com.swp391.se2006.g2.vmfruit.entity.Product;
import com.swp391.se2006.g2.vmfruit.repository.ProductRepository;
import com.swp391.se2006.g2.vmfruit.service.ProductService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.*;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.util.List;

@Service
public class ProductServiceImpl implements ProductService {

    @Autowired
    private ProductRepository productRepository;

    @Override
    public List<Product> getActiveProductsForHome() {
        return productRepository.findBySellingStatus("ACTIVE");
    }

    @Override
    public Page<Product> getFilteredProducts(
            Integer categoryId,
            BigDecimal minPrice,
            BigDecimal maxPrice,
            int page,
            int size,
            String sortBy,
            String sortDir) {
        Sort sort = sortDir.equalsIgnoreCase("asc")
                ? Sort.by(sortBy).ascending()
                : Sort.by(sortBy).descending();

        Pageable pageable = PageRequest.of(page, size, sort);

        BigDecimal min = (minPrice != null) ? minPrice : BigDecimal.ZERO;
        BigDecimal max = (maxPrice != null) ? maxPrice : new BigDecimal("100000000");

        return productRepository.findWithFilters(categoryId, min, max, pageable);
    }
}