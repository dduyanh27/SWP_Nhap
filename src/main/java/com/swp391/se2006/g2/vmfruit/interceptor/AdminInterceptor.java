package com.swp391.se2006.g2.vmfruit.interceptor;

import com.swp391.se2006.g2.vmfruit.entity.User;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

import java.util.List;

@Component
public class AdminInterceptor implements HandlerInterceptor {

    private static final Logger log = LoggerFactory.getLogger(AdminInterceptor.class);

    // Các path chỉ ADMIN mới được vào (SALES_STAFF bị chặn)
    private static final List<String> ADMIN_ONLY_PATHS = List.of(
            "/admin/users",
            "/admin/reports",
            "/admin/dashboard"
    );

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        HttpSession session = request.getSession(false); // false = không tạo session mới nếu chưa có

        log.debug("AdminInterceptor: Checking URI = {}", request.getRequestURI());

        // Lấy user từ session
        User currentUser = null;
        if (session != null) {
            currentUser = (User) session.getAttribute("currentUser");
        }

        if (currentUser == null) {
            log.debug("AdminInterceptor: Chưa đăng nhập → redirect /login?error=nologin");
            response.sendRedirect(request.getContextPath() + "/login?error=nologin");
            return false;
        }

        // Ưu tiên đọc role từ session (đã được set khi đăng nhập), tránh query DB lại mỗi request
        Boolean isAdmin = (Boolean) session.getAttribute("isAdmin");
        Boolean isSalesStaff = (Boolean) session.getAttribute("isSalesStaff");

        // Fallback: nếu session không có (ví dụ Google OAuth redirect thẳng), đọc từ DB
        if (isAdmin == null || isSalesStaff == null) {
            log.warn("AdminInterceptor: Session thiếu isAdmin/isSalesStaff cho userId={}. Session có thể đã hết hạn hoặc OAuth login chưa set.", currentUser.getUserId());
            response.sendRedirect(request.getContextPath() + "/login?error=nologin");
            return false;
        }

        // Lấy path tương đối so với context
        String path = request.getRequestURI().substring(request.getContextPath().length());
        log.debug("AdminInterceptor: userId={}, path={}, isAdmin={}, isSalesStaff={}", currentUser.getUserId(), path, isAdmin, isSalesStaff);

        if (Boolean.TRUE.equals(isAdmin)) {
            log.debug("AdminInterceptor: ADMIN → cho phép truy cập {}", path);
            return true;
        }

        if (Boolean.TRUE.equals(isSalesStaff)) {
            boolean isAccessingAdminOnly = ADMIN_ONLY_PATHS.stream().anyMatch(path::startsWith);
            if (isAccessingAdminOnly) {
                log.debug("AdminInterceptor: SALES_STAFF cố vào admin-only path → redirect /sales/dashboard");
                response.sendRedirect(request.getContextPath() + "/sales/dashboard");
                return false;
            }
            log.debug("AdminInterceptor: SALES_STAFF → cho phép truy cập {}", path);
            return true;
        }

        // CUSTOMER hoặc role khác → về trang chủ
        log.debug("AdminInterceptor: Role không hợp lệ → redirect /");
        response.sendRedirect(request.getContextPath() + "/");
        return false;
    }
}
