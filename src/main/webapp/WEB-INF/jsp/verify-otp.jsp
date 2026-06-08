<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>VMFruit - Xác nhận mã OTP</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/auth.css">
</head>
<body>

    <jsp:include page="common/auth-left.jsp">
        <jsp:param name="subtitle" value="Nhập mã xác nhận được gửi đến email của bạn." />
    </jsp:include>

    <div class="right-panel">
        <div class="login-container">
            <div class="login-header">
                <h2>Xác nhận mã OTP</h2>
                <p>Vui lòng nhập mã xác nhận 6 chữ số đã được gửi đến email của bạn.</p>
            </div>

            <c:if test="${not empty error}">
                <div class="error-msg">${error}</div>
            </c:if>

            <form action="${pageContext.request.contextPath}/verify-otp" method="POST">
                <input type="hidden" name="token" value="${token}">

                <div class="form-group">
                    <label>Mã xác nhận <span class="required">*</span></label>
                    <input type="text" class="form-control" name="otp"
                           placeholder="Nhập mã 6 chữ số" maxlength="6" required>
                </div>

                <button type="submit" class="btn-submit">Xác nhận</button>
            </form>

            <div class="login-footer">
                <a href="${pageContext.request.contextPath}/login" class="link-green">Quay lại đăng nhập</a>
            </div>
        </div>
    </div>

</body>
</html>
