package com.swp391.se2006.g2.vmfruit.repository;

import com.swp391.se2006.g2.vmfruit.entity.Review;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import org.springframework.data.jpa.repository.Query;
import java.util.List;

public interface ReviewRepository extends JpaRepository<Review, Integer> {
    List<Review> findByProductProductIdAndStatus(Integer productId, String status);

    long countByProductProductIdAndStatus(Integer productId, String status);

    @Query("SELECT AVG(r.rating) FROM Review r WHERE r.product.productId = :productId AND r.status = 'VISIBLE'")
    Double getAverageRatingByProductId(@Param("productId") Integer productId);

    long count();

    long countByRating(Integer rating);

    long countByRatingAndStatus(Integer rating, String status);

    long countByStatus(String status);

    @Query("SELECT AVG(r.rating) FROM Review r WHERE r.status = 'VISIBLE'")
    Double getOverallAverageRating();

    List<Review> findAllByOrderByCreatedAtDesc();

    List<Review> findByStatusOrderByCreatedAtDesc(String status);

    boolean existsByUserUserIdAndProductProductId(Integer userId, Integer productId);

    List<Review> findByRatingOrderByCreatedAtDesc(Integer rating);

    List<Review> findByRatingAndStatusOrderByCreatedAtDesc(Integer rating, String status);
}
