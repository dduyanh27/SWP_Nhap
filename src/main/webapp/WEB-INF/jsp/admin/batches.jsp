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
                <%--
                    Kiểm tra lô cha có thể Cancel không:
                    - Lô chưa bán = tất cả items đều có remainingQty == acceptedQty
                    - Ta dùng biến boolCanCancel tính bên dưới qua JSTL
                --%>
                <c:set var="batchCanCancel" value="true"/>
                <c:forEach var="item" items="${parent.batchItems}">
                    <c:if test="${item.remainingQuantity < item.acceptedQuantity}">
                        <c:set var="batchCanCancel" value="false"/>
                    </c:if>
                </c:forEach>

                <tr style="cursor: pointer; background-color: #FFFFFF; font-weight: 600;"
                    onclick="toggleChildRows(${parent.batchId})">
                    <td style="text-align: center; color: #64748B; font-size: 0.75rem;" id="icon-${parent.batchId}">▶</td>
                    <td style="color: #0F172A;">B${String.format("%04d", parent.batchId)}</td>
                    <td colspan="4" style="color: #64748B; font-weight: 400; font-style: italic;">
                        [${parent.poCode}] Nhà cung cấp: ${parent.supplierName}
                        - Nhận: <fmt:parseDate value="${parent.receivedDate}" pattern="yyyy-MM-dd'T'HH:mm" var="parsedDate" type="both" />
                                <fmt:formatDate value="${parsedDate}" pattern="dd/MM/yyyy" />
                    </td>
                    <td style="text-align:right;" onclick="event.stopPropagation()">
                        <div class="action-links" style="justify-content:flex-end; flex-wrap:wrap; gap:6px;">
                            <a href="#" class="action-link edit" style="font-size: 0.8rem;">View Invoice</a>
                            <c:if test="${batchCanCancel}">
                                <span class="action-sep">|</span>
                                <button type="button"
                                        class="action-link action-link--cancel-batch"
                                        onclick="openCancelBatchModal(${parent.batchId}, '${parent.poCode}')">
                                    Cancel Batch
                                </button>
                            </c:if>
                        </div>
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
                                <button type="button"
                                        class="action-link action-link--remove"
                                        onclick="openRemoveItemModal(${child.batchItemId}, '${child.productName}', ${parent.batchId})">
                                    Remove Item
                                </button>
                            </div>
                        </td>
                    </tr>
                </c:forEach>
            </c:forEach>
        </tbody>
    </table>
</div>

<%-- ════════════════════════════════════════════════════════════
     MODAL: Remove Item (chuyển sang CANCELLED)
     ════════════════════════════════════════════════════════════ --%>
<div id="removeItemModal" class="bm-modal-overlay" style="display:none;" onclick="closeModalOnBackdrop(event,'removeItemModal')">
    <div class="bm-modal-box">
        <div class="bm-modal-icon bm-modal-icon--warning">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <polyline points="3 6 5 6 21 6"/>
                <path d="M19 6l-1 14a2 2 0 01-2 2H8a2 2 0 01-2-2L5 6"/>
                <path d="M10 11v6"/><path d="M14 11v6"/>
                <path d="M9 6V4a1 1 0 011-1h4a1 1 0 011 1v2"/>
            </svg>
        </div>
        <h3 class="bm-modal-title">Remove Item khỏi Lô hàng</h3>
        <p class="bm-modal-desc">
            Bạn muốn loại bỏ sản phẩm <strong id="removeItemName"></strong> khỏi lô hàng?<br/>
            <span class="bm-modal-note">
                ✔ Item sẽ được chuyển trạng thái sang <code>CANCELLED</code> để giữ nguyên lịch sử nhập kho.<br/>
                ✘ Dữ liệu không bị xóa vĩnh viễn.
            </span>
        </p>
        <div class="bm-modal-actions">
            <button type="button" class="bm-btn bm-btn--ghost" onclick="closeModalById('removeItemModal')">Hủy bỏ</button>
            <form id="removeItemForm" action="" method="POST" style="display:inline;">
                <input type="hidden" name="action" value="CANCEL_ITEM"/>
                <button type="submit" class="bm-btn bm-btn--warning">Xác nhận Remove Item</button>
            </form>
        </div>
    </div>
</div>

<%-- ════════════════════════════════════════════════════════════
     MODAL: Cancel Batch (chỉ hiện khi lô chưa bán)
     ════════════════════════════════════════════════════════════ --%>
<div id="cancelBatchModal" class="bm-modal-overlay" style="display:none;" onclick="closeModalOnBackdrop(event,'cancelBatchModal')">
    <div class="bm-modal-box">
        <div class="bm-modal-icon bm-modal-icon--danger">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <circle cx="12" cy="12" r="10"/>
                <line x1="15" y1="9" x2="9" y2="15"/>
                <line x1="9" y1="9" x2="15" y2="15"/>
            </svg>
        </div>
        <h3 class="bm-modal-title">Hủy toàn bộ Lô hàng?</h3>
        <p class="bm-modal-desc">
            Bạn đang hủy lô hàng <strong id="cancelBatchCode"></strong>.<br/>
            <span class="bm-modal-note">
                ⚠ Toàn bộ sản phẩm trong lô này sẽ bị hủy bỏ.<br/>
                ✔ Thao tác chỉ được phép khi lô <strong>chưa xuất bán</strong> bất kỳ sản phẩm nào.<br/>
                ✘ Hành động này không thể hoàn tác.
            </span>
        </p>
        <div class="bm-modal-actions">
            <button type="button" class="bm-btn bm-btn--ghost" onclick="closeModalById('cancelBatchModal')">Giữ lại Lô</button>
            <form id="cancelBatchForm" action="" method="POST" style="display:inline;">
                <input type="hidden" name="action" value="CANCEL_BATCH"/>
                <button type="submit" class="bm-btn bm-btn--danger">Hủy Lô hàng</button>
            </form>
        </div>
    </div>
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

