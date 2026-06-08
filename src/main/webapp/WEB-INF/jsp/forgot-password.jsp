<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>VMFruit - Quên mật khẩu</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/auth.css">
</head>
<body>

    <jsp:include page="common/auth-left.jsp">
        <jsp:param name="subtitle" value="Đặt lại mật khẩu để tiếp tục mua sắm tại VMFruit." />
    </jsp:include>

    <div class="right-panel">
        <div class="login-container">
            <div class="login-header">
                <h2>Quên mật khẩu</h2>
                <p>Nhập email đã đăng ký, chúng tôi sẽ gửi mã xác nhận để đặt lại mật khẩu.</p>
            </div>

            <c:if test="${not empty error}">
                <div class="error-msg">${error}</div>
            </c:if>

            <c:if test="${not empty success}">
                <div class="success-msg">${success}</div>
            </c:if>

            <form action="${pageContext.request.contextPath}/forgot-password" method="POST">
                <div class="form-group">
                    <label>Email <span class="required">*</span></label>
                    <input type="email" class="form-control" name="email"
                           placeholder="example@email.com" required>
                </div>

                <button type="submit" class="btn-submit">Gửi yêu cầu</button>
            </form>

            <div class="login-footer">
                <a href="${pageContext.request.contextPath}/login" class="link-green">Quay lại đăng nhập</a>
            </div>
        </div>
    </div>

</body>
</html>
