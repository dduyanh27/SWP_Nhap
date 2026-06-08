package com.swp391.se2006.g2.vmfruit.controller;

import com.swp391.se2006.g2.vmfruit.dto.request.ForgotPasswordRequest;
import com.swp391.se2006.g2.vmfruit.dto.request.ResetPasswordRequest;
import com.swp391.se2006.g2.vmfruit.dto.request.VerifyOtpRequest;
import com.swp391.se2006.g2.vmfruit.entity.PasswordResetToken;
import com.swp391.se2006.g2.vmfruit.entity.User;
import com.swp391.se2006.g2.vmfruit.exception.ForgotPasswordException;
import com.swp391.se2006.g2.vmfruit.repository.PasswordResetTokenRepository;
import com.swp391.se2006.g2.vmfruit.service.EmailService;
import com.swp391.se2006.g2.vmfruit.service.UserService;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.security.SecureRandom;
import java.time.LocalDateTime;
import java.util.UUID;

@Controller
public class ForgotPasswordController {

    private final UserService userService;
    private final EmailService emailService;
    private final PasswordResetTokenRepository tokenRepository;

    private static final SecureRandom RANDOM = new SecureRandom();

    public ForgotPasswordController(UserService userService,
                                    EmailService emailService,
                                    PasswordResetTokenRepository tokenRepository) {
        this.userService = userService;
        this.emailService = emailService;
        this.tokenRepository = tokenRepository;
    }

    @GetMapping("/forgot-password")
    public String showForgotPasswordForm() {
        return "forgot-password";
    }

    @PostMapping("/forgot-password")
    @Transactional
    public String handleForgotPassword(@ModelAttribute ForgotPasswordRequest request,
                                       Model model) {
        String email = request.getEmail();
        if (email == null || email.trim().isEmpty()) {
            model.addAttribute("error", "Vui lòng nhập email.");
            return "forgot-password";
        }

        try {
            User user = userService.findByEmail(email.trim().toLowerCase());

            tokenRepository.deleteByUser(user);

            String token = UUID.randomUUID().toString();
            String otp = String.format("%06d", RANDOM.nextInt(999999));

            PasswordResetToken resetToken = new PasswordResetToken();
            resetToken.setToken(token);
            resetToken.setOtp(otp);
            resetToken.setUser(user);
            resetToken.setExpiryDate(LocalDateTime.now().plusMinutes(30));
            resetToken.setUsed(false);
            resetToken.setVerified(false);
            tokenRepository.save(resetToken);

            emailService.sendPasswordResetOtp(user.getEmail(), otp, user.getFullName());

            return "redirect:/verify-otp?token=" + token;
        } catch (ForgotPasswordException e) {
            model.addAttribute("error", e.getMessage());
        } catch (Exception e) {
            model.addAttribute("error", "Không thể gửi email. Vui lòng thử lại sau.");
        }

        return "forgot-password";
    }

    @GetMapping("/verify-otp")
    public String showVerifyOtpForm(@RequestParam("token") String token,
                                    Model model) {
        PasswordResetToken resetToken = tokenRepository.findByToken(token).orElse(null);

        if (resetToken == null || resetToken.getUsed()
                || resetToken.getExpiryDate().isBefore(LocalDateTime.now())) {
            model.addAttribute("error", "Yêu cầu đặt lại mật khẩu không hợp lệ hoặc đã hết hạn.");
            return "forgot-password";
        }

        model.addAttribute("token", token);
        return "verify-otp";
    }

    @PostMapping("/verify-otp")
    @Transactional
    public String handleVerifyOtp(@ModelAttribute VerifyOtpRequest request,
                                  Model model) {
        String token = request.getToken();
        String otp = request.getOtp();

        PasswordResetToken resetToken = tokenRepository.findByToken(token).orElse(null);

        if (resetToken == null || resetToken.getUsed()
                || resetToken.getExpiryDate().isBefore(LocalDateTime.now())) {
            model.addAttribute("error", "Yêu cầu đặt lại mật khẩu không hợp lệ hoặc đã hết hạn.");
            return "forgot-password";
        }

        if (otp == null || !otp.equals(resetToken.getOtp())) {
            model.addAttribute("error", "Mã xác nhận không đúng.");
            model.addAttribute("token", token);
            return "verify-otp";
        }

        resetToken.setVerified(true);
        tokenRepository.save(resetToken);

        return "redirect:/reset-password?token=" + token;
    }

    @GetMapping("/reset-password")
    public String showResetPasswordForm(@RequestParam("token") String token,
                                        Model model) {
        PasswordResetToken resetToken = tokenRepository.findByToken(token).orElse(null);

        if (resetToken == null || resetToken.getUsed()
                || !resetToken.getVerified()
                || resetToken.getExpiryDate().isBefore(LocalDateTime.now())) {
            model.addAttribute("error", "Yêu cầu đặt lại mật khẩu không hợp lệ hoặc đã hết hạn.");
            return "forgot-password";
        }

        model.addAttribute("token", token);
        return "reset-password";
    }

    @PostMapping("/reset-password")
    @Transactional
    public String handleResetPassword(@ModelAttribute ResetPasswordRequest request,
                                      Model model) {
        String token = request.getToken();
        String password = request.getPassword();
        String confirmPassword = request.getConfirmPassword();

        PasswordResetToken resetToken = tokenRepository.findByToken(token).orElse(null);

        if (resetToken == null || resetToken.getUsed()
                || !resetToken.getVerified()
                || resetToken.getExpiryDate().isBefore(LocalDateTime.now())) {
            model.addAttribute("error", "Yêu cầu đặt lại mật khẩu không hợp lệ hoặc đã hết hạn.");
            return "forgot-password";
        }

        if (password == null || password.trim().isEmpty()) {
            model.addAttribute("error", "Vui lòng nhập mật khẩu mới.");
            model.addAttribute("token", token);
            return "reset-password";
        }

        if (!password.equals(confirmPassword)) {
            model.addAttribute("error", "Mật khẩu xác nhận không khớp.");
            model.addAttribute("token", token);
            return "reset-password";
        }

        if (!password.matches("^(?=.*[A-Za-z])(?=.*\\d).{8,}$")) {
            model.addAttribute("error", "Mật khẩu tối thiểu 8 ký tự, gồm chữ và số.");
            model.addAttribute("token", token);
            return "reset-password";
        }

        userService.updatePassword(resetToken.getUser().getUserId(), password);
        resetToken.setUsed(true);
        tokenRepository.save(resetToken);

        return "redirect:/login?resetSuccess=true";
    }
}
