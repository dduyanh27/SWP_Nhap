package com.swp391.se2006.g2.vmfruit.dto.request;

public class VerifyOtpRequest {

    private String token;
    private String otp;

    public String getToken() {
        return token;
    }

    public void setToken(String token) {
        this.token = token;
    }

    public String getOtp() {
        return otp;
    }

    public void setOtp(String otp) {
        this.otp = otp;
    }
}
