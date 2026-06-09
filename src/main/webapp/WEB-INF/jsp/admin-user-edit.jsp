<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>

<html lang="vi">

<head>

    <meta charset="UTF-8">

    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Edit User — VMFruit Admin</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">

</head>

<body class="admin-body">



<div class="admin-wrapper">

    <jsp:include page="/WEB-INF/jsp/common/admin-sidebar.jsp">

        <jsp:param name="activeMenu" value="user-manage"/>

    </jsp:include>



    <main class="admin-main">

        <h1 class="admin-page-title">Edit User</h1>

        <p class="admin-page-subtitle">${user.userIdDisplay} — ${user.roleDisplay}</p>



        <c:if test="${not empty error}">

            <div class="admin-alert error">${error}</div>

        </c:if>



        <div class="admin-form-card">

            <form action="${pageContext.request.contextPath}/admin/users/edit" method="POST">

                <input type="hidden" name="userId" value="${user.userId}">

                <div class="admin-form-group">

                    <label>Họ và tên *</label>

                    <input type="text" name="fullName" class="admin-input"

                           value="${user.fullName}" required>

                </div>

                <div class="admin-form-group">

                    <label>Email *</label>

                    <input type="email" name="email" class="admin-input"

                           value="${user.email}" required>

                </div>

                <div class="admin-form-group">

                    <label>Số điện thoại *</label>

                    <input type="text" name="phoneNumber" class="admin-input"

                           value="${user.phone}" required>

                </div>

                <div class="admin-form-group">

                    <label>Vai trò *</label>

                    <select name="role" class="admin-select" required>

                        <option value="ADMIN" ${user.role == 'ADMIN' ? 'selected' : ''}>Admin</option>

                        <option value="SALES_STAFF" ${user.role == 'SALES_STAFF' ? 'selected' : ''}>Staff</option>

                        <option value="CUSTOMER" ${user.role == 'CUSTOMER' or empty user.role ? 'selected' : ''}>Customer</option>

                    </select>

                </div>

                <div class="admin-form-actions">

                    <a href="${pageContext.request.contextPath}/admin/users" class="btn-admin-secondary">Hủy</a>

                    <button type="submit" class="btn-add-product">Lưu thay đổi</button>

                </div>

            </form>

        </div>

    </main>

</div>



</body>

</html>

