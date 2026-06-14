<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<h1 class="admin-page-title">User Management</h1>

<c:if test="${not empty success}">
    <div class="admin-alert success">${success}</div>
</c:if>
<c:if test="${not empty error}">
    <div class="admin-alert error">${error}</div>
</c:if>

<div class="stat-cards-grid stat-cards-grid-3">
    <div class="stat-card">
        <div class="stat-card-label">New Users</div>
        <div class="stat-card-value">${newUserCount}</div>
    </div>
    <div class="stat-card">
        <div class="stat-card-label">Total Customers:</div>
        <div class="stat-card-value">${totalCustomers}</div>
    </div>
    <div class="stat-card">
        <div class="stat-card-label">Total Staffs:</div>
        <div class="stat-card-value">${totalStaffs}</div>
    </div>
</div>

<div class="admin-toolbar">
    <div class="toolbar-left">
        <select id="roleFilter" name="role" class="admin-select" onchange="applyUserFilters()">
            <option value=""           ${empty param.role           ? 'selected' : ''}>All Roles</option>
            <option value="ADMIN"      ${param.role == 'ADMIN'      ? 'selected' : ''}>Admin</option>
            <option value="SALES_STAFF" ${param.role == 'SALES_STAFF' ? 'selected' : ''}>Staff</option>
            <option value="CUSTOMER"   ${param.role == 'CUSTOMER'   ? 'selected' : ''}>Customer</option>
        </select>

        <select id="statusFilter" name="status" class="admin-select" onchange="applyUserFilters()">
            <option value=""        ${empty param.status        ? 'selected' : ''}>All Statuses</option>
            <option value="ACTIVE"   ${param.status == 'ACTIVE'   ? 'selected' : ''}>Active</option>
            <option value="INACTIVE" ${param.status == 'INACTIVE' ? 'selected' : ''}>Inactive</option>
        </select>
    </div>

    <a href="${pageContext.request.contextPath}/admin/users/create" class="btn-add-product">
        + Add User
    </a>
</div>

<div class="admin-table-wrapper">
    <table class="admin-table">
        <thead>
            <tr>
                <th>User ID</th>
                <th>Full Name</th>
                <th>Role</th>
                <th>Status</th>
                <th style="text-align:right;">Action</th>
            </tr>
        </thead>
        <tbody>
            <c:choose>
                <c:when test="${not empty userList}">
                    <c:forEach var="u" items="${userList}">
                        <tr>
                            <td>${u.userIdDisplay}</td>
                            <td>${u.fullName}</td>
                            <td>${u.roleDisplay}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${u.status == 'ACTIVE'}">
                                        <span class="status-text active">Active</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="status-text inactive">Inactive</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td style="text-align:right;">
                                <div class="action-links" style="justify-content:flex-end;">
                                    <a href="${pageContext.request.contextPath}/admin/users/edit?id=${u.userId}"
                                       class="action-link edit">Edit</a>
                                    <span class="action-sep">|</span>
                                    <c:choose>
                                        <c:when test="${u.status == 'ACTIVE'}">
                                            <a href="${pageContext.request.contextPath}/admin/users/lock?id=${u.userId}"
                                               class="action-link lock"
                                               onclick="return confirm('Lock this user?')">Lock</a>
                                        </c:when>
                                        <c:otherwise>
                                            <a href="${pageContext.request.contextPath}/admin/users/unlock?id=${u.userId}"
                                               class="action-link unlock"
                                               onclick="return confirm('Unlock this user?')">Unlock</a>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <tr>
                        <td colspan="5" class="table-empty">Chưa có người dùng trong hệ thống.</td>
                    </tr>
                </c:otherwise>
            </c:choose>
        </tbody>
    </table>
</div>

<script>
    function applyUserFilters() {
        const role = document.getElementById('roleFilter').value;
        const status = document.getElementById('statusFilter').value;
        const base = window.location.pathname;
        window.location.href = base
            + '?role=' + encodeURIComponent(role)
            + '&status=' + encodeURIComponent(status);
    }
</script>
