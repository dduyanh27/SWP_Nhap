package com.swp391.se2006.g2.vmfruit.service;

import com.swp391.se2006.g2.vmfruit.dto.response.ReviewManagePageDto;
import com.swp391.se2006.g2.vmfruit.dto.response.ReviewRowDto;

import java.util.List;

public interface AdminReviewService {

    ReviewManagePageDto getReviewManagePage(String starFilter, String sort, String search);

    List<ReviewRowDto> getReviewRows(String starFilter, String sort, String search);

    ReviewRowDto getReviewDetail(Integer reviewId);

    void hideReview(Integer reviewId);

    void showReview(Integer reviewId);
}
