package com.swp391.se2006.g2.vmfruit.controller;

import com.swp391.se2006.g2.vmfruit.entity.Role;
import com.swp391.se2006.g2.vmfruit.entity.User;
import com.swp391.se2006.g2.vmfruit.entity.UserRole;
import com.swp391.se2006.g2.vmfruit.repository.RoleRepository;
import com.swp391.se2006.g2.vmfruit.repository.UserRepository;
import com.swp391.se2006.g2.vmfruit.repository.UserRoleRepository;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.io.IOException;
import java.util.Optional;

@Controller
public class DebugController {

    private final UserRepository userRepository;
    private final RoleRepository roleRepository;
    private final UserRoleRepository userRoleRepository;
    private final PasswordEncoder passwordEncoder;

    public DebugController(UserRepository userRepository,
                          RoleRepository roleRepository,
                          UserRoleRepository userRoleRepository,
                          PasswordEncoder passwordEncoder) {
        this.userRepository = userRepository;
        this.roleRepository = roleRepository;
        this.userRoleRepository = userRoleRepository;
        this.passwordEncoder = passwordEncoder;
    }

    @GetMapping("/debug-reset-admin")
    public String debugResetAdmin(@RequestParam(required = false) String phone,
                                 @RequestParam(required = false) String email,
                                 @RequestParam(required = false, defaultValue = "admin123") String password,
                                 HttpServletResponse response) throws IOException {
        User user = null;

        if (phone != null && !phone.isEmpty()) {
            Optional<User> found = userRepository.findFirstByPhone(phone);
            if (found.isPresent()) {
                user = found.get();
            }
        }

        if (user == null && email != null && !email.isEmpty()) {
            Optional<User> found = userRepository.findByEmailIgnoreCase(email);
            if (found.isPresent()) {
                user = found.get();
            }
        }

        if (user == null) {
            response.setContentType("text/plain");
            response.getWriter().write("User not found!");
            return null;
        }

        String encodedPassword = passwordEncoder.encode(password);

        StringBuilder info = new StringBuilder();
        info.append("=== DEBUG INFO ===\n");
        info.append("User ID: ").append(user.getUserId()).append("\n");
        info.append("Email: ").append(user.getEmail()).append("\n");
        info.append("Phone: ").append(user.getPhone()).append("\n");
        info.append("Current Hash: ").append(user.getPasswordHash()).append("\n");
        info.append("New Hash for '").append(password).append("': ").append(encodedPassword).append("\n");

        // Reset password
        user.setPasswordHash(encodedPassword);
        userRepository.save(user);

        // Gán ADMIN role
        Optional<Role> adminRole = roleRepository.findByRoleName("ADMIN");
        if (adminRole.isPresent()) {
            long count = userRoleRepository.countByUserIdAndRoleName(user.getUserId(), "ADMIN");
            if (count == 0) {
                UserRole ur = new UserRole();
                ur.setUser(user);
                ur.setRole(adminRole.get());
                userRoleRepository.save(ur);
                info.append("Added ADMIN role.\n");
            } else {
                info.append("Already has ADMIN role.\n");
            }
        } else {
            info.append("ADMIN role not found in database!\n");
        }

        info.append("Password reset SUCCESS!\n");
        info.append("Login with: phone=").append(user.getPhone()).append(", password=").append(password).append("\n");

        response.setContentType("text/plain");
        response.getWriter().write(info.toString());
        return null;
    }
}
