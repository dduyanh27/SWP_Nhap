<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<h1 class="admin-page-title">Batch Management</h1>

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
    <div class="toolbar-left">
        <select id="statusSelect" name="status" class="admin-select" onchange="applyBatchFilters()">
            <option value=""          ${param.status == '' ? 'selected' : ''}>PO Status (All)</option>
            <option value="ACTIVE"    ${param.status == 'ACTIVE' ? 'selected' : ''}>Active</option>
            <option value="COMPLETED" ${param.status == 'COMPLETED' ? 'selected' : ''}>Completed</option>
        </select>

        <select id="supplierFilter" name="supplier" class="admin-select" onchange="applyBatchFilters()">
            <option value="">Filter by Supplier</option>
            </select>
    </div>

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
                <tr style="cursor: pointer; background-color: #FFFFFF; font-weight: 600;"
                    onclick="toggleChildRows(${parent.batchId})">
                    <td style="text-align: center; color: #64748B; font-size: 0.75rem;" id="icon-${parent.batchId}">▶</td>
                    <td style="color: #0F172A;">B${String.format("%04d", parent.batchId)}</td>
                    <td colspan="4" style="color: #64748B; font-weight: 400; font-style: italic;">
                        [PO#${parent.importReceiptId}] Nhà cung cấp: ${parent.supplierName}
                        - Nhận: <fmt:parseDate value="${parent.receivedDate}" pattern="yyyy-MM-dd'T'HH:mm" var="parsedDate" type="both" />
                                <fmt:formatDate value="${parsedDate}" pattern="dd/MM/yyyy" />
                    </td>
                    <td style="text-align:right;">
                        <a href="#" class="action-link edit" style="font-size: 0.8rem;">View Invoice</a>
                    </td>
                </tr>

                <c:forEach var="child" items="${parent.batchItems}">
                    <tr class="child-of-${parent.batchId}" style="display: none; background-color: #F8FAFC;">
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
                                        Expired (${Math.abs(child.daysLeft)} ngày trước)
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
                                <a href="#" class="action-link hide">Liquidate</a>
                            </div>
                        </td>
                    </tr>
                </c:forEach>
            </c:forEach>
        </tbody>
    </table>
</div>

<script>
function toggleChildRows(batchId) {
    const rows = document.querySelectorAll('.child-of-' + batchId);
    const icon = document.getElementById('icon-' + batchId);

    rows.forEach(row => {
        if (row.style.display === 'none') {
            row.style.display = 'table-row';
            icon.innerText = '▼';
            icon.style.color = '#3B82F6';
        } else {
            row.style.display = 'none';
            icon.innerText = '▶';
            icon.style.color = '#64748B';
        }
    });
}

function applyBatchFilters() {
    const status = document.getElementById('statusSelect').value;
    const base = window.location.pathname;
    window.location.href = base + '?status=' + encodeURIComponent(status);
}
</script>