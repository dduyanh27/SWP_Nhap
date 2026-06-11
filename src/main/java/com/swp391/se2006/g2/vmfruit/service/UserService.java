package com.swp391.se2006.g2.vmfruit.service;

import com.swp391.se2006.g2.vmfruit.dto.request.UserRequest;
import com.swp391.se2006.g2.vmfruit.dto.request.LoginRequest;
import com.swp391.se2006.g2.vmfruit.dto.request.RegisterRequest;
import com.swp391.se2006.g2.vmfruit.entity.User;

public interface UserService {

    void register(RegisterRequest request);

    User login(LoginRequest request);
    public User getUserById(Integer userId);
    public void updateUserProfile(Integer userId, UserRequest request, String avatarUrl);
    public void changePassword(Integer userId, String oldPassword, String newPassword);

    User findByEmail(String email);

    void updatePassword(Integer userId, String newPassword);

    boolean isAdmin(Integer userId);
}
