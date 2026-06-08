package com.swp391.se2006.g2.vmfruit.service;

import com.swp391.se2006.g2.vmfruit.dto.request.LoginRequest;
import com.swp391.se2006.g2.vmfruit.dto.request.RegisterRequest;
import com.swp391.se2006.g2.vmfruit.entity.User;

public interface UserService {

    void register(RegisterRequest request);

    User login(LoginRequest request);

    User findByEmail(String email);

    void updatePassword(Integer userId, String newPassword);

    boolean isAdmin(Integer userId);

    boolean isSalesStaff(Integer userId);
}
