package com.swp391.se2006.g2.vmfruit.service.impl;

import com.swp391.se2006.g2.vmfruit.dto.request.AdminUserCreateRequest;
import com.swp391.se2006.g2.vmfruit.dto.request.AdminUserUpdateRequest;
import com.swp391.se2006.g2.vmfruit.dto.response.AdminUserListItemDto;
import com.swp391.se2006.g2.vmfruit.dto.response.AdminUserPageDto;
import com.swp391.se2006.g2.vmfruit.entity.Cart;
import com.swp391.se2006.g2.vmfruit.entity.Role;
import com.swp391.se2006.g2.vmfruit.entity.User;
import com.swp391.se2006.g2.vmfruit.entity.UserRole;
import com.swp391.se2006.g2.vmfruit.exception.AdminUserException;
import com.swp391.se2006.g2.vmfruit.repository.CartRepository;
import com.swp391.se2006.g2.vmfruit.repository.RoleRepository;
import com.swp391.se2006.g2.vmfruit.repository.UserRepository;
import com.swp391.se2006.g2.vmfruit.repository.UserRoleRepository;
import com.swp391.se2006.g2.vmfruit.service.AdminUserService;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.function.Function;
import java.util.regex.Pattern;
import java.util.stream.Collectors;

@Service
public class AdminUserServiceImpl implements AdminUserService {

    private static final String SALES_STAFF_ROLE = "SALES_STAFF";
    private static final String CUSTOMER_ROLE = "CUSTOMER";
    private static final Set<String> ALLOWED_ROLES = Set.of("ADMIN", SALES_STAFF_ROLE, CUSTOMER_ROLE);
    private static final Set<String> ALLOWED_STATUSES = Set.of("ACTIVE", "INACTIVE");
    private static final Pattern PASSWORD_PATTERN =
            Pattern.compile("^(?=.*[A-Za-z])(?=.*\\d).{8,}$");

    private final UserRepository userRepository;
    private final UserRoleRepository userRoleRepository;
    private final RoleRepository roleRepository;
    private final CartRepository cartRepository;
    private final PasswordEncoder passwordEncoder;

    public AdminUserServiceImpl(UserRepository userRepository,
                                UserRoleRepository userRoleRepository,
                                RoleRepository roleRepository,
                                CartRepository cartRepository,
                                PasswordEncoder passwordEncoder) {
        this.userRepository = userRepository;
        this.userRoleRepository = userRoleRepository;
        this.roleRepository = roleRepository;
        this.cartRepository = cartRepository;
        this.passwordEncoder = passwordEncoder;
    }

    @Override
    @Transactional(readOnly = true)
    public AdminUserPageDto getUserManagementPage(String roleFilter, String statusFilter) {
        AdminUserPageDto page = new AdminUserPageDto();

        LocalDateTime startOfMonth = LocalDate.now().withDayOfMonth(1).atStartOfDay();
        page.setNewUserCount(userRepository.countByCreatedAtGreaterThanEqual(startOfMonth));
        page.setTotalCustomers(userRoleRepository.countByRole_RoleName(CUSTOMER_ROLE));
        page.setTotalStaffs(userRoleRepository.countByRoleNames(List.of("ADMIN", SALES_STAFF_ROLE)));

        Map<Integer, UserRole> roleByUserId = userRoleRepository.findAllWithUserAndRole().stream()
                .collect(Collectors.toMap(ur -> ur.getUser().getUserId(), Function.identity(), (a, b) -> a));

        List<AdminUserListItemDto> users = userRepository.findAllByOrderByUserIdAsc().stream()
                .map(user -> toListItem(user, roleByUserId.get(user.getUserId())))
                .filter(item -> matchesRoleFilter(item, roleFilter))
                .filter(item -> matchesStatusFilter(item, statusFilter))
                .collect(Collectors.toList());

        page.setUserList(users);
        return page;
    }

