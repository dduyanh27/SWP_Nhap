package com.swp391.se2006.g2.vmfruit.service;

import com.swp391.se2006.g2.vmfruit.dto.request.AdminUserCreateRequest;
import com.swp391.se2006.g2.vmfruit.dto.request.AdminUserUpdateRequest;
import com.swp391.se2006.g2.vmfruit.dto.response.AdminUserListItemDto;
import com.swp391.se2006.g2.vmfruit.dto.response.AdminUserPageDto;

public interface AdminUserService {

    AdminUserPageDto getUserManagementPage(String roleFilter, String statusFilter);

    AdminUserListItemDto getUserForEdit(Integer userId);

    void createUser(AdminUserCreateRequest request);

    void updateUser(AdminUserUpdateRequest request);

    void lockUser(Integer userId);

    void unlockUser(Integer userId);
}
