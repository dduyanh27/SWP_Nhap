package com.swp391.se2006.g2.vmfruit.service.impl;

import com.swp391.se2006.g2.vmfruit.dto.response.ReviewManagePageDto;
import com.swp391.se2006.g2.vmfruit.dto.response.ReviewRowDto;
import com.swp391.se2006.g2.vmfruit.entity.Review;
import com.swp391.se2006.g2.vmfruit.exception.AdminReviewException;
import com.swp391.se2006.g2.vmfruit.repository.ReviewRepository;
import com.swp391.se2006.g2.vmfruit.service.AdminReviewService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Comparator;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class AdminReviewServiceImpl implements AdminReviewService {

    private final ReviewRepository reviewRepository;

    public AdminReviewServiceImpl(ReviewRepository reviewRepository) {
        this.reviewRepository = reviewRepository;
    }

    @Override
    @Transactional(readOnly = true)
    public ReviewManagePageDto getReviewManagePage(String starFilter, String sort, String search) {
        ReviewManagePageDto page = new ReviewManagePageDto();

        Double avg = reviewRepository.getOverallAverageRating();
        page.setOverallRating(avg != null ? Math.round(avg * 10.0) / 10.0 : 0.0);
        page.setTotalReviews(reviewRepository.count());
        page.setCount5Star(reviewRepository.countByRating(5));
        page.setCount4Star(reviewRepository.countByRating(4));
        page.setCount3Star(reviewRepository.countByRating(3));
        page.setCount2Star(reviewRepository.countByRating(2));
        page.setCount1Star(reviewRepository.countByRating(1));
        page.setVisibleCount(reviewRepository.countByStatus("VISIBLE"));
        page.setHiddenCount(reviewRepository.countByStatus("HIDDEN"));

        page.setReviewList(getReviewRows(starFilter, sort, search));
        return page;
    }

    @Override
    @Transactional(readOnly = true)
    public List<ReviewRowDto> getReviewRows(String starFilter, String sort, String search) {
        List<Review> reviews;

        if (starFilter != null && !starFilter.isBlank() && !"all".equalsIgnoreCase(starFilter)) {
            int star = Integer.parseInt(starFilter);
            reviews = reviewRepository.findByRatingOrderByCreatedAtDesc(star);
        } else {
            reviews = reviewRepository.findAllByOrderByCreatedAtDesc();
        }

        if ("oldest".equalsIgnoreCase(sort)) {
            reviews.sort(Comparator.comparing(Review::getCreatedAt));
        }

        List<ReviewRowDto> list = reviews.stream()
                .map(this::toRowDto)
                .collect(Collectors.toList());

        if (search != null && !search.isBlank()) {
            String q = search.trim().toLowerCase();
            list = list.stream()
                    .filter(r -> r.getReviewIdDisplay().toLowerCase().contains(q)
                            || r.getProductIdDisplay().toLowerCase().contains(q)
                            || r.getUserIdDisplay().toLowerCase().contains(q)
                            || (r.getComment() != null && r.getComment().toLowerCase().contains(q)))
                    .collect(Collectors.toList());
        }

        return list;
    }

    @Override
    @Transactional(readOnly = true)
    public ReviewRowDto getReviewDetail(Integer reviewId) {
        Review review = reviewRepository.findById(reviewId)
                .orElseThrow(() -> new AdminReviewException("Review not found: " + reviewId));
        return toRowDto(review);
    }

    @Override
    @Transactional
    public void hideReview(Integer reviewId) {
        Review review = reviewRepository.findById(reviewId)
                .orElseThrow(() -> new AdminReviewException("Review not found: " + reviewId));
        review.setStatus("HIDDEN");
        reviewRepository.save(review);
    }

    @Override
    @Transactional
    public void showReview(Integer reviewId) {
        Review review = reviewRepository.findById(reviewId)
                .orElseThrow(() -> new AdminReviewException("Review not found: " + reviewId));
        review.setStatus("VISIBLE");
        reviewRepository.save(review);
    }

    private ReviewRowDto toRowDto(Review review) {
        ReviewRowDto dto = new ReviewRowDto();
        dto.setReviewId(review.getReviewId());
        dto.setReviewIdDisplay(String.format("R%03d", review.getReviewId()));
        dto.setProductIdDisplay(String.format("P%03d", review.getProduct().getProductId()));
        dto.setUserIdDisplay(String.format("U%03d", review.getUser().getUserId()));
        dto.setProductName(review.getProduct().getProductName());
        dto.setUserName(review.getUser().getFullName());
        dto.setRating(review.getRating());
        dto.setComment(review.getComment());

        if (review.getComment() != null && review.getComment().length() > 50) {
            dto.setCommentShort(review.getComment().substring(0, 50) + "...");
        } else {
            dto.setCommentShort(review.getComment());
        }

        dto.setStatus(review.getStatus());
        dto.setCreatedAt(review.getCreatedAt() != null ? review.getCreatedAt().toString() : "");
        return dto;
    }
}
