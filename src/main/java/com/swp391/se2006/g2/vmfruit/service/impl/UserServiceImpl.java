package com.swp391.se2006.g2.vmfruit.service.impl;

import com.swp391.se2006.g2.vmfruit.dto.request.LoginRequest;
import com.swp391.se2006.g2.vmfruit.dto.request.RegisterRequest;
import com.swp391.se2006.g2.vmfruit.exception.ForgotPasswordException;
import com.swp391.se2006.g2.vmfruit.exception.RegistrationException;
import com.swp391.se2006.g2.vmfruit.exception.LoginException;
import com.swp391.se2006.g2.vmfruit.entity.Cart;
import com.swp391.se2006.g2.vmfruit.entity.Role;
import com.swp391.se2006.g2.vmfruit.entity.User;
import com.swp391.se2006.g2.vmfruit.entity.UserRole;
import com.swp391.se2006.g2.vmfruit.repository.CartRepository;
import com.swp391.se2006.g2.vmfruit.repository.RoleRepository;
import com.swp391.se2006.g2.vmfruit.repository.UserRepository;
import com.swp391.se2006.g2.vmfruit.repository.UserRoleRepository;
import com.swp391.se2006.g2.vmfruit.service.UserService;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.regex.Pattern;

@Service
public class UserServiceImpl implements UserService {

    private static final String CUSTOMER_ROLE = "CUSTOMER";
    private static final Pattern PASSWORD_PATTERN =
            Pattern.compile("^(?=.*[A-Za-z])(?=.*\\d).{8,}$");

    private final UserRepository userRepository;
    private final RoleRepository roleRepository;
    private final UserRoleRepository userRoleRepository;
    private final CartRepository cartRepository;
    private final PasswordEncoder passwordEncoder;

    public UserServiceImpl(UserRepository userRepository,
                           RoleRepository roleRepository,
                           UserRoleRepository userRoleRepository,
                           CartRepository cartRepository,
                           PasswordEncoder passwordEncoder) {
        this.userRepository = userRepository;
        this.roleRepository = roleRepository;
        this.userRoleRepository = userRoleRepository;
        this.cartRepository = cartRepository;
        this.passwordEncoder = passwordEncoder;
    }

    @Override
    @Transactional
    public void register(RegisterRequest request) {
        String fullName = trim(request.getFullName());
        String email = trim(request.getEmail()).toLowerCase();
        String phone = trim(request.getPhoneNumber());
        String password = request.getPassword();
        String confirmPassword = request.getConfirmPassword();

        if (fullName.isEmpty()) {
            throw new RegistrationException("Họ và tên không được để trống.");
        }
        if (email.isEmpty()) {
            throw new RegistrationException("Email không được để trống.");
        }
        if (phone.isEmpty()) {
            throw new RegistrationException("Số điện thoại không được để trống.");
        }
        if (!request.isAgreeTerms()) {
            throw new RegistrationException("Bạn cần đồng ý với Điều khoản & Chính sách.");
        }
        if (password == null || confirmPassword == null || !password.equals(confirmPassword)) {
            throw new RegistrationException("Mật khẩu xác nhận không khớp.");
        }
        if (!PASSWORD_PATTERN.matcher(password).matches()) {
            throw new RegistrationException("Mật khẩu tối thiểu 8 ký tự, gồm chữ và số.");
        }
        if (userRepository.existsByEmailIgnoreCase(email)) {
            throw new RegistrationException("Email đã được sử dụng.");
        }
        if (userRepository.existsByPhone(phone)) {
            throw new RegistrationException("Số điện thoại đã được sử dụng.");
        }

        Role customerRole = roleRepository.findByRoleName(CUSTOMER_ROLE)
                .orElseThrow(() -> new RegistrationException("Hệ thống chưa cấu hình role CUSTOMER."));

        LocalDateTime now = LocalDateTime.now();

        User user = new User();
        user.setFullName(fullName);
        user.setEmail(email);
        user.setPhone(phone);
        user.setPasswordHash(passwordEncoder.encode(password));
        user.setStatus("ACTIVE");
        user.setCreatedAt(now);
        user = userRepository.save(user);

        UserRole userRole = new UserRole();
        userRole.setUser(user);
        userRole.setRole(customerRole);
        userRoleRepository.save(userRole);

        Cart cart = new Cart();
        cart.setUser(user);
        cart.setCreatedAt(now);
        cart.setUpdatedAt(now);
        cartRepository.save(cart);
    }

    @Override
    public User login(LoginRequest request) {
        String phone = trim(request.getPhone());
        String password = trim(request.getPassword());

        if (phone.isEmpty()) {
            throw new LoginException("SDT không được để trống!");
        }
        if (password.isEmpty()) {
            throw new LoginException("Mật khẩu không được để trống.");
        }

        User user = userRepository.findByPhone(phone)
                .orElseThrow(() -> new LoginException("Số điện thoại hoặc mật khẩu không chính xác."));

        if (!passwordEncoder.matches(password, user.getPasswordHash())) {
            throw new LoginException("Số điện thoại hoặc mật khẩu không chính xác.");
        }

        if (!"ACTIVE".equalsIgnoreCase(user.getStatus())) {
            throw new LoginException("Tài khoản của bạn đã bị khóa hoặc chưa kích hoạt.");
        }

        return user;
    }

    @Override
    public User findByEmail(String email) {
        return userRepository.findByEmailIgnoreCase(trim(email))
                .orElseThrow(() -> new ForgotPasswordException("Email không tồn tại trong hệ thống."));
    }

    @Override
    @Transactional
    public void updatePassword(Integer userId, String newPassword) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new ForgotPasswordException("Người dùng không tồn tại."));
        user.setPasswordHash(passwordEncoder.encode(newPassword));
        user.setUpdatedAt(LocalDateTime.now());
        userRepository.save(user);
    }

    @Override
    public boolean isAdmin(Integer userId) {
        return userRoleRepository.existsByUserUserIdAndRoleRoleName(userId, "ADMIN");
    }

    private static String trim(String value) {
        return value == null ? "" : value.trim();
    }
}
