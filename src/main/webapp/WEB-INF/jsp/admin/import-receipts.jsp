<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<h1 class="admin-page-title">Import Receipt</h1>

<div class="stat-cards-grid">
    <div class="stat-card">
        <div class="stat-card-label">Total</div>
        <div class="stat-card-value">${totalCount}</div>
    </div>
    <div class="stat-card">
        <div class="stat-card-label">Pending Receipt</div>
        <div class="stat-card-value stat-value-warning">${pendingCount}</div>
    </div>
    <div class="stat-card">
        <div class="stat-card-label">Fully Received</div>
        <div class="stat-card-value stat-value-success">${receivedCount}</div>
    </div>
    <div class="stat-card">
        <div class="stat-card-label">Total Quantity</div>
        <div class="stat-card-value stat-value-info">${totalQuantity}</div>
    </div>
</div>

<div class="admin-toolbar">
    <div class="toolbar-left">
        <select id="supplierFilter" name="supplier" class="admin-select" onchange="applyImportFilters()">
            <option value="" ${empty selectedSupplier ? 'selected' : ''}>Filter by Supplier</option>
            <c:forEach var="s" items="${suppliers}">
                <option value="${s.supplierId}" ${selectedSupplier == s.supplierId ? 'selected' : ''}>
                    ${s.supplierName}
                </option>
            </c:forEach>
        </select>

        <select id="dateFilter" name="sortDate" class="admin-select" onchange="applyImportFilters()">
            <option value="recent" ${sortDate == 'recent' || empty sortDate ? 'selected' : ''}>Order Date: Recent</option>
            <option value="oldest" ${sortDate == 'oldest' ? 'selected' : ''}>Order Date: Oldest</option>
        </select>
    </div>

    <a href="#" class="btn-add-product">
        + Create Import Receipt
    </a>
</div>

<div class="admin-table-wrapper">
    <table class="admin-table">
        <thead>
            <tr>
                <th>Import ID</th>
                <th>Supplier Name</th>
                <th>Created Date</th>
                <th>Total Expected Quantity</th>
                <th>Status</th>
                <th style="text-align:right;">Action</th>
            </tr>
        </thead>
        <tbody>
            <c:choose>
                <c:when test="${not empty receiptList}">
                    <c:forEach var="r" items="${receiptList}">
                        <tr>
                            <td class="import-id">${r.importIdDisplay}</td>
                            <td>${r.supplierName}</td>
                            <td>${r.createdDateDisplay}</td>
                            <td>
                                <fmt:formatNumber value="${r.totalExpectedQuantity}" groupingUsed="true" maxFractionDigits="0"/>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${r.statusKey == 'received'}">
                                        <span class="status-badge received">Received</span>
                                    </c:when>
                                    <c:when test="${r.statusKey == 'pending'}">
                                        <span class="status-badge pending">Pending</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="status-badge hidden">${r.dbStatus}</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td style="text-align:right;">
                                <c:choose>
                                    <c:when test="${r.statusKey == 'pending'}">
                                        <div class="action-links" style="justify-content:flex-end;">
                                            <a href="#" class="action-link edit">Edit</a>
                                            <span class="action-sep">|</span>
                                            <a href="#" class="action-link cancel">Cancel</a>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <a href="#" class="action-link edit">View</a>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <tr>
                        <td colspan="6" class="table-empty">Chưa có phiếu nhập kho trong hệ thống.</td>
                    </tr>
                </c:otherwise>
            </c:choose>
        </tbody>
    </table>
</div>

<script>
    function applyImportFilters() {
        const supplier = document.getElementById('supplierFilter').value;
        const sortDate = document.getElementById('dateFilter').value;
        const base = window.location.pathname;
        const params = new URLSearchParams();
        if (supplier) params.set('supplier', supplier);
        if (sortDate) params.set('sortDate', sortDate);
        const query = params.toString();
        window.location.href = query ? base + '?' + query : base;
    }
</script>
