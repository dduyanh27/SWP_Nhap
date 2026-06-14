package com.swp391.se2006.g2.vmfruit.service.impl;

import com.swp391.se2006.g2.vmfruit.entity.Order;
import com.swp391.se2006.g2.vmfruit.entity.OrderItem;
import com.swp391.se2006.g2.vmfruit.entity.Product;
import com.swp391.se2006.g2.vmfruit.entity.Review;
import com.swp391.se2006.g2.vmfruit.entity.User;
import com.swp391.se2006.g2.vmfruit.repository.OrderItemRepository;
import com.swp391.se2006.g2.vmfruit.repository.ProductRepository;
import com.swp391.se2006.g2.vmfruit.repository.ReviewRepository;
import com.swp391.se2006.g2.vmfruit.repository.UserRepository;
import com.swp391.se2006.g2.vmfruit.service.ReviewService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;

@Service
public class ReviewServiceImpl implements ReviewService {

    private final ReviewRepository reviewRepository;
    private final OrderItemRepository orderItemRepository;
    private final UserRepository userRepository;
    private final ProductRepository productRepository;

    public ReviewServiceImpl(ReviewRepository reviewRepository,
                             OrderItemRepository orderItemRepository,
                             UserRepository userRepository,
                             ProductRepository productRepository) {
        this.reviewRepository = reviewRepository;
        this.orderItemRepository = orderItemRepository;
        this.userRepository = userRepository;
        this.productRepository = productRepository;
    }

    @Override
    public List<Review> getVisibleReviews() {
        return reviewRepository.findByStatusOrderByCreatedAtDesc("VISIBLE");
    }

    @Override
    @Transactional
    public Review createReview(Integer userId, Integer productId, Integer rating, String comment) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found"));
        Product product = productRepository.findById(productId)
                .orElseThrow(() -> new RuntimeException("Product not found"));

        List<OrderItem> items = orderItemRepository.findDeliveredByUserAndProduct(userId, productId);
        Order order = items.isEmpty() ? null : items.get(0).getOrder();

        Review review = new Review();
        review.setUser(user);
        review.setProduct(product);
        review.setOrder(order);
        review.setRating(rating);
        review.setComment(comment);
        review.setStatus("VISIBLE");
        review.setCreatedAt(LocalDateTime.now());

        return reviewRepository.save(review);
    }

    @Override
    public boolean canReviewProduct(Integer userId, Integer productId) {
        return orderItemRepository.existsByUserAndProductAndDelivered(userId, productId);
    }

    @Override
    public boolean hasReviewedProduct(Integer userId, Integer productId) {
        return reviewRepository.existsByUserUserIdAndProductProductId(userId, productId);
    }
}
