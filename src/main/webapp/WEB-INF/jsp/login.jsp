<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>VMFruit - Đăng nhập</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/auth.css">
</head>
<body>

    <jsp:include page="common/auth-left.jsp">
        <jsp:param name="subtitle" value="Nền tảng cung cấp trái cây sạch và an toàn nhất cho gia đình bạn." />
    </jsp:include>

    <div class="right-panel">
        <div class="login-container">
            <div class="login-header">
                <h2>Đăng nhập</h2>
                <p>Chào mừng bạn quay lại! Vui lòng nhập thông tin tài khoản.</p>
            </div>

            <c:if test="${not empty success}">
                <div class="success-msg">${success}</div>
            </c:if>

            <c:if test="${not empty error}">
                <div class="error-msg">${error}</div>
            </c:if>
            
            <c:if test="${param.resetSuccess eq 'true'}">
                <div class="success-msg">Mật khẩu đã được đặt lại thành công. Vui lòng đăng nhập.</div>
            </c:if>

            <form action="${pageContext.request.contextPath}/login" method="POST">
                <div class="form-group">
                    <label>Số điện thoại</label>
                    <input type="text" class="form-control" name="phone"
                           value="${form.phone}"
                           placeholder="Nhập số điện thoại người dùng..." required>
                </div>

                <div class="form-group">
                    <label>Mật khẩu</label>
                    <div class="input-wrapper">
                        <input type="password" class="form-control" name="password" placeholder="••••••••" required>
                        <span class="password-toggle">
                            <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                                <path stroke-linecap="round" stroke-linejoin="round" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
                                <path stroke-linecap="round" stroke-linejoin="round" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z" />
                            </svg>
                        </span>
                    </div>
                </div>

                <div class="form-options">
                    <label class="checkbox-label">
                        <input type="checkbox" name="rememberMe"> Ghi nhớ đăng nhập
                    </label>
                    <a href="${pageContext.request.contextPath}/forgot-password" class="link-green">Quên mật khẩu?</a>
                </div>

                <button type="submit" class="btn-submit">Đăng nhập</button>
            </form>

            <div class="divider">hoặc</div>

            <button type="button" class="btn-google" onclick="window.location.href='/oauth2/authorization/google'">
                <span class="google-icon">G</span> Đăng nhập với Google
            </button>

            <div class="login-footer">
                Chưa có tài khoản?
                <a href="${pageContext.request.contextPath}/register" class="link-green">Đăng ký ngay</a>
            </div>
        </div>
    </div>

</body>
</html>