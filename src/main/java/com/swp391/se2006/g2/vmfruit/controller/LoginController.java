package com.swp391.se2006.g2.vmfruit.controller;

import com.swp391.se2006.g2.vmfruit.dto.request.LoginRequest;
import com.swp391.se2006.g2.vmfruit.entity.User;
import com.swp391.se2006.g2.vmfruit.exception.LoginException;
import com.swp391.se2006.g2.vmfruit.service.UserService;
import jakarta.servlet.http.HttpSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class LoginController {

    private static final Logger log = LoggerFactory.getLogger(LoginController.class);

    private final UserService userService;

    public LoginController(UserService userService) {
        this.userService = userService;
    }

    @GetMapping("/login")
    public String showLoginPage(HttpSession session,
                                Model model,
                                @RequestParam(value = "error", required = false) String error) {
        // Nếu đã đăng nhập rồi thì redirect thẳng luôn, không hiện lại trang login
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser != null) {
            Boolean isAdmin = (Boolean) session.getAttribute("isAdmin");
            Boolean isSalesStaff = (Boolean) session.getAttribute("isSalesStaff");
            if (Boolean.TRUE.equals(isAdmin)) return "redirect:/admin/dashboard";
            if (Boolean.TRUE.equals(isSalesStaff)) return "redirect:/sales/dashboard";
            return "redirect:/home";
        }

        // Hiện thông báo khi bị Interceptor redirect về login
        if ("nologin".equals(error)) {
            model.addAttribute("error", "Vui lòng đăng nhập để tiếp tục.");
        } else if ("unauthorized".equals(error)) {
            model.addAttribute("error", "Bạn không có quyền truy cập trang này.");
        }

        // Khởi tạo form rỗng để JSP không bị NullPointerException với ${form.phone}
        model.addAttribute("form", new LoginRequest());
        return "login";
    }

    @PostMapping("/login")
    public String handleLogin(@ModelAttribute("form") LoginRequest request,
                              HttpSession session,
                              Model model) {
        try {
            User user = userService.login(request);

            session.setAttribute("currentUser", user);

            boolean isAdmin = userService.isAdmin(user.getUserId());
            session.setAttribute("isAdmin", isAdmin);

            boolean isSalesStaff = userService.isSalesStaff(user.getUserId());
            session.setAttribute("isSalesStaff", isSalesStaff);

            log.info("Login success: userId={}, isAdmin={}, isSalesStaff={}", user.getUserId(), isAdmin, isSalesStaff);

            if (isAdmin) {
                return "redirect:/admin/dashboard";
            }
            if (isSalesStaff) {
                return "redirect:/sales/dashboard";
            }

            return "redirect:/home";
        } catch (LoginException ex) {
            model.addAttribute("error", ex.getMessage());
            model.addAttribute("form", request);
            return "login";
        } catch (Exception ex) {
            // Log đầy đủ stack trace để dễ debug
            log.error("Lỗi không mong đợi khi đăng nhập phone=[{}]: {}", request.getPhone(), ex.getMessage(), ex);
            // Hiện message thật để dễ chẩn đoán — sau khi fix xong có thể đổi về message thân thiện
            model.addAttribute("error", "[LỖI] " + ex.getClass().getSimpleName() + ": " + ex.getMessage());
            model.addAttribute("form", request);
            return "login";
        }
    }

    @GetMapping("/logout")
    public String handleLogout(HttpSession session) {
        session.invalidate();
        return "redirect:/login";
    }
}
