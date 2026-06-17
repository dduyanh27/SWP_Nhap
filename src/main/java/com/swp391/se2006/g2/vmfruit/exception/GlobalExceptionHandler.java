package com.swp391.se2006.g2.vmfruit.exception;

import jakarta.servlet.http.HttpServletRequest;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;

@ControllerAdvice
public class GlobalExceptionHandler {

    private static final Logger log = LoggerFactory.getLogger(GlobalExceptionHandler.class);

    /**
     * Chỉ xử lý các exception thực sự KHÔNG được controller nào bắt.
     * LoginException / RegistrationException / ForgotPasswordException là business exception,
     * đã được catch trong controller riêng → KHÔNG khai báo ở đây.
     *
     * Dùng assignableTypes để loại trừ chính xác các business exception,
     * giữ lại chỉ những lỗi hạ tầng thực sự (DB, NPE, v.v.)
     */
    @ExceptionHandler(value = {
            // Chỉ bắt Exception thuần, KHÔNG bắt các RuntimeException business đã có controller handle
            java.lang.IllegalStateException.class,
            java.lang.IllegalArgumentException.class,
            java.lang.NullPointerException.class,
            org.springframework.dao.DataAccessException.class,
            java.sql.SQLException.class,
            org.springframework.web.servlet.NoHandlerFoundException.class,
            Exception.class
    })
    public String handleAllExceptions(Exception ex, HttpServletRequest request, Model model) {
        // Các business exception được handle ở controller — không nên bắt ở đây
        if (ex instanceof LoginException
                || ex instanceof RegistrationException
                || ex instanceof ForgotPasswordException) {
            // Ném lại nguyên để Spring MVC tiếp tục tìm handler phù hợp
            throw (RuntimeException) ex;
        }

        // Bỏ qua favicon.ico — browser luôn request, không phải lỗi ứng dụng
        if ("/favicon.ico".equals(request.getRequestURI())) {
            return null;
        }

        log.error("Unhandled exception on URI [{}]: {}", request.getRequestURI(), ex.getMessage(), ex);
        model.addAttribute("errorMessage", ex.getMessage());
        model.addAttribute("requestUri", request.getRequestURI());
        return "error";
    }
}