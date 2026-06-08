package com.swp391.se2006.g2.vmfruit.service.impl;

import com.swp391.se2006.g2.vmfruit.dto.response.ProductRowResponse;
import com.swp391.se2006.g2.vmfruit.dto.response.ProductStatsResponse;
import com.swp391.se2006.g2.vmfruit.repository.InboundBatchItemsRepository;
import com.swp391.se2006.g2.vmfruit.repository.ProductRepository;
import com.swp391.se2006.g2.vmfruit.service.AdminProductService;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.List;

@Service
public class AdminProductImpl implements AdminProductService {
    private final ProductRepository productRepository;
    private final InboundBatchItemsRepository inboundBatchItemsRepository;

    public AdminProductImpl(ProductRepository productRepository,
            InboundBatchItemsRepository inboundBatchItemsRepository) {
        this.productRepository = productRepository;
        this.inboundBatchItemsRepository = inboundBatchItemsRepository;
    }

    @Override
    public ProductStatsResponse getProductStats() {
        long lowStock = inboundBatchItemsRepository.countByItemStatusAndRemainingQuantityLessThanEqual("ACTIVE", 5.0);

        LocalDate today = LocalDate.now();
        LocalDate threeDaysLater = today.plusDays(3);
        long expriringSoon = inboundBatchItemsRepository.countExpiringSoonLotes(today, threeDaysLater);

        long hiddenItems = productRepository.countBySellingStatus("INACTIVE");

        long totalProducts = productRepository.count();

        return new ProductStatsResponse(lowStock, expriringSoon, hiddenItems, totalProducts);
    }

    @Override
    public List<ProductRowResponse> getAllProductRows() {
        return productRepository.getAllProductRowsForAdmin();
    }
}
