package com.swp391.se2006.g2.vmfruit.service;

import com.swp391.se2006.g2.vmfruit.entity.Product;
import org.springframework.data.domain.Page;

import com.swp391.se2006.g2.vmfruit.entity.Review;
import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;

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

    Optional<Product> getProductById(Integer id);

    Double getProductStock(Integer productId);

    List<Review> getProductReviews(Integer productId);

    Double getAverageRating(Integer productId);

    long getReviewCount(Integer productId);
}