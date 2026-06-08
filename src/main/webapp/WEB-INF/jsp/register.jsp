<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>VMFruit - Đăng ký</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/auth.css">
</head>
<body>

    <jsp:include page="common/auth-left.jsp">
        <jsp:param name="subtitle" value="Tạo tài khoản ngay và cùng mua sắm với chúng tôi!" />
    </jsp:include>

    <div class="right-panel">
        <div class="login-container">
            <div class="login-header">
                <h2>Đăng ký tài khoản</h2>
                <p>Điền đầy đủ các thông tin dưới đây để tạo tài khoản mới.</p>
            </div>

            <c:if test="${not empty error}">
                <div class="error-msg">${error}</div>
            </c:if>

            <form action="${pageContext.request.contextPath}/register" method="POST">
                <div class="form-group">
                    <label>Họ và tên <span class="required">*</span></label>
                    <input type="text" class="form-control" name="fullName"
                           value="${form.fullName}"
                           placeholder="Nguyễn Viết Minh..." required>
                </div>

                <div class="form-group row-flex">
                    <div class="flex-item">
                        <label>Email <span class="required">*</span></label>
                        <input type="email" class="form-control" name="email"
                               value="${form.email}"
                               placeholder="example@email.com" required>
                    </div>
                    <div class="flex-item">
                        <label>Số điện thoại <span class="required">*</span></label>
                        <input type="text" class="form-control" name="phoneNumber"
                               value="${form.phoneNumber}"
                               placeholder="09xx..." required>
                    </div>
                </div>

                <div class="form-group">
                    <label>Mật khẩu <span class="required">*</span></label>
                    <div class="input-wrapper">
                        <input type="password" class="form-control" name="password"
                               placeholder="Tối thiểu 8 ký tự, gồm chữ và số" required>
                        <span class="password-toggle" role="button" tabindex="0" aria-label="Hiện/ẩn mật khẩu">
                            <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" fill="none"
                                 viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                                <path stroke-linecap="round" stroke-linejoin="round"
                                      d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
                                <path stroke-linecap="round" stroke-linejoin="round"
                                      d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z" />
                            </svg>
                        </span>
                    </div>
                </div>

                <div class="form-group">
                    <label>Xác nhận mật khẩu <span class="required">*</span></label>
                    <div class="input-wrapper">
                        <input type="password" class="form-control" name="confirmPassword"
                               placeholder="••••••••" required>
                        <span class="password-toggle" role="button" tabindex="0" aria-label="Hiện/ẩn mật khẩu">
                            <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" fill="none"
                                 viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                                <path stroke-linecap="round" stroke-linejoin="round"
                                      d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
                                <path stroke-linecap="round" stroke-linejoin="round"
                                      d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z" />
                            </svg>
                        </span>
                    </div>
                </div>

                <div class="form-options" style="margin-bottom: 24px;">
                    <label class="checkbox-label">
                        <input type="checkbox" name="agreeTerms" value="true"
                               <c:if test="${not empty form and form.agreeTerms}">checked</c:if> required>
                        Tôi đồng ý với những <a href="#" class="link-green">Điều khoản &amp; Chính sách</a>
                    </label>
                </div>

                <button type="submit" class="btn-submit">Đăng ký tài khoản</button>
            </form>

            <div class="login-footer">
                Đã có tài khoản?
                <a href="${pageContext.request.contextPath}/login" class="link-green">Đăng nhập ngay</a>
            </div>
        </div>
    </div>

    <%-- Click vào ô -> placeholder mất ngay; blur mà trống -> hiện lại --%>
    <script>
        document.querySelectorAll('.login-container .form-control[placeholder]').forEach(function (input) {
            input.addEventListener('focus', function () {
                input.dataset.ph = input.placeholder;
                input.placeholder = '';
            });
            input.addEventListener('blur', function () {
                if (!input.value.trim()) {
                    input.placeholder = input.dataset.ph || '';
                }
            });
        });
    </script>

</body>
</html>