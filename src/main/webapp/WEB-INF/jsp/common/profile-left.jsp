<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<div class="profile-card p-3">
    <div class="d-flex align-items-center mb-3 border-bottom pb-3">
        <div class="rounded-circle bg-light d-flex justify-content-center align-items-center me-3" style="width: 50px; height: 50px;">
            <img src="<c:url value='/images/default-avatar.png'/>" class="rounded-circle" style="width: 100%; height: 100%; object-fit: cover;" alt="Avatar">
        </div>
        <div>
            <h6 class="mb-0 fw-bold">
              <span>${sessionScope.currentUser.fullName}</span>
            </h6>
            <a href="<c:url value='/profile'/>" class="text-success small text-decoration-none">Sửa hồ sơ</a>
        </div>
    </div>

    <div class="list-group list-group-flush border-0">
        <a href="<c:url value='/profile'/>" class="list-group-item list-group-item-action border-0 ${empty param.tab ? 'active-tab' : ''}">
            <i class="far fa-user me-2"></i> Hồ sơ cá nhân
        </a>
        <a href="<c:url value='/profile?tab=orders'/>" class="list-group-item list-group-item-action border-0 ${param.tab == 'orders' ? 'active-tab' : ''}">
            <i class="fas fa-box me-2"></i> Lịch sử đơn hàng
        </a>
        <a href="<c:url value='/profile?tab=address'/>" class="list-group-item list-group-item-action border-0 ${param.tab == 'address' ? 'active-tab' : ''}">
            <i class="fas fa-map-marker-alt me-2"></i> Sổ địa chỉ
        </a>
        <a href="<c:url value='/profile?tab=password'/>" class="list-group-item list-group-item-action border-0 ${param.tab == 'password' ? 'active-tab' : ''}">
            <i class="fas fa-lock me-2"></i> Đổi mật khẩu
        </a>
        <a href="<c:url value='/profile?tab=notification'/>" class="list-group-item list-group-item-action border-0 ${param.tab == 'notification' ? 'active-tab' : ''}">
            <i class="far fa-bell me-2"></i> Thông báo
        </a>
    </div>
</div>