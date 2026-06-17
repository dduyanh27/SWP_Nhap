<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<h1 class="admin-page-title">Discount Code Management</h1>
<p class="admin-page-subtitle">Create and manage promotional discount codes</p>

<c:if test="${not empty success}">
    <div class="admin-alert success">${success}</div>
</c:if>
<c:if test="${not empty error}">
    <div class="admin-alert error">${error}</div>
</c:if>

<div class="stat-cards-grid stat-cards-grid-3">
    <div class="stat-card">
        <div class="stat-card-icon green">
            <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M20 6H4v12h16V6z"/><path d="M12 10v4"/><path d="M10 12h4"/></svg>
        </div>
        <div>
            <div class="stat-card-label">Active Codes</div>
            <div class="stat-card-value stat-value-success">${activeCount}</div>
        </div>
    </div>
    <div class="stat-card">
        <div class="stat-card-icon orange">
            <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><path d="M12 6v6l4 2"/></svg>
        </div>
        <div>
            <div class="stat-card-label">Expired</div>
            <div class="stat-card-value">${expiredCount}</div>
        </div>
    </div>
    <div class="stat-card">
        <div class="stat-card-icon blue">
            <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="2" y="2" width="20" height="20" rx="4"/><path d="M16 8l-8 8"/><path d="M8 8h8v8"/></svg>
        </div>
        <div>
            <div class="stat-card-label">Total Codes</div>
            <div class="stat-card-value">${totalCount}</div>
        </div>
    </div>
</div>

<div class="admin-toolbar">
    <div class="toolbar-left">
        <a href="${pageContext.request.contextPath}/admin/discounts?sort=expiry"
           class="btn-sort ${empty currentSort or currentSort == 'expiry' ? 'active' : ''}">
            Expiry Date DESC
        </a>
        <a href="${pageContext.request.contextPath}/admin/discounts?sort=usage"
           class="btn-sort ${currentSort == 'usage' ? 'active' : ''}">
            Usage Count ASC
        </a>
    </div>
    <a href="${pageContext.request.contextPath}/admin/discounts/create" class="btn-add-product">
        + New Code
    </a>
</div>

<div class="admin-table-wrapper">
    <table class="admin-table">
        <thead>
            <tr>
                <th>Code</th>
                <th>Type</th>
                <th>Value</th>
                <th>Usage Count</th>
                <th>Expiry Date</th>
                <th>Status</th>
                <th style="text-align:right;">Action</th>
            </tr>
        </thead>
        <tbody>
            <c:choose>
                <c:when test="${not empty discounts}">
                    <c:forEach var="d" items="${discounts}">
                        <tr>
                            <td><strong>${d.code}</strong></td>
                            <td>${d.discountType == 'PERCENTAGE' ? 'Percent' : 'Fixed'}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${d.discountType == 'PERCENTAGE'}">
                                        <fmt:formatNumber value="${d.discountValue}" pattern="#,##0"/>%
                                    </c:when>
                                    <c:otherwise>
                                        <fmt:formatNumber value="${d.discountValue}" pattern="#,###"/>đ
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                ${d.usedCount}
                                <c:if test="${not empty d.usageLimit}">
                                    / ${d.usageLimit}
                                </c:if>
                            </td>
                            <td>${d.endDateFormatted}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${d.status == 'ACTIVE'}">
                                        <span class="status-badge normal">Active</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="status-badge hidden">Disabled</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td style="text-align:right;">
                                <div class="action-links" style="justify-content:flex-end;">
                                    <a href="${pageContext.request.contextPath}/admin/discounts/edit?id=${d.discountId}"
                                       class="action-link edit">Edit</a>
                                    <span class="action-sep">|</span>
                                    <a href="${pageContext.request.contextPath}/admin/discounts/toggle?id=${d.discountId}"
                                       class="action-link ${d.status == 'ACTIVE' ? 'hide' : 'unhide'}"
                                       onclick="return confirm('${d.status == 'ACTIVE' ? 'Disable' : 'Enable'} this discount code?')">
                                        ${d.status == 'ACTIVE' ? 'Disable' : 'Enable'}
                                    </a>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <tr>
                        <td colspan="7" class="table-empty">No discount codes found. Click "+ New Code" to create one.</td>
                    </tr>
                </c:otherwise>
            </c:choose>
        </tbody>
    </table>
</div>
