package com.swp391.se2006.g2.vmfruit.config;

import com.swp391.se2006.g2.vmfruit.entity.Role;
import com.swp391.se2006.g2.vmfruit.entity.User;
import com.swp391.se2006.g2.vmfruit.entity.UserRole;
import com.swp391.se2006.g2.vmfruit.repository.RoleRepository;
import com.swp391.se2006.g2.vmfruit.repository.UserRepository;
import com.swp391.se2006.g2.vmfruit.repository.UserRoleRepository;
import org.springframework.boot.CommandLineRunner;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;

import java.time.LocalDateTime;
import java.util.Optional;

@Component
public class AdminDataSeeder implements CommandLineRunner {

    private final RoleRepository roleRepository;
    private final UserRepository userRepository;
    private final UserRoleRepository userRoleRepository;
    private final PasswordEncoder passwordEncoder;

    public AdminDataSeeder(RoleRepository roleRepository,
                           UserRepository userRepository,
                           UserRoleRepository userRoleRepository,
                           PasswordEncoder passwordEncoder) {
        this.roleRepository = roleRepository;
        this.userRepository = userRepository;
        this.userRoleRepository = userRoleRepository;
        this.passwordEncoder = passwordEncoder;
    }

    @Override
    public void run(String... args) {
        Role adminRole = roleRepository.findByRoleName("ADMIN")
                .orElseGet(() -> {
                    Role r = new Role();
                    r.setRoleName("ADMIN");
                    r.setDescription("Administrator");
                    return roleRepository.save(r);
                });

        if (roleRepository.findByRoleName("CUSTOMER").isEmpty()) {
            Role customerRole = new Role();
            customerRole.setRoleName("CUSTOMER");
            customerRole.setDescription("Customer");
            roleRepository.save(customerRole);
        }

        User admin = userRepository.findByEmailIgnoreCase("admin@vmfruit.com")
                .orElse(null);

        if (admin == null) {
            admin = new User();
            admin.setFullName("Admin VMFruit");
            admin.setEmail("admin@vmfruit.com");
            admin.setPhone("0123456789");
            admin.setCreatedAt(LocalDateTime.now());
        }

        admin.setPasswordHash(passwordEncoder.encode("admin123"));
        admin.setStatus("ACTIVE");
        admin = userRepository.save(admin);

        boolean hasAdminRole = userRoleRepository
                .existsByUserUserIdAndRoleRoleName(admin.getUserId(), "ADMIN");
        if (!hasAdminRole) {
            UserRole ur = new UserRole();
            ur.setUser(admin);
            ur.setRole(adminRole);
            userRoleRepository.save(ur);
        }
    }
}
