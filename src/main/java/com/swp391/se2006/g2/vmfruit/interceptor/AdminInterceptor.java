package com.swp391.se2006.g2.vmfruit.interceptor;

import com.swp391.se2006.g2.vmfruit.entity.User;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

@Component
public class AdminInterceptor implements HandlerInterceptor {

    private static final Logger log = LoggerFactory.getLogger(AdminInterceptor.class);

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        HttpSession session = request.getSession(false);

        String path = request.getRequestURI().substring(request.getContextPath().length());
        log.debug("AdminInterceptor: Kiểm tra path = {}", path);

        User currentUser = null;
        if (session != null) {
            currentUser = (User) session.getAttribute("currentUser");
        }

        // 1. Nếu chưa đăng nhập -> Chuyển hướng về trang login
        if (currentUser == null) {
            log.warn("AdminInterceptor: Chưa đăng nhập khi vào {}, redirect /login", path);
            response.sendRedirect(request.getContextPath() + "/login?error=nologin");
            return false;
        }

        // 2. Đọc quyền từ session, nếu null thì mặc định gán là false thay vì crash/báo lỗi
        Boolean isAdmin = (Boolean) session.getAttribute("isAdmin");
        Boolean isSalesStaff = (Boolean) session.getAttribute("isSalesStaff");

        if (isAdmin == null) isAdmin = false;
        if (isSalesStaff == null) isSalesStaff = false;

        log.info("AdminInterceptor: userId={}, path={}, isAdmin={}, isSalesStaff={}",
                currentUser.getUserId(), path, isAdmin, isSalesStaff);

        // 3. Kiểm tra phân quyền cho phân vùng /admin/**
        if (path.startsWith("/admin")) {
            if (Boolean.TRUE.equals(isAdmin)) {
                return true; // Hợp lệ, cho Admin đi tiếp
            }
            if (Boolean.TRUE.equals(isSalesStaff)) {
                log.warn("AdminInterceptor: Sales cố vào admin -> redirect /sales/dashboard");
                response.sendRedirect(request.getContextPath() + "/sales/dashboard");
                return false;
            }
            // Khách hàng vãng lai cố vào admin -> Đá ra trang chủ
            response.sendRedirect(request.getContextPath() + "/?error=unauthorized");
            return false;
        }

        // 4. Kiểm tra phân quyền cho phân vùng /sales/**
        if (path.startsWith("/sales")) {
            if (Boolean.TRUE.equals(isSalesStaff) || Boolean.TRUE.equals(isAdmin)) {
                return true; // Cho phép Sales hoặc Admin đi tiếp
            }
            response.sendRedirect(request.getContextPath() + "/?error=unauthorized");
            return false;
        }

        return true;
    }
}