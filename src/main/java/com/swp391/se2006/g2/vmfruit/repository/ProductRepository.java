package com.swp391.se2006.g2.vmfruit.repository;

import com.swp391.se2006.g2.vmfruit.dto.response.ProductRowResponse;
import com.swp391.se2006.g2.vmfruit.entity.Product;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.math.BigDecimal;
import java.util.List;

public interface ProductRepository extends JpaRepository<Product, Integer> {

        List<Product> findBySellingStatus(String sellingStatus);

        long countBySellingStatus(String sellingStatus);

        @Query(value = "SELECT p FROM Product p WHERE p.sellingStatus = 'ACTIVE'" +
                        " AND (:categoryId IS NULL OR p.category.categoryId = :categoryId)" +
                        " AND p.basePrice >= :minPrice AND p.basePrice <= :maxPrice", countQuery = "SELECT COUNT(p) FROM Product p WHERE p.sellingStatus = 'ACTIVE'"
                                        +
                                        " AND (:categoryId IS NULL OR p.category.categoryId = :categoryId)" +
                                        " AND p.basePrice >= :minPrice AND p.basePrice <= :maxPrice")
        Page<Product> findWithFilters(
                        @Param("categoryId") Integer categoryId,
                        @Param("minPrice") BigDecimal minPrice,
                        @Param("maxPrice") BigDecimal maxPrice,
                        Pageable pageable);

        @Query("SELECT new com.swp391.se2006.g2.vmfruit.dto.response.ProductRowResponse(" +
                "p.productId, p.productName, p.imageUrl, p.category.categoryName, p.basePrice, p.unit, " +
                "COALESCE(SUM(bi.remainingQuantity), 0.0), p.sellingStatus) " + // Đã bỏ CAST AS double
                "FROM Product p " +
                "LEFT JOIN InboundBatchItem bi ON bi.product.productId = p.productId AND bi.itemStatus = 'ACTIVE' " +
                "GROUP BY p.productId, p.productName, p.imageUrl, p.category.categoryName, p.basePrice, p.unit, p.sellingStatus")
        List<ProductRowResponse> getAllProductRowsForAdmin();
}