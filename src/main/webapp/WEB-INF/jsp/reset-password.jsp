<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>VMFruit - Đặt lại mật khẩu</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/auth.css">
</head>
<body>

    <jsp:include page="common/auth-left.jsp">
        <jsp:param name="subtitle" value="Tạo mật khẩu mới cho tài khoản VMFruit của bạn." />
    </jsp:include>

    <div class="right-panel">
        <div class="login-container">
            <div class="login-header">
                <h2>Đặt lại mật khẩu</h2>
                <p>Vui lòng nhập mật khẩu mới cho tài khoản của bạn.</p>
            </div>

            <c:if test="${not empty error}">
                <div class="error-msg">${error}</div>
            </c:if>

            <form action="${pageContext.request.contextPath}/reset-password" method="POST">
                <input type="hidden" name="token" value="${token}">
                <p style="color: #28a745; font-size: 14px; text-align: center;">✓ Email đã được xác nhận. Vui lòng đặt mật khẩu mới.</p>

                <div class="form-group">
                    <label>Mật khẩu mới <span class="required">*</span></label>
                    <div class="input-wrapper">
                        <input type="password" class="form-control" name="password"
                               placeholder="Tối thiểu 8 ký tự, gồm chữ và số" required>
                    </div>
                </div>

                <div class="form-group">
                    <label>Xác nhận mật khẩu <span class="required">*</span></label>
                    <div class="input-wrapper">
                        <input type="password" class="form-control" name="confirmPassword"
                               placeholder="••••••••" required>
                    </div>
                </div>

                <button type="submit" class="btn-submit">Đặt lại mật khẩu</button>
            </form>

            <div class="login-footer">
                <a href="${pageContext.request.contextPath}/login" class="link-green">Quay lại đăng nhập</a>
            </div>
        </div>
    </div>

</body>
</html>
