<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<div class="header">
    <img src="${pageContext.request.contextPath}/asset/logo/logoNobackround.jpg"
         alt="VMFruit"
         style="height: 45px;">

    <div class="user-info">
        <span class="staff-badge">Staff: ${user.fullName}</span>
        <a href="${pageContext.request.contextPath}/logout" class="logout-btn">Logout</a>
    </div>
</div>

<div class="nav">
    <a href="${pageContext.request.contextPath}/sales/dashboard"
       class="${activePage == 'dashboard' ? 'active' : ''}">
        <span class="dot"></span>DASHBOARD
    </a>

    <a href="${pageContext.request.contextPath}/sales/checkout"
       class="${activePage == 'checkout' ? 'active' : ''}">
        <span class="dot"></span>CHECKOUT
    </a>

    <a href="${pageContext.request.contextPath}/sales/orders"
       class="${activePage == 'orders' ? 'active' : ''}">
        <span class="dot"></span>DANH SÁCH ĐẶT ONLINE
    </a>

    <a href="${pageContext.request.contextPath}/sales/imports"
           class="${activePage == 'imports' ? 'active' : ''}">
            <span class="dot"></span>DANH SÁCH NHẬP HÀNG
        </a>
</div>