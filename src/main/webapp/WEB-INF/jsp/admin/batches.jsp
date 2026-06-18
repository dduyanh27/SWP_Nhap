<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<h1 class="admin-page-title">Batch Management</h1>

<c:if test="${not empty message}">
    <div class="bm-alert bm-alert--success">${message}</div>
</c:if>
<c:if test="${not empty error}">
    <div class="bm-alert bm-alert--error">${error}</div>
</c:if>

<div class="stat-cards-grid">
    <div class="stat-card">
        <div class="stat-card-label">Active Batches</div>
        <div class="stat-card-value">${activeBatchesCount != null ? activeBatchesCount : '0'}</div>
    </div>
    <div class="stat-card">
        <div class="stat-card-label">Expiring Batches</div>
        <div class="stat-card-value" style="color: #EF4444;">${expiringBatchesCount != null ? expiringBatchesCount : '0'}</div>
    </div>
    <div class="stat-card">
        <div class="stat-card-label">Liquidated Lots</div>
        <div class="stat-card-value">${liquidatedLotsCount != null ? liquidatedLotsCount : '0'}</div>
    </div>
</div>

<div class="admin-toolbar">
    <form method="get" action="${pageContext.request.contextPath}/admin/batches" class="bm-filter-form">
        <div class="toolbar-left">
            <select id="statusSelect" name="status" class="admin-select">
                <option value="" ${param.status == '' ? 'selected' : ''}>PO Status (All)</option>
                <option value="ACTIVE" ${param.status == 'ACTIVE' ? 'selected' : ''}>Active</option>
                <option value="COMPLETED" ${param.status == 'COMPLETED' ? 'selected' : ''}>Completed</option>
            </select>

            <select id="supplierFilter" name="supplier" class="admin-select">
                <option value="">Filter by Supplier</option>
            </select>

            <button type="submit" class="bm-filter-btn">Filter</button>
        </div>
    </form>

    <a href="${pageContext.request.contextPath}/admin/batches/new" class="btn-add-product">
        + Receive New Batch
    </a>
</div>

<div class="admin-table-wrapper">
    <table class="admin-table">
        <thead>
            <tr>
                <th style="width: 4%;"></th>
                <th style="width: 14%;">Mã Lô / PO ID</th>
                <th style="width: 32%;">Thông tin Sản phẩm / Đợt nhập</th>
                <th style="width: 15%;">Giá nhập (Unit Cost)</th>
                <th style="width: 15%;">Tồn kho thực tế</th>
                <th style="width: 15%;">Hạn sử dụng (TTL)</th>
                <th style="text-align:right; width: 10%;">Hành động</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="parent" items="${batchGroups}">
                <c:set var="batchCanCancel" value="true"/>
                <c:forEach var="item" items="${parent.batchItems}">
                    <c:if test="${item.remainingQuantity < item.acceptedQuantity}">
                        <c:set var="batchCanCancel" value="false"/>
                    </c:if>
                </c:forEach>

                <tr class="bm-parent-row">
                    <td style="text-align: center; color: #64748B; font-size: 0.75rem;">B</td>
                    <td style="color: #0F172A;">B${String.format("%04d", parent.batchId)}</td>
                    <td colspan="4" style="color: #64748B; font-weight: 400; font-style: italic;">
                        [${parent.poCode}] Nhà cung cấp: ${parent.supplierName}
                        - Nhận:
                        <fmt:parseDate value="${parent.receivedDate}" pattern="yyyy-MM-dd'T'HH:mm" var="parsedDate" type="both"/>
                        <fmt:formatDate value="${parsedDate}" pattern="dd/MM/yyyy"/>
                    </td>
                    <td style="text-align:right;">
                        <div class="action-links" style="justify-content:flex-end; flex-wrap:wrap; gap:6px;">
                            <a href="#" class="action-link edit" style="font-size: 0.8rem;">View Invoice</a>
                            <c:if test="${batchCanCancel}">
                                <span class="action-sep">|</span>
                                <form method="post"
                                      action="${pageContext.request.contextPath}/admin/batches/${parent.batchId}/cancel"
                                      style="display:inline;">
                                    <button type="submit" class="action-link action-link--cancel-batch">
                                        Cancel Batch
                                    </button>
                                </form>
                            </c:if>
                        </div>
                    </td>
                </tr>

                <c:forEach var="child" items="${parent.batchItems}">
                    <tr class="bm-child-row">
                        <td></td>
                        <td style="color: #94A3B8; font-size: 0.8rem; padding-left: 15px;">
                            └── IT${String.format("%04d", child.batchItemId)}
                        </td>
                        <td style="font-weight: 600; color: #334155; max-width: 250px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;" title="${child.productName}">
                            ${child.productName}
                        </td>
                        <td style="color: #475569;">
                            <fmt:formatNumber value="${child.importPrice}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
                        </td>
                        <td style="font-weight: 600; color: #0F172A;">
                            ${child.remainingQuantity} / ${child.acceptedQuantity} ${child.unit}
                        </td>
                        <td>
                            <c:choose>
                                <c:when test="${child.daysLeft < 0}">
                                    <span class="status-badge hidden" style="background-color: #F1F5F9; color: #64748B;">
                                        Expired
                                    </span>
                                </c:when>
                                <c:when test="${child.daysLeft <= 3}">
                                    <span class="status-badge low-stock">
                                        ${child.daysLeft} days left
                                    </span>
                                </c:when>
                                <c:otherwise>
                                    <span class="status-badge normal">Normal</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td style="text-align:right;">
                            <div class="action-links" style="justify-content:flex-end; font-size: 0.8rem;">
                                <a href="#" class="action-link edit">Auto Disc</a>
                                <span class="action-sep">|</span>
                                <form method="post"
                                      action="${pageContext.request.contextPath}/admin/batches/${parent.batchId}/items/${child.batchItemId}/remove"
                                      style="display:inline;">
                                    <button type="submit" class="action-link action-link--remove">
                                        Remove Item
                                    </button>
                                </form>
                            </div>
                        </td>
                    </tr>
                </c:forEach>
            </c:forEach>
        </tbody>
    </table>
</div>

<style>
.bm-alert {
    margin: 0 0 16px;
    padding: 12px 16px;
    border-radius: 8px;
    font-size: 0.875rem;
    font-weight: 500;
}
.bm-alert--success {
    background: #f0fdf4;
    color: #166534;
    border: 1px solid #bbf7d0;
}
.bm-alert--error {
    background: #fef2f2;
    color: #b91c1c;
    border: 1px solid #fecaca;
}
.bm-filter-form {
    display: contents;
}
.bm-filter-btn {
    padding: 10px 18px;
    border: none;
    border-radius: 8px;
    background: #3B82F6;
    color: #ffffff;
    font-size: 0.85rem;
    font-weight: 700;
    cursor: pointer;
}
.bm-parent-row {
    background-color: #FFFFFF;
    font-weight: 600;
}
.bm-child-row {
    background-color: #F8FAFC;
}
.action-link--remove {
    background: none;
    border: none;
    color: #F59E0B;
    cursor: pointer;
    padding: 0;
    font-size: 0.8rem;
    font-family: inherit;
    font-weight: 600;
    text-decoration: none;
}
.action-link--remove:hover {
    color: #D97706;
    text-decoration: underline;
}
.action-link--cancel-batch {
    background: none;
    border: none;
    color: #EF4444;
    cursor: pointer;
    padding: 0;
    font-size: 0.8rem;
    font-family: inherit;
    font-weight: 600;
    text-decoration: none;
}
.action-link--cancel-batch:hover {
    color: #DC2626;
    text-decoration: underline;
}
</style>
