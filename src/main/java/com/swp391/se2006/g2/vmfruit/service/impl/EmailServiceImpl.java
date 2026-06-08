package com.swp391.se2006.g2.vmfruit.service.impl;

import com.swp391.se2006.g2.vmfruit.service.EmailService;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Service;

@Service
public class EmailServiceImpl implements EmailService {

    private final JavaMailSender mailSender;

    public EmailServiceImpl(JavaMailSender mailSender) {
        this.mailSender = mailSender;
    }

    @Override
    public void sendPasswordResetOtp(String to, String otp, String fullName) {
        SimpleMailMessage message = new SimpleMailMessage();
        message.setTo(to);
        message.setSubject("VMFruit - Mã xác nhận đặt lại mật khẩu");
        message.setText("Xin chào " + fullName + ",\n\n"
                + "Bạn đã yêu cầu đặt lại mật khẩu cho tài khoản VMFruit của mình.\n"
                + "Mã xác nhận của bạn là:\n\n"
                + otp + "\n\n"
                + "Vui lòng nhập mã này trên trang web để đặt lại mật khẩu.\n"
                + "Mã có hiệu lực trong 30 phút.\n"
                + "Nếu bạn không yêu cầu đặt lại mật khẩu, vui lòng bỏ qua email này.\n\n"
                + "Trân trọng,\nĐội ngũ VMFruit");
        mailSender.send(message);
    }

    @Override
    public void sendPasswordResetEmail(String to, String resetLink, String fullName) {
        SimpleMailMessage message = new SimpleMailMessage();
        message.setTo(to);
        message.setSubject("VMFruit - Đặt lại mật khẩu");
        message.setText("Xin chào " + fullName + ",\n\n"
                + "Bạn đã yêu cầu đặt lại mật khẩu cho tài khoản VMFruit của mình.\n"
                + "Vui lòng nhấp vào liên kết bên dưới để đặt lại mật khẩu:\n\n"
                + resetLink + "\n\n"
                + "Liên kết này có hiệu lực trong 30 phút.\n"
                + "Nếu bạn không yêu cầu đặt lại mật khẩu, vui lòng bỏ qua email này.\n\n"
                + "Trân trọng,\nĐội ngũ VMFruit");
        mailSender.send(message);
    }
}
