package com.swp391.se2006.g2.vmfruit.controller;

import com.swp391.se2006.g2.vmfruit.dto.request.RegisterRequest;
import com.swp391.se2006.g2.vmfruit.exception.RegistrationException;
import com.swp391.se2006.g2.vmfruit.service.UserService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
public class RegisterController {

    private final UserService userService;

    public RegisterController(UserService userService) {
        this.userService = userService;
    }

    @GetMapping("/register")
    public String showRegisterPage() {
        return "register";
    }

    @PostMapping("/register")
    public String handleRegister(@ModelAttribute RegisterRequest request,
                                 Model model,
                                 RedirectAttributes redirectAttributes) {
        try {
            userService.register(request);
            redirectAttributes.addFlashAttribute("success", "Đăng ký thành công. Vui lòng đăng nhập.");
            return "redirect:/login";
        } catch (RegistrationException ex) {
            model.addAttribute("error", ex.getMessage());
            model.addAttribute("form", request);
            return "register";
        }
    }
}
