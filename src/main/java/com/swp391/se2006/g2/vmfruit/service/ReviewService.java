package com.swp391.se2006.g2.vmfruit.service;

import com.swp391.se2006.g2.vmfruit.entity.Review;
import java.util.List;

public interface ReviewService {
    List<Review> getVisibleReviews();
}