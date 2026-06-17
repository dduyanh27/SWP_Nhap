<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Order List</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/sales.css">
</head>
<body>

<c:set var="activePage" value="orders"/>

<jsp:include page="../common/header-sales.jsp"/>
<!-- Content -->
<div class="main">
    <div class="card">

        <!-- Toolbar -->
        <div class="toolbar">
            <h2>Order List</h2>
            <form method="get" action="${pageContext.request.contextPath}/sales/orders" style="display:flex;gap:8px;">
                <input type="hidden" name="status" value="${status}">
                <input type="text" name="phone" value="${phone}" placeholder="Tìm theo số ĐT khách hàng...">
                <button type="submit" class="btn-search">Tìm</button>
            </form>
        </div>

        <!-- Filter tabs -->
        <div class="filter-tabs">
            <a href="?phone=${phone}&status=" class="${status == '' ? 'active' : ''}">All</a>
            <a href="?phone=${phone}&status=PENDING" class="${status == 'PENDING' ? 'active' : ''}">Pending</a>
            <a href="?phone=${phone}&status=CONFIRMED" class="${status == 'CONFIRMED' ? 'active' : ''}">Confirmed</a>
            <a href="?phone=${phone}&status=DELIVERING" class="${status == 'DELIVERING' ? 'active' : ''}">Delivering</a>
            <a href="?phone=${phone}&status=COMPLETED" class="${status == 'COMPLETED' ? 'active' : ''}">Completed</a>
            <a href="?phone=${phone}&status=CANCELLED" class="${status == 'CANCELLED' ? 'active' : ''}">Cancelled</a>
        </div>
        <!-- Table -->
        <table>
            <thead>
            <tr>
                <th>Mã Đơn</th>
                <th>Tên người nhận</th>
                <th>SĐT</th>
                <th>Địa chỉ</th>
                <th>Ngày đặt đơn</th>
                <th>Trạng thái</th>
                <th>Chi tiết</th>
                <th>Hành động</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="o" items="${orders.content}">
                <tr>
                    <td><a href="#">#${o.orderId}</a></td>
                    <td>${o.address.receiverName}</td>
                    <td>${o.address.phone}</td>
                    <td>${o.address.fullAddress}</td>
                    <td>${o.orderDate.dayOfMonth}/${o.orderDate.monthValue}/${o.orderDate.year}</td>
                    <td>
                        <c:choose>
                            <c:when test="${o.orderStatus == 'PENDING'}">
                                <span class="badge badge-pending">Pending</span>
                            </c:when>
                            <c:when test="${o.orderStatus == 'CONFIRMED'}">
                                <span class="badge badge-confirmed">Confirmed</span>
                            </c:when>
                            <c:when test="${o.orderStatus == 'DELIVERING'}">
                                <span class="badge badge-delivering">Delivering</span>
                            </c:when>
                            <c:when test="${o.orderStatus == 'COMPLETED'}">
                                <span class="badge badge-completed">Completed</span>
                            </c:when>
                            <c:when test="${o.orderStatus == 'CANCELLED'}">
                                <span class="badge badge-cancelled">Cancelled</span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge">${o.orderStatus}</span>
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td style="position: relative;">
                        <button type="button"
                                class="btn-view"
                                data-order-id="${o.orderId}"
                                data-status="${o.orderStatus}"
                                title="Xem chi tiết">👁</button>

                        <div class="order-tooltip"></div>
                    </td>
                    <td>
                        <c:choose>
                            <c:when test="${o.orderStatus == 'PENDING'}">
                                <%-- Hàng nút: Xác nhận + Hủy --%>
                                <div style="display:flex; gap:8px; justify-content:center;">
                                    <form method="post" action="${pageContext.request.contextPath}/sales/orders/${o.orderId}/confirm">
                                        <button type="submit" class="btn-confirm">Xác nhận đơn</button>
                                    </form>
                                    <form method="post" action="${pageContext.request.contextPath}/sales/orders/${o.orderId}/cancel"
                                          onsubmit="return confirm('Bạn có chắc muốn hủy đơn #${o.orderId}?')">
                                        <button type="submit" class="btn-cancel-order">Hủy</button>
                                    </form>
                                </div>
                            </c:when>
                            <c:when test="${o.orderStatus == 'CONFIRMED'}">
                                <button class="btn-deliver" id="btn-deliver-${o.orderId}" data-order-id="${o.orderId}" disabled>Giao hàng</button>
                            </c:when>
                            <c:when test="${o.orderStatus == 'DELIVERING'}">
                                <form method="post" action="${pageContext.request.contextPath}/sales/orders/${o.orderId}/complete"
                                      onsubmit="return confirm('Xác nhận đơn #${o.orderId} đã giao thành công?')">
                                    <button type="submit" class="btn-complete">Đã giao đến nơi</button>
                                </form>
                            </c:when>
                            <c:when test="${o.orderStatus == 'COMPLETED'}">
                                <span class="text-muted">Đơn hàng đã giao thành công</span>
                            </c:when>
                            <c:when test="${o.orderStatus == 'CANCELLED'}">
                                <span class="text-muted">Đơn hàng đã bị hủy</span>
                            </c:when>
                        </c:choose>
                    </td>
                </tr>
                <tr class="expand-row" id="expand-${o.orderId}">
                    <td colspan="8">
                        <div class="expand-content" id="expand-content-${o.orderId}">
                                <%-- JS sẽ fill vào đây --%>
                        </div>
                    </td>
                </tr>
            </c:forEach>
            <c:if test="${empty orders.content}">
                <tr><td colspan="8" style="text-align:center;color:#aaa;padding:30px;">Không có đơn hàng nào</td></tr>
            </c:if>
            </tbody>
        </table>

        <!-- Pagination -->
        <div class="pagination">
            <c:if test="${totalPages > 0}">
                <div class="pagination">
                    <c:choose>
                        <c:when test="${currentPage > 0}">
                            <a href="?phone=${phone}&status=${status}&page=${currentPage - 1}">« Trước</a>
                        </c:when>
                        <c:otherwise><span class="disabled">« Trước</span></c:otherwise>
                    </c:choose>

                    <c:forEach begin="0" end="${totalPages - 1}" var="i">
                        <a href="?phone=${phone}&status=${status}&page=${i}"
                           class="${i == currentPage ? 'active-page' : ''}">${i + 1}</a>
                    </c:forEach>

                    <c:choose>
                        <c:when test="${currentPage < totalPages - 1}">
                            <a href="?phone=${phone}&status=${status}&page=${currentPage + 1}">Sau »</a>
                        </c:when>
                        <c:otherwise><span class="disabled">Sau »</span></c:otherwise>
                    </c:choose>
                </div>
            </c:if>
        </div>

    </div>
</div>
<script>
    document.addEventListener('DOMContentLoaded', function () {
        const contextPath = '${pageContext.request.contextPath}';
        const tooltipCache = {};
        let currentDeliverOrderId = null;

        // ============================================================
        // HELPER
        // ============================================================
        function money(value) {
            return Number(value || 0).toLocaleString('vi-VN') + 'đ';
        }

        function shortDate(value) {
            if (!value) return 'Chưa có';
            return value.replace('T', ' ').substring(0, 16);
        }

        // ============================================================
        // 1. NÚT MẮT → MỞ MODAL CHI TIẾT (tất cả trạng thái)
        // ============================================================
        // ============================================================
// 1. NÚT MẮT → EXPAND ROW BÊN DƯỚI
// ============================================================
        document.querySelectorAll('.btn-view').forEach(function (btn) {
            btn.addEventListener('click', async function (e) {
                e.preventDefault();
                e.stopPropagation();

                const orderId = btn.dataset.orderId;
                const content = document.getElementById('expand-content-' + orderId);

                // Nếu đang mở → đóng lại
                if (content.classList.contains('show')) {
                    content.classList.remove('show');
                    btn.classList.remove('active');
                    return;
                }

                // Đóng tất cả expand đang mở
                document.querySelectorAll('.expand-content.show').forEach(function (el) {
                    el.classList.remove('show');
                });
                document.querySelectorAll('.btn-view.active').forEach(function (el) {
                    el.classList.remove('active');
                });

                try {
                    const res = await fetch(contextPath + '/sales/orders/' + orderId + '/detail');
                    const data = await res.json();
                    if (!data.success) { alert('Không tải được chi tiết đơn hàng'); return; }
                    fillExpandDetail(content, data);
                    content.classList.add('show');
                    btn.classList.add('active');
                } catch (e) {
                    alert('Lỗi kết nối khi tải chi tiết đơn hàng');
                }
            });
        });

        function fillExpandDetail(container, data) {
            function money(v) { return Number(v || 0).toLocaleString('vi-VN') + 'đ'; }
            function shortDate(v) { return v ? v.replace('T', ' ').substring(0, 16) : 'Chưa có'; }

            const isPaid = data.paymentStatus === 'PAID';
            const paymentBadge = isPaid
                ? '<span class="badge-paid">✓ Đã thanh toán</span>'
                : '<span class="badge-unpaid">Chưa thanh toán</span>';

            const thumbColors = ['orange','red','yellow','blue'];
            const thumbEmojis = ['🍊','🍓','🍋','🫐'];

            let itemsHtml = '';
            (data.items || []).forEach(function (it, i) {
                const c = thumbColors[i % thumbColors.length];
                const e = thumbEmojis[i % thumbEmojis.length];
                itemsHtml +=
                    '<tr>' +
                    '<td style="text-align:center">' + (i + 1) + '</td>' +
                    '<td><div class="product-cell">' +
                    '<div class="product-thumb ' + c + '">' + e + '</div>' +
                    '<div class="product-info">' +
                    '<b>' + it.productName + '</b>' +
                    '<small>Xuất xứ: ' + (it.origin || 'Không rõ') + '</small>' +
                    '</div>' +
                    '</div></td>' +
                    '<td style="text-align:center">' + money(it.unitPrice) + '</td>' +
                    '<td style="text-align:center">/ ' + (it.unit || '') + '</td>' +
                    '<td style="text-align:center">' + it.quantity + ' ' + (it.unit || '') + '</td>' +
                    '<td style="text-align:right"><b>' + money(it.lineTotal) + '</b></td>' +
                    '</tr>';
            });

            const subtotal = Number(data.subtotalAmount || 0);
            const ship     = Number(data.shippingFee || 0);
            const total    = Number(data.totalAmount || 0);
            const discount = subtotal + ship - total;
            const discountHtml = data.discountCode
                ? '<span class="badge-discount">' + data.discountCode + '</span>'
                : 'Không có';

            container.innerHTML =
                // HEADER
                '<div class="expand-header">' +
                '<div class="expand-header-left">' +
                '<div class="expand-header-icon">' +
                '<svg viewBox="0 0 24 24" fill="none" stroke="#2563EB" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">' +
                '<path d="M6 2L3 6v14a2 2 0 002 2h14a2 2 0 002-2V6l-3-4z"/><line x1="3" y1="6" x2="21" y2="6"/><path d="M16 10a4 4 0 01-8 0"/></svg>' +
                '</div>' +
                '<h2>CHI TIẾT ĐƠN HÀNG <span>#ORD' + data.orderId + '</span></h2>' +
                '</div>' +
                '<span class="expand-status">' + (data.orderStatus || '') + '</span>' +
                '</div>' +

                // 3 BOX INFO
                '<div class="expand-top-grid">' +
                '<div class="expand-box">' +
                '<div class="expand-box-title">' +
                '<div class="expand-box-icon blue"><svg viewBox="0 0 24 24" fill="none" stroke="#2563EB" stroke-width="2" stroke-linecap="round"><circle cx="12" cy="8" r="4"/><path d="M4 20c0-4 3.6-7 8-7s8 3 8 7"/></svg></div>' +
                '<h4>THÔNG TIN KHÁCH HÀNG</h4>' +
                '</div>' +
                '<p><span>Họ tên:</span><b>' + (data.customerName || '') + '</b></p>' +
                '<p><span>SĐT:</span><b>' + (data.customerPhone || '') + '</b></p>' +
                '<p><span>Email:</span><b>' + (data.customerEmail || '') + '</b></p>' +
                '<p><span>Ngày đặt:</span><b>' + shortDate(data.orderDate) + '</b></p>' +
                '</div>' +
                '<div class="expand-box">' +
                '<div class="expand-box-title">' +
                '<div class="expand-box-icon green"><svg viewBox="0 0 24 24" fill="none" stroke="#0b8f5a" stroke-width="2" stroke-linecap="round"><path d="M12 2C8 2 5 5 5 9c0 5 7 13 7 13s7-8 7-13c0-4-3-7-7-7z"/><circle cx="12" cy="9" r="2.5"/></svg></div>' +
                '<h4>THÔNG TIN NGƯỜI NHẬN</h4>' +
                '</div>' +
                '<p><span>Người nhận:</span><b>' + (data.receiverName || '') + '</b></p>' +
                '<p><span>SĐT nhận:</span><b>' + (data.receiverPhone || '') + '</b></p>' +
                '<p><span>Địa chỉ:</span><b>' + (data.address || '') + '</b></p>' +
                '</div>' +
                '<div class="expand-box">' +
                '<div class="expand-box-title">' +
                '<div class="expand-box-icon purple"><svg viewBox="0 0 24 24" fill="none" stroke="#4f46e5" stroke-width="2" stroke-linecap="round"><path d="M14 2H6a2 2 0 00-2 2v16a2 2 0 002 2h12a2 2 0 002-2V8z"/><polyline points="14 2 14 8 20 8"/><line x1="8" y1="13" x2="16" y2="13"/><line x1="8" y1="17" x2="16" y2="17"/></svg></div>' +
                '<h4>THÔNG TIN ĐƠN HÀNG</h4>' +
                '</div>' +
                '<p><span>Đơn vị VC:</span><b>' + (data.shippingProvider || 'Chưa có') + '</b></p>' +
                '<p><span>Mã vận đơn:</span><b>' + (data.shippingCode || 'Chưa có') + '</b></p>' +
                '<p><span>Ngày dự kiến:</span><b>' + (data.expectedDeliveryDate || 'Chưa có') + '</b></p>' +
                '<p><span>Trạng thái TT:</span><b>' + paymentBadge + '</b></p>' +
                '</div>' +
                '</div>' +

                // BẢNG SẢN PHẨM
                '<div class="expand-product-box">' +
                '<div class="expand-product-title">' +
                '<div class="expand-box-icon blue"><svg viewBox="0 0 24 24" fill="none" stroke="#2563EB" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M6 2L3 6v14a2 2 0 002 2h14a2 2 0 002-2V6l-3-4z"/><line x1="3" y1="6" x2="21" y2="6"/></svg></div>' +
                '<h4>DANH SÁCH SẢN PHẨM</h4>' +
                '</div>' +
                '<table class="expand-product-table">' +
                '<thead><tr><th>STT</th><th>Sản phẩm</th><th>Đơn giá</th><th>Đơn vị</th><th>Số lượng</th><th>Thành tiền</th></tr></thead>' +
                '<tbody>' + itemsHtml + '</tbody>' +
                '</table>' +
                '</div>' +

                // BOTTOM
                '<div class="expand-bottom">' +
                '<div class="expand-note">' +
                '<div class="expand-note-title">' +
                '<div class="expand-box-icon purple"><svg viewBox="0 0 24 24" fill="none" stroke="#4f46e5" stroke-width="2" stroke-linecap="round"><path d="M14 2H6a2 2 0 00-2 2v16a2 2 0 002 2h12a2 2 0 002-2V8z"/><polyline points="14 2 14 8 20 8"/><line x1="8" y1="13" x2="16" y2="13"/></svg></div>' +
                '<h4>GHI CHÚ</h4>' +
                '</div>' +
                '<div class="expand-note-input">Không có ghi chú</div>' +
                '</div>' +
                '<div class="expand-money">' +
                '<p><span>Tạm tính:</span><b>' + money(subtotal) + '</b></p>' +
                '<p><span>Phí vận chuyển:</span><b>' + money(ship) + '</b></p>' +
                '<p><span>Mã giảm giá:</span><b>' + discountHtml + '</b></p>' +
                '<p><span>Giảm giá:</span><b class="money-discount">' + (discount > 0 ? '-' + money(discount) : '0đ') + '</b></p>' +
                '<hr>' +
                '<p class="expand-total"><span>TỔNG THANH TOÁN:</span><b>' + money(total) + '</b></p>' +
                '</div>' +
                '</div>';
        }
        // ============================================================
        // 2. HOVER TOOLTIP → chỉ cho đơn CONFIRMED
        // ============================================================
        document.querySelectorAll('.btn-view[data-status="CONFIRMED"]').forEach(function (btn) {
            const wrapper = btn.closest('td');
            const tooltip = wrapper.querySelector('.order-tooltip');
            if (!tooltip) return;
            const orderId = btn.dataset.orderId;

            wrapper.addEventListener('mouseenter', async function () {
                if (!tooltipCache[orderId]) {
                    try {
                        const res = await fetch(contextPath + '/sales/orders/' + orderId + '/items');
                        tooltipCache[orderId] = await res.json();
                    } catch (e) {
                        tooltipCache[orderId] = [];
                    }
                }
                renderTooltip(tooltip, tooltipCache[orderId], orderId);
                tooltip.classList.add('show');
            });

            wrapper.addEventListener('mouseleave', function () {
                tooltip.classList.remove('show');
            });
        });

        function renderTooltip(tooltip, items, orderId) {
            if (!items || items.length === 0) {
                tooltip.innerHTML = '<div class="tooltip-empty">Không có sản phẩm</div>';
                return;
            }
            let html = '<table class="tooltip-table"><thead><tr><th>Sản phẩm</th><th>Số lượng</th><th>Đã chuẩn bị</th></tr></thead><tbody>';
            items.forEach(function (it) {
                html += '<tr>' +
                    '<td>' + it.productName + '</td>' +
                    '<td>' + it.quantity + ' ' + it.unit + '</td>' +
                    '<td style="text-align:center;"><input type="checkbox" class="prepare-checkbox" data-item-id="' + it.orderItemId + '" ' + (it.preparedStatus ? 'checked' : '') + '></td>' +
                    '</tr>';
            });
            html += '</tbody></table>';
            tooltip.innerHTML = html;

            tooltip.querySelectorAll('.prepare-checkbox').forEach(function (cb) {
                cb.addEventListener('change', async function () {
                    const itemId   = this.dataset.itemId;
                    const prepared = this.checked;
                    try {
                        await fetch(contextPath + '/sales/orders/items/' + itemId + '/prepare?prepared=' + prepared, { method: 'POST' });
                        const list = tooltipCache[orderId];
                        const idx  = list.findIndex(function (x) { return x.orderItemId == itemId; });
                        if (idx !== -1) list[idx].preparedStatus = prepared;
                        const allReady   = list.every(function (x) { return x.preparedStatus; });
                        const deliverBtn = document.getElementById('btn-deliver-' + orderId);
                        if (deliverBtn) {
                            deliverBtn.disabled = !allReady;
                            deliverBtn.title    = allReady ? '' : 'Cần tích hết sản phẩm trước khi giao hàng';
                        }
                    } catch (e) {
                        console.error('Lỗi cập nhật', e);
                        this.checked = !prepared;
                    }
                });
            });
        }

        // ============================================================
        // 3. KIỂM TRA NÚT "GIAO HÀNG" KHI LOAD TRANG
        // ============================================================
        document.querySelectorAll('[id^="btn-deliver-"]').forEach(async function (btn) {
            const orderId = btn.id.replace('btn-deliver-', '');
            try {
                const res  = await fetch(contextPath + '/sales/orders/' + orderId + '/ready');
                const data = await res.json();
                btn.disabled = !data.ready;
                btn.title    = data.ready ? '' : 'Cần tích hết sản phẩm trước khi giao hàng';
            } catch (e) {
                btn.disabled = true;
            }
        });

        // ============================================================
        // 4. POPUP GIAO HÀNG
        // ============================================================
        const providerConfig = {
            'GHN':            { placeholder: 'VD: GHN12345678',   regex: /^GHN\d{8}$/ },
            'GHTK':           { placeholder: 'VD: GHTK12345678',  regex: /^GHTK\d{8}$/ },
            'J&T Express':    { placeholder: 'VD: JT1234567890',  regex: /^JT\d{10}$/ },
            'Viettel Post':   { placeholder: 'VD: VTP123456789',  regex: /^VTP\d{9}$/ },
            'VNPost':         { placeholder: 'VD: VN123456789',   regex: /^VN\d{9}$/ },
            'Shopee Express': { placeholder: 'VD: SPX1234567890', regex: /^SPX\d{10}$/ }
        };

        (async function loadProviders() {
            try {
                const res       = await fetch(contextPath + '/sales/shipping-providers');
                const providers = await res.json();
                const select    = document.getElementById('popupProvider');
                providers.forEach(function (p) {
                    const opt = document.createElement('option');
                    opt.value = p.id;
                    opt.textContent = p.name;
                    select.appendChild(opt);
                });
            } catch (e) {
                console.error('Lỗi load đơn vị vận chuyển', e);
            }
        })();

        window.onProviderChange = function () {
            const select       = document.getElementById('popupProvider');
            const selectedText = select.options[select.selectedIndex].text;
            const input        = document.getElementById('popupShippingCode');
            const errorEl      = document.getElementById('shippingCodeError');
            const config       = providerConfig[selectedText];
            input.placeholder  = config ? config.placeholder : 'Nhập mã vận đơn';
            input.value        = '';
            if (errorEl) errorEl.textContent = '';
        };

        function validateShippingCode() {
            const select       = document.getElementById('popupProvider');
            const selectedText = select.options[select.selectedIndex].text;
            const code         = document.getElementById('popupShippingCode').value.trim();
            const errorEl      = document.getElementById('shippingCodeError');
            if (!code) { errorEl.textContent = 'Vui lòng nhập mã vận đơn.'; return false; }
            const config = providerConfig[selectedText];
            if (config && !config.regex.test(code)) {
                errorEl.textContent = 'Mã không đúng định dạng. ' + config.placeholder;
                return false;
            }
            errorEl.textContent = '';
            return true;
        }

        function setMinDate() {
            const tomorrow = new Date();
            tomorrow.setDate(tomorrow.getDate() + 1);
            const yyyy = tomorrow.getFullYear();
            const mm   = String(tomorrow.getMonth() + 1).padStart(2, '0');
            const dd   = String(tomorrow.getDate()).padStart(2, '0');
            document.getElementById('popupDeliveryDate').min = yyyy + '-' + mm + '-' + dd;
        }

        document.querySelectorAll('.btn-deliver').forEach(function (btn) {
            btn.addEventListener('click', function () {
                currentDeliverOrderId = btn.dataset.orderId;
                const row   = btn.closest('tr');
                const cells = row.querySelectorAll('td');
                document.getElementById('popupOrderId').textContent  = '#' + currentDeliverOrderId;
                document.getElementById('popupReceiver').textContent = cells[1].textContent.trim();
                document.getElementById('popupPhone').textContent    = cells[2].textContent.trim();
                document.getElementById('popupAddress').textContent  = cells[3].textContent.trim();
                document.getElementById('popupShippingCode').value   = '';
                document.getElementById('popupDeliveryDate').value   = '';
                document.getElementById('shippingCodeError').textContent = '';
                setMinDate();
                document.getElementById('deliverOverlay').classList.add('show');
            });
        });

        window.closeDeliverPopup = function () {
            document.getElementById('deliverOverlay').classList.remove('show');
            currentDeliverOrderId = null;
        };

        window.submitDeliver = async function () {
            const providerId   = document.getElementById('popupProvider').value;
            const shippingCode = document.getElementById('popupShippingCode').value.trim();
            const deliveryDate = document.getElementById('popupDeliveryDate').value;
            if (!providerId)             { alert('Vui lòng chọn đơn vị vận chuyển'); return; }
            if (!validateShippingCode()) return;
            if (!deliveryDate)           { alert('Vui lòng chọn ngày dự kiến giao'); return; }
            try {
                const params = new URLSearchParams({ providerId, shippingCode, deliveryDate });
                const res    = await fetch(contextPath + '/sales/orders/' + currentDeliverOrderId + '/deliver', {
                    method: 'POST', body: params
                });
                const data = await res.json();
                if (data.success) {
                    closeDeliverPopup();
                    location.reload();
                } else if (data.errorCode === 'DUPLICATE_CODE') {
                    document.getElementById('shippingCodeError').textContent = 'Mã vận đơn đã tồn tại, vui lòng nhập mã khác.';
                } else {
                    alert('Có lỗi xảy ra, vui lòng thử lại.');
                }
            } catch (e) {
                alert('Lỗi kết nối.');
            }
        };

    }); // end DOMContentLoaded
