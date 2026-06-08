package com.swp391.se2006.g2.vmfruit.config;

import com.swp391.se2006.g2.vmfruit.entity.Cart;
import com.swp391.se2006.g2.vmfruit.entity.Role;
import com.swp391.se2006.g2.vmfruit.entity.User;
import com.swp391.se2006.g2.vmfruit.entity.UserRole;
import com.swp391.se2006.g2.vmfruit.repository.CartRepository;
import com.swp391.se2006.g2.vmfruit.repository.RoleRepository;
import com.swp391.se2006.g2.vmfruit.repository.UserRepository;
import com.swp391.se2006.g2.vmfruit.repository.UserRoleRepository;
import com.swp391.se2006.g2.vmfruit.service.UserService;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.springframework.security.core.Authentication;
import org.springframework.security.oauth2.core.user.OAuth2User;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import org.springframework.stereotype.Component;

import java.io.IOException;
import java.time.LocalDateTime;

@Component
public class OAuth2LoginSuccessHandler implements AuthenticationSuccessHandler {

    private final UserRepository userRepository;
    private final RoleRepository roleRepository;
    private final UserRoleRepository userRoleRepository;
    private final CartRepository cartRepository;
    private final UserService userService;

    public OAuth2LoginSuccessHandler(UserRepository userRepository,
                                     RoleRepository roleRepository,
                                     UserRoleRepository userRoleRepository,
                                     CartRepository cartRepository,
                                     UserService userService) {
        this.userRepository = userRepository;
        this.roleRepository = roleRepository;
        this.userRoleRepository = userRoleRepository;
        this.cartRepository = cartRepository;
        this.userService = userService;
    }

    @Override
    public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response,
                                        Authentication authentication) throws IOException, ServletException {

        OAuth2User oAuth2User = (OAuth2User) authentication.getPrincipal();
        String email = oAuth2User.getAttribute("email");
        String fullName = oAuth2User.getAttribute("name");

        User user = userRepository.findByEmail(email).orElse(null);

        if (user == null) {
            LocalDateTime now = LocalDateTime.now();

            user = new User();
            user.setFullName(fullName != null ? fullName : "Google User");
            user.setEmail(email);
            user.setPhone("");
            user.setPasswordHash("");
            user.setStatus("ACTIVE");
            user.setCreatedAt(now);
            user = userRepository.save(user);

            Role customerRole = roleRepository.findByRoleName("CUSTOMER").orElse(null);
            if (customerRole != null) {
                UserRole userRole = new UserRole();
                userRole.setUser(user);
                userRole.setRole(customerRole);
                userRoleRepository.save(userRole);
            }

            Cart cart = new Cart();
            cart.setUser(user);
            cart.setCreatedAt(now);
            cart.setUpdatedAt(now);
            cartRepository.save(cart);
        }

        HttpSession session = request.getSession();
        session.setAttribute("currentUser", user);

        boolean isAdmin = userService.isAdmin(user.getUserId());
        session.setAttribute("isAdmin", isAdmin);

        if (isAdmin) {
            response.sendRedirect("/admin/dashboard");
        } else {
            response.sendRedirect("/");
        }
    }
}