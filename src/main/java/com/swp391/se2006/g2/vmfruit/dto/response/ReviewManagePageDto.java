package com.swp391.se2006.g2.vmfruit.dto.response;

import java.util.List;

public class ReviewManagePageDto {

    private double overallRating;
    private long totalReviews;
    private long count5Star;
    private long count4Star;
    private long count3Star;
    private long count2Star;
    private long count1Star;
    private long visibleCount;
    private long hiddenCount;
    private List<ReviewRowDto> reviewList;

    public double getOverallRating() {
        return overallRating;
    }

    public void setOverallRating(double overallRating) {
        this.overallRating = overallRating;
    }

    public long getTotalReviews() {
        return totalReviews;
    }

    public void setTotalReviews(long totalReviews) {
        this.totalReviews = totalReviews;
    }

    public long getCount5Star() {
        return count5Star;
    }

    public void setCount5Star(long count5Star) {
        this.count5Star = count5Star;
    }

    public long getCount4Star() {
        return count4Star;
    }

    public void setCount4Star(long count4Star) {
        this.count4Star = count4Star;
    }

    public long getCount3Star() {
        return count3Star;
    }

    public void setCount3Star(long count3Star) {
        this.count3Star = count3Star;
    }

    public long getCount2Star() {
        return count2Star;
    }

    public void setCount2Star(long count2Star) {
        this.count2Star = count2Star;
    }

    public long getCount1Star() {
        return count1Star;
    }

    public void setCount1Star(long count1Star) {
        this.count1Star = count1Star;
    }

    public long getVisibleCount() {
        return visibleCount;
    }

    public void setVisibleCount(long visibleCount) {
        this.visibleCount = visibleCount;
    }

    public long getHiddenCount() {
        return hiddenCount;
    }

    public void setHiddenCount(long hiddenCount) {
        this.hiddenCount = hiddenCount;
    }

    public List<ReviewRowDto> getReviewList() {
        return reviewList;
    }

    public void setReviewList(List<ReviewRowDto> reviewList) {
        this.reviewList = reviewList;
    }
}
