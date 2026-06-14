package com.swp391.se2006.g2.vmfruit.dto.response;

public class ReviewRowDto {

    private Integer reviewId;
    private String reviewIdDisplay;
    private String productIdDisplay;
    private String userIdDisplay;
    private String productName;
    private String userName;
    private Integer rating;
    private String comment;
    private String commentShort;
    private String status;
    private String createdAt;

    public Integer getReviewId() {
        return reviewId;
    }

    public void setReviewId(Integer reviewId) {
        this.reviewId = reviewId;
    }

    public String getReviewIdDisplay() {
        return reviewIdDisplay;
    }

    public void setReviewIdDisplay(String reviewIdDisplay) {
        this.reviewIdDisplay = reviewIdDisplay;
    }

    public String getProductIdDisplay() {
        return productIdDisplay;
    }

    public void setProductIdDisplay(String productIdDisplay) {
        this.productIdDisplay = productIdDisplay;
    }

    public String getUserIdDisplay() {
        return userIdDisplay;
    }

    public void setUserIdDisplay(String userIdDisplay) {
        this.userIdDisplay = userIdDisplay;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public Integer getRating() {
        return rating;
    }

    public void setRating(Integer rating) {
        this.rating = rating;
    }

    public String getComment() {
        return comment;
    }

    public void setComment(String comment) {
        this.comment = comment;
    }

    public String getCommentShort() {
        return commentShort;
    }

    public void setCommentShort(String commentShort) {
        this.commentShort = commentShort;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(String createdAt) {
        this.createdAt = createdAt;
    }
}
