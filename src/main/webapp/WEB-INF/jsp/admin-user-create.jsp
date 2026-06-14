<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add User — VMFruit Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">
</head>
<body class="admin-body">
<div class="admin-wrapper">

    <jsp:include page="/WEB-INF/jsp/common/admin-sidebar.jsp">
        <jsp:param name="activeMenu" value="user-manage"/>
    </jsp:include>

    <main class="admin-main">
        <h1 class="admin-page-title">Add User</h1>
        <p class="admin-page-subtitle">Tạo tài khoản mới với thông tin giống form đăng ký.</p>

        <c:if test="${not empty error}">
            <div class="admin-alert error">${error}</div>
        </c:if>

        <div class="admin-form-card">
            <form action="${pageContext.request.contextPath}/admin/users/create" method="POST">
                <div class="admin-form-group">
                    <label>Họ và tên *</label>
                    <input type="text" name="fullName" class="admin-input"
                           value="${form.fullName}" required>
                </div>

                <div class="admin-form-group">
                    <label>Email *</label>
                    <input type="email" name="email" class="admin-input"
                           value="${form.email}" required>
                </div>

                <div class="admin-form-group">
                    <label>Số điện thoại *</label>
                    <input type="text" name="phoneNumber" class="admin-input"
                           value="${form.phoneNumber}" required>
                </div>

                <div class="admin-form-group">
                    <label>Mật khẩu *</label>
                    <input type="password" name="password" class="admin-input"
                           placeholder="Tối thiểu 8 ký tự, gồm chữ và số" required>
                </div>

                <div class="admin-form-group">
                    <label>Xác nhận mật khẩu *</label>
                    <input type="password" name="confirmPassword" class="admin-input"
                           placeholder="Nhập lại mật khẩu" required>
                </div>

                <div class="admin-form-group">
                    <label>Vai trò *</label>
                    <select name="role" class="admin-select" required>
                        <option value="ADMIN" ${form.role == 'ADMIN' ? 'selected' : ''}>Admin</option>
                        <option value="SALES_STAFF" ${form.role == 'SALES_STAFF' ? 'selected' : ''}>Staff</option>
                        <option value="CUSTOMER" ${form.role == 'CUSTOMER' or empty form.role ? 'selected' : ''}>Customer</option>
                    </select>
                </div>

                <div class="admin-form-group">
                    <label>Trạng thái *</label>
                    <select name="status" class="admin-select" required>
                        <option value="ACTIVE" ${form.status == 'ACTIVE' or empty form.status ? 'selected' : ''}>Active</option>
                        <option value="INACTIVE" ${form.status == 'INACTIVE' ? 'selected' : ''}>Inactive</option>
                    </select>
                </div>

                <div class="admin-form-actions">
                    <a href="${pageContext.request.contextPath}/admin/users" class="btn-admin-secondary">Hủy</a>
                    <button type="submit" class="btn-add-product">Tạo người dùng</button>
                </div>
            </form>
        </div>
    </main>
</div>
</body>
</html>
