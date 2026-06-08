package com.swp391.se2006.g2.vmfruit.service;

public interface EmailService {

    void sendPasswordResetOtp(String to, String otp, String fullName);

    void sendPasswordResetEmail(String to, String resetLink, String fullName);
}