/* ── Modal helpers ──────────────────────────────────────── */
function closeModalById(id) {
    document.getElementById(id).style.display = 'none';
    document.body.style.overflow = '';
}

function closeModalOnBackdrop(e, id) {
    if (e.target === document.getElementById(id)) closeModalById(id);
}

document.addEventListener('keydown', function(e) {
    if (e.key === 'Escape') {
        closeModalById('removeItemModal');
        closeModalById('cancelBatchModal');
    }
});

/* ── Remove Item Modal ──────────────────────────────────── */
function openRemoveItemModal(itemId, itemName, batchId) {
    document.getElementById('removeItemName').textContent = itemName;
    const ctx = '${pageContext.request.contextPath}';
    document.getElementById('removeItemForm').action =
        ctx + '/admin/batches/' + batchId + '/items/' + itemId + '/remove';
    document.getElementById('removeItemModal').style.display = 'flex';
    document.body.style.overflow = 'hidden';
}

/* ── Cancel Batch Modal ─────────────────────────────────── */
function openCancelBatchModal(batchId, poCode) {
    document.getElementById('cancelBatchCode').textContent = 'B' + String(batchId).padStart(4,'0') + ' [' + poCode + ']';
    const ctx = '${pageContext.request.contextPath}';
    document.getElementById('cancelBatchForm').action =
        ctx + '/admin/batches/' + batchId + '/cancel';
    document.getElementById('cancelBatchModal').style.display = 'flex';
    document.body.style.overflow = 'hidden';
}
</script>

<style>
/* ── Action button: Remove Item (dòng con - màu vàng cam) ── */
.action-link--remove {
    background: none; border: none;
    color: #F59E0B; cursor: pointer; padding: 0;
    font-size: 0.8rem; font-family: inherit; font-weight: 600;
    transition: color 0.2s; text-decoration: none;
}
.action-link--remove:hover { color: #D97706; text-decoration: underline; }

/* ── Action button: Cancel Batch (dòng cha - màu đỏ) ─────── */
.action-link--cancel-batch {
    background: none; border: none;
    color: #EF4444; cursor: pointer; padding: 0;
    font-size: 0.8rem; font-family: inherit; font-weight: 600;
    transition: color 0.2s; text-decoration: none;
}
.action-link--cancel-batch:hover { color: #DC2626; text-decoration: underline; }

/* ── Modal overlay ──────────────────────────────────────── */
.bm-modal-overlay {
    position: fixed; inset: 0;
    background: rgba(15, 23, 42, 0.55);
    backdrop-filter: blur(4px);
    display: flex; align-items: center; justify-content: center;
    z-index: 9000;
    animation: bmFadeIn 0.18s ease;
}
@keyframes bmFadeIn { from { opacity: 0; } to { opacity: 1; } }

.bm-modal-box {
    background: #ffffff; border-radius: 18px;
    padding: 36px 32px 28px; max-width: 460px; width: 92%;
    box-shadow: 0 24px 64px rgba(0,0,0,0.22);
    text-align: center;
    animation: bmSlideUp 0.2s ease;
}
@keyframes bmSlideUp {
    from { transform: translateY(24px); opacity: 0; }
    to   { transform: translateY(0);    opacity: 1; }
}

.bm-modal-icon {
    width: 56px; height: 56px; border-radius: 50%;
    display: flex; align-items: center; justify-content: center;
    margin: 0 auto 18px;
}
.bm-modal-icon svg { width: 28px; height: 28px; }
.bm-modal-icon--warning { background: #FEF3C7; color: #D97706; }
.bm-modal-icon--danger  { background: #FEE2E2; color: #DC2626; }

.bm-modal-title {
    font-size: 1.18rem; font-weight: 800; color: #0F172A;
    margin: 0 0 10px;
}
.bm-modal-desc {
    font-size: 0.875rem; color: #475569;
    line-height: 1.65; margin: 0 0 24px;
}
.bm-modal-note {
    display: block; margin-top: 10px;
    font-size: 0.8rem; color: #94A3B8;
    text-align: left;
    background: #F8FAFC; border-radius: 8px;
    padding: 10px 12px; line-height: 1.7;
}
.bm-modal-note code {
    background: #F1F5F9; padding: 1px 7px; border-radius: 4px;
    font-size: 0.85em; font-weight: 700;
}

.bm-modal-actions {
    display: flex; gap: 10px; justify-content: center; flex-wrap: wrap;
}
.bm-btn {
    padding: 10px 22px; border-radius: 9px;
    font-size: 0.875rem; font-weight: 700;
    font-family: inherit; cursor: pointer;
    transition: background 0.2s, transform 0.15s; border: none;
    white-space: nowrap;
}
.bm-btn--ghost   { background: #F1F5F9; color: #475569; }
.bm-btn--ghost:hover { background: #E2E8F0; }
.bm-btn--warning { background: #F59E0B; color: #ffffff; }
.bm-btn--warning:hover { background: #D97706; transform: translateY(-1px); }
.bm-btn--danger  { background: #EF4444; color: #ffffff; }
.bm-btn--danger:hover  { background: #DC2626; transform: translateY(-1px); }
</style>