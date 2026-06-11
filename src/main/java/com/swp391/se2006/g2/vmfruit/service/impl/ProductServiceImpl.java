package com.swp391.se2006.g2.vmfruit.service.impl;

import com.swp391.se2006.g2.vmfruit.entity.Product;
import com.swp391.se2006.g2.vmfruit.entity.Review;
import com.swp391.se2006.g2.vmfruit.repository.InboundBatchItemsRepository;
import com.swp391.se2006.g2.vmfruit.repository.ProductRepository;
import com.swp391.se2006.g2.vmfruit.repository.ReviewRepository;
import com.swp391.se2006.g2.vmfruit.service.ProductService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.*;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;

@Service
public class ProductServiceImpl implements ProductService {

    @Autowired
    private ProductRepository productRepository;

    @Autowired
    private InboundBatchItemsRepository inboundBatchItemsRepository;

    @Autowired
    private ReviewRepository reviewRepository;

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

    @Override
    public Optional<Product> getProductById(Integer id) {
        return productRepository.findById(id);
    }

    @Override
    public Double getProductStock(Integer productId) {
        BigDecimal stock = inboundBatchItemsRepository.getTotalRemainingQuantityByProductId(productId);
        return stock != null ? stock.doubleValue() : 0.0;
    }

    @Override
    public List<Review> getProductReviews(Integer productId) {
        return reviewRepository.findByProductProductIdAndStatus(productId, "VISIBLE");
    }

    @Override
    public Double getAverageRating(Integer productId) {
        Double avg = reviewRepository.getAverageRatingByProductId(productId);
        return avg != null ? avg : 0.0;
    }

    @Override
    public long getReviewCount(Integer productId) {
        return reviewRepository.countByProductProductIdAndStatus(productId, "VISIBLE");
    }
}