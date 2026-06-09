package com.swp391.se2006.g2.vmfruit.dto.response;

public class AdminUserListItemDto {

    private Integer userId;
    private String userIdDisplay;
    private String fullName;
    private String email;
    private String phone;
    private String role;
    private String roleDisplay;
    private String status;

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public String getUserIdDisplay() {
        return userIdDisplay;
    }

    public void setUserIdDisplay(String userIdDisplay) {
        this.userIdDisplay = userIdDisplay;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public String getRoleDisplay() {
        return roleDisplay;
    }

    public void setRoleDisplay(String roleDisplay) {
        this.roleDisplay = roleDisplay;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
}
