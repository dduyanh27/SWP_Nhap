package com.swp391.se2006.g2.vmfruit.controller;

import com.swp391.se2006.g2.vmfruit.dto.request.LoginRequest;
import com.swp391.se2006.g2.vmfruit.entity.User;
import com.swp391.se2006.g2.vmfruit.exception.LoginException;
import com.swp391.se2006.g2.vmfruit.service.UserService;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;

@Controller
public class LoginController {

    private final UserService userService;

    public LoginController(UserService userService) {
        this.userService = userService;
    }

    @GetMapping("/login")
    public String showLoginPage() {
        return "login";
    }

    @PostMapping("/login")
    public String handleLogin(@ModelAttribute LoginRequest request,
                              HttpSession session,
                              Model model) {
        try {
            User user = userService.login(request);

            session.setAttribute("currentUser", user);

            boolean isAdmin = userService.isAdmin(user.getUserId());
            boolean isSale  = userService.isSale(user.getUserId());
            session.setAttribute("isAdmin", isAdmin);
            session.setAttribute("isSalesStaff", isSale);

            if (isAdmin) return "redirect:/admin/dashboard";
            if (isSale)  return "redirect:/sales/dashboard";

            return "redirect:/home";
        } catch (LoginException ex) {
            model.addAttribute("error", ex.getMessage());
            model.addAttribute("form", request);
            return "login";
        }
    }


    @GetMapping("/logout")
    public String handleLogout(HttpSession session) {
        // Hủy bỏ session hiện tại khi người dùng nhấn Đăng xuất
        session.invalidate();
        return "redirect:/login";
    }
}
