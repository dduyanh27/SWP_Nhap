package com.swp391.se2006.g2.vmfruit.dto.response;

import java.util.List;

public class AdminUserPageDto {

    private long newUserCount;
    private long totalCustomers;
    private long totalStaffs;
    private List<AdminUserListItemDto> userList;

    public long getNewUserCount() {
        return newUserCount;
    }

    public void setNewUserCount(long newUserCount) {
        this.newUserCount = newUserCount;
    }

    public long getTotalCustomers() {
        return totalCustomers;
    }

    public void setTotalCustomers(long totalCustomers) {
        this.totalCustomers = totalCustomers;
    }

    public long getTotalStaffs() {
        return totalStaffs;
    }

    public void setTotalStaffs(long totalStaffs) {
        this.totalStaffs = totalStaffs;
    }

    public List<AdminUserListItemDto> getUserList() {
        return userList;
    }

    public void setUserList(List<AdminUserListItemDto> userList) {
        this.userList = userList;
    }
}