    @Override
    @Transactional(readOnly = true)
    public AdminUserListItemDto getUserForEdit(Integer userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new AdminUserException("Không tìm thấy người dùng."));
        UserRole userRole = userRoleRepository.findByUser_UserId(userId).orElse(null);
        return toListItem(user, userRole);
    }

    @Override
    @Transactional
    public void createUser(AdminUserCreateRequest request) {
        String fullName = trim(request.getFullName());
        String email = trim(request.getEmail()).toLowerCase();
        String phone = trim(request.getPhoneNumber());
        String password = request.getPassword();
        String confirmPassword = request.getConfirmPassword();
        String roleName = trim(request.getRole()).toUpperCase();
        String status = trim(request.getStatus()).toUpperCase();

        validateCommonFields(fullName, email, phone);
        validateRoleAndStatus(roleName, status);
        validatePassword(password, confirmPassword);

        if (userRepository.existsByEmailIgnoreCase(email)) {
            throw new AdminUserException("Email đã được sử dụng.");
        }
        if (userRepository.existsByPhone(phone)) {
            throw new AdminUserException("Số điện thoại đã được sử dụng.");
        }

        Role role = roleRepository.findByRoleName(roleName)
                .orElseThrow(() -> new AdminUserException("Hệ thống chưa cấu hình role " + roleName + "."));

        LocalDateTime now = LocalDateTime.now();

        User user = new User();
        user.setFullName(fullName);
        user.setEmail(email);
        user.setPhone(phone);
        user.setPasswordHash(passwordEncoder.encode(password));
        user.setStatus(status);
        user.setCreatedAt(now);
        user.setUpdatedAt(now);
        user = userRepository.save(user);

        UserRole userRole = new UserRole();
        userRole.setUser(user);
        userRole.setRole(role);
        userRoleRepository.save(userRole);

        Cart cart = new Cart();
        cart.setUser(user);
        cart.setCreatedAt(now);
        cart.setUpdatedAt(now);
        cartRepository.save(cart);
    }

    @Override
    @Transactional
    public void updateUser(AdminUserUpdateRequest request) {
        if (request.getUserId() == null) {
            throw new AdminUserException("Thiếu mã người dùng.");
        }

        User user = userRepository.findById(request.getUserId())
                .orElseThrow(() -> new AdminUserException("Không tìm thấy người dùng."));

        String fullName = trim(request.getFullName());
        String email = trim(request.getEmail()).toLowerCase();
        String phone = trim(request.getPhoneNumber());
        String roleName = trim(request.getRole()).toUpperCase();
        validateCommonFields(fullName, email, phone);

        if (!ALLOWED_ROLES.contains(roleName)) {
            throw new AdminUserException("Vai trò không hợp lệ.");
        }

        userRepository.findByEmail(email).ifPresent(existing -> {
            if (!existing.getUserId().equals(user.getUserId())) {
                throw new AdminUserException("Email đã được sử dụng.");
            }
        });
        if (userRepository.existsByPhone(phone) && !phone.equals(user.getPhone())) {
            throw new AdminUserException("Số điện thoại đã được sử dụng.");
        }

        user.setFullName(fullName);
        user.setEmail(email);
        user.setPhone(phone);
        user.setUpdatedAt(LocalDateTime.now());
        userRepository.save(user);

        Role newRole = roleRepository.findByRoleName(roleName)
                .orElseThrow(() -> new AdminUserException("Hệ thống chưa cấu hình role " + roleName + "."));

        UserRole userRole = userRoleRepository.findByUser_UserId(user.getUserId()).orElse(null);
        if (userRole == null) {
            userRole = new UserRole();
            userRole.setUser(user);
            userRole.setRole(newRole);
        } else {
            userRole.setRole(newRole);
        }
        userRoleRepository.save(userRole);
    }

    @Override
    @Transactional
    public void lockUser(Integer userId) {
        updateStatus(userId, "INACTIVE");
    }

    @Override
    @Transactional
    public void unlockUser(Integer userId) {
        updateStatus(userId, "ACTIVE");
    }

    private void updateStatus(Integer userId, String status) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new AdminUserException("Không tìm thấy người dùng."));
        user.setStatus(status);
        user.setUpdatedAt(LocalDateTime.now());
        userRepository.save(user);
    }

    private AdminUserListItemDto toListItem(User user, UserRole userRole) {
        String roleName = userRole != null ? userRole.getRole().getRoleName() : null;

        AdminUserListItemDto dto = new AdminUserListItemDto();
        dto.setUserId(user.getUserId());
        dto.setUserIdDisplay(formatUserId(user.getUserId()));
        dto.setFullName(user.getFullName());
        dto.setEmail(user.getEmail());
        dto.setPhone(user.getPhone());
        dto.setRole(roleName);
        dto.setRoleDisplay(roleName != null ? toRoleDisplay(roleName) : "Chưa gán");
        dto.setStatus(user.getStatus());
        return dto;
    }

    private static String formatUserId(Integer userId) {
        return String.format("U%03d", userId);
    }

    private static String toRoleDisplay(String roleName) {
        return switch (roleName) {
            case "ADMIN" -> "Admin";
            case SALES_STAFF_ROLE -> "Staff";
            case CUSTOMER_ROLE -> "Customer";
            default -> roleName;
        };
    }

    private static boolean matchesRoleFilter(AdminUserListItemDto item, String roleFilter) {
        if (roleFilter == null || roleFilter.isBlank()) {
            return true;
        }
        return roleFilter.equalsIgnoreCase(item.getRole());
    }

    private static boolean matchesStatusFilter(AdminUserListItemDto item, String statusFilter) {
        if (statusFilter == null || statusFilter.isBlank()) {
            return true;
        }
        return statusFilter.equalsIgnoreCase(item.getStatus());
    }

    private static void validateRoleAndStatus(String roleName, String status) {
        if (!ALLOWED_ROLES.contains(roleName)) {
            throw new AdminUserException("Vai trò không hợp lệ.");
        }
        if (!ALLOWED_STATUSES.contains(status)) {
            throw new AdminUserException("Trạng thái không hợp lệ.");
        }
    }

    private static void validatePassword(String password, String confirmPassword) {
        if (password == null || confirmPassword == null || !password.equals(confirmPassword)) {
            throw new AdminUserException("Mật khẩu xác nhận không khớp.");
        }
        if (!PASSWORD_PATTERN.matcher(password).matches()) {
            throw new AdminUserException("Mật khẩu tối thiểu 8 ký tự, gồm chữ và số.");
        }
    }

    private static void validateCommonFields(String fullName, String email, String phone) {
        if (fullName.isEmpty()) {
            throw new AdminUserException("Họ và tên không được để trống.");
        }
        if (email.isEmpty()) {
            throw new AdminUserException("Email không được để trống.");
        }
        if (phone.isEmpty()) {
            throw new AdminUserException("Số điện thoại không được để trống.");
        }
    }

    private static String trim(String value) {
        return value == null ? "" : value.trim();
    }
}