</script>

<!-- Popup Giao hàng -->
<div id="deliverOverlay" class="overlay">
    <div class="popup">
        <h3 class="popup-title">🚚 GIAO HÀNG ĐƠN <span id="popupOrderId"></span></h3>
        <hr>
        <p class="popup-info">Người nhận: <strong id="popupReceiver"></strong></p>
        <p class="popup-info">SĐT: <strong id="popupPhone"></strong></p>
        <p class="popup-info" style="margin-bottom:16px;">Địa chỉ: <strong id="popupAddress"></strong></p>
        <hr>
        <label>Đơn vị vận chuyển (*)</label>
        <select id="popupProvider" onchange="onProviderChange()">
            <option value="">-- Chọn đơn vị --</option>
        </select>
        <label>Mã vận đơn (*)</label>
        <input type="text" id="popupShippingCode" placeholder="Nhập mã vận đơn">
        <span id="shippingCodeError" style="color:red; font-size:12px; margin-top:-10px; display:block; margin-bottom:12px;"></span>

        <label>Ngày dự kiến giao (*)</label>
        <input type="date" id="popupDeliveryDate">
        <div class="popup-actions">
            <button class="btn-cancel-popup" onclick="closeDeliverPopup()">Hủy</button>
            <button class="btn-confirm" onclick="submitDeliver()">Xác nhận</button>
        </div>
    </div>
</div>

</body>
</html>
