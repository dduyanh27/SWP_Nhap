<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%--
  admin-sidebar.jsp — Common admin sidebar (dashboard navigation)
  Usage: <%@ include file="/WEB-INF/jsp/common/admin-sidebar.jsp" %>
  Pass activeMenu param, e.g. <jsp:param name="activeMenu" value="fruit-manage"/>
--%>

<!-- SIDEBAR -->
<aside class="admin-sidebar">
    <div class="sidebar-brand">
        <h2>VMFruit Admin</h2>
    </div>

    <nav class="sidebar-nav">
        <a href="${pageContext.request.contextPath}/admin/dashboard"
           class="sidebar-nav-item ${param.activeMenu == 'dashboard' ? 'active' : ''}">
            Dashboard
        </a>
        <a href="${pageContext.request.contextPath}/admin/users"
           class="sidebar-nav-item ${param.activeMenu == 'user-manage' ? 'active' : ''}">
            User Manage
        </a>
        <a href="${pageContext.request.contextPath}/admin/products"
           class="sidebar-nav-item ${param.activeMenu == 'fruit-manage' ? 'active' : ''}">
            Fruit Manage
        </a>
        <a href="${pageContext.request.contextPath}/admin/orders"
           class="sidebar-nav-item ${param.activeMenu == 'order-manage' ? 'active' : ''}">
            Order Manage
        </a>
        <a href="${pageContext.request.contextPath}/admin/reviews"
           class="sidebar-nav-item ${param.activeMenu == 'review-manage' ? 'active' : ''}">
            Review Manage
        </a>
        <a href="${pageContext.request.contextPath}/admin/discounts"
           class="sidebar-nav-item ${param.activeMenu == 'discount-code' ? 'active' : ''}">
            Discount Code
        </a>
        <a href="${pageContext.request.contextPath}/admin/payments"
           class="sidebar-nav-item ${param.activeMenu == 'payment-manage' ? 'active' : ''}">
            Payment Manage
        </a>
        <a href="${pageContext.request.contextPath}/admin/reports"
           class="sidebar-nav-item ${param.activeMenu == 'report-manage' ? 'active' : ''}">
            Report Manage
        </a>
    </nav>

    <div class="sidebar-footer">
        <a href="${pageContext.request.contextPath}/logout"
           class="sidebar-nav-item">
            Logout
        </a>
    </div>
</aside>
