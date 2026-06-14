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
                        <button class="btn-view" data-order-id="${o.orderId}" data-status="${o.orderStatus}" title="Xem chi tiết">👁</button>

                        <div class="order-tooltip"></div>
                    </td>
                    <td>
                        <c:choose>
                            <c:when test="${o.orderStatus == 'PENDING'}">
                                <form method="post" action="${pageContext.request.contextPath}/sales/orders/${o.orderId}/confirm">
                                    <button type="submit" class="btn-confirm">Xác nhận đơn</button>
                                </form>
                            </c:when>
                            <c:when test="${o.orderStatus == 'CONFIRMED'}">
                                <button class="btn-deliver" id="btn-deliver-${o.orderId}" data-order-id="${o.orderId}" disabled>Giao hàng</button>
                            </c:when>
                            <c:when test="${o.orderStatus == 'DELIVERING'}">
                                <span class="text-muted">Đơn hàng đang được giao</span>
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
        const cache = {};

        document.querySelectorAll('.btn-view').forEach(function (btn) {
            const tooltip = btn.nextElementSibling;
            const wrapper = btn.closest('td');
            const orderId = btn.dataset.orderId;

            wrapper.addEventListener('mouseenter', async function () {
                if (!cache[orderId]) {
                    try {
                        const res = await fetch(contextPath + '/sales/orders/' + orderId + '/items');
                        cache[orderId] = await res.json();
                    } catch (e) {
                        cache[orderId] = [];
                    }
                }
                renderTooltip(tooltip, cache[orderId], orderId);
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
            let html = '<table class="tooltip-table">';
            html += '<thead><tr><th>Sản phẩm</th><th>Số lượng</th><th>Đã chuẩn bị</th></tr></thead>';
            html += '<tbody>';
            items.forEach(function (it) {
                const checked = it.preparedStatus ? 'checked' : '';
                html += '<tr>' +
                    '<td>' + it.productName + '</td>' +
                    '<td>' + it.quantity + ' ' + it.unit + '</td>' +
                    '<td style="text-align:center;">' +
                    '<input type="checkbox" class="prepare-checkbox" data-item-id="' + it.orderItemId + '" ' + checked + '>' +
                    '</td>' +
                    '</tr>';
            });
            html += '</tbody></table>';
            tooltip.innerHTML = html;

            tooltip.querySelectorAll('.prepare-checkbox').forEach(function (cb) {
                cb.addEventListener('change', async function () {
                    const itemId = this.dataset.itemId;
                    const prepared = this.checked;
                    try {
                        await fetch(contextPath + '/sales/orders/items/' + itemId + '/prepare?prepared=' + prepared, {
                            method: 'POST'
                        });
                        const itemsList = cache[orderId];
                        const idx = itemsList.findIndex(function (x) { return x.orderItemId == itemId; });
                        if (idx !== -1) itemsList[idx].preparedStatus = prepared;
                        const allReady = itemsList.every(function (x) { return x.preparedStatus; });
                        const deliverBtn = document.getElementById('btn-deliver-' + orderId);
                        if (deliverBtn) deliverBtn.disabled = !allReady;
                    } catch (e) {
                        console.error('Cập nhật trạng thái thất bại', e);
                        this.checked = !prepared;
                    }
                });
            });
        }
    });

    document.querySelectorAll('[id^="btn-deliver-"]').forEach(async function (btn) {
        const orderId = btn.id.replace('btn-deliver-', '');
        try {
            const res = await fetch(contextPath + '/sales/orders/' + orderId + '/ready');
            const data = await res.json();
            if (data.ready) {
                btn.disabled = false;
                btn.title = '';
            } else {
                btn.disabled = true;
                btn.title = 'Cần tích hết sản phẩm đã chuẩn bị trước khi giao hàng';
            }
        } catch (e) {
            btn.disabled = true;
        }
    });


    document.addEventListener('DOMContentLoaded', function () {
        const contextPath = '${pageContext.request.contextPath}';
        const cache = {};
        let currentDeliverOrderId = null;

        // ===== TOOLTIP =====
        document.querySelectorAll('.btn-view').forEach(function (btn) {
            const tooltip = btn.nextElementSibling;
            const wrapper = btn.closest('td');
            const orderId = btn.dataset.orderId;
            const status = btn.dataset.status;

            if (status === 'DELIVERING' || status === 'COMPLETED' || status === 'CANCELLED') return;

            wrapper.addEventListener('mouseenter', async function () {
                if (!cache[orderId]) {
                    try {
                        const res = await fetch(contextPath + '/sales/orders/' + orderId + '/items');
                        cache[orderId] = await res.json();
                    } catch (e) {
                        cache[orderId] = [];
                    }
                }
                renderTooltip(tooltip, cache[orderId], orderId, status === 'PENDING');
                tooltip.classList.add('show');
            });

            wrapper.addEventListener('mouseleave', function () {
                tooltip.classList.remove('show');
            });
        });

        function renderTooltip(tooltip, items, orderId, readonly) {
            if (!items || items.length === 0) {
                tooltip.innerHTML = '<div class="tooltip-empty">Không có sản phẩm</div>';
                return;
            }
            let html = '<table class="tooltip-table">';
            html += '<thead><tr><th>Sản phẩm</th><th>Số lượng</th><th>Đã chuẩn bị</th></tr></thead><tbody>';
            items.forEach(function (it) {
                const checked = it.preparedStatus ? 'checked' : '';
                const disabled = readonly ? 'disabled' : '';
                html += '<tr>' +
                    '<td>' + it.productName + '</td>' +
                    '<td>' + it.quantity + ' ' + it.unit + '</td>' +
                    '<td style="text-align:center;"><input type="checkbox" class="prepare-checkbox" data-item-id="' + it.orderItemId + '" ' + checked + ' ' + disabled + '></td>' +
                    '</tr>';
            });
            html += '</tbody></table>';
            tooltip.innerHTML = html;

            if (readonly) return;

            tooltip.querySelectorAll('.prepare-checkbox').forEach(function (cb) {
                cb.addEventListener('change', async function () {
                    const itemId = this.dataset.itemId;
                    const prepared = this.checked;
                    try {
                        await fetch(contextPath + '/sales/orders/items/' + itemId + '/prepare?prepared=' + prepared, { method: 'POST' });
                        const itemsList = cache[orderId];
                        const idx = itemsList.findIndex(function (x) { return x.orderItemId == itemId; });
                        if (idx !== -1) itemsList[idx].preparedStatus = prepared;
                        const allReady = itemsList.every(function (x) { return x.preparedStatus; });
                        const deliverBtn = document.getElementById('btn-deliver-' + orderId);
                        if (deliverBtn) deliverBtn.disabled = !allReady;
                    } catch (e) {
                        console.error('Lỗi cập nhật', e);
                        this.checked = !prepared;
                    }
                });
            });
        }

        // ===== KIỂM TRA NÚT GIAO HÀNG KHI LOAD TRANG =====
        document.querySelectorAll('[id^="btn-deliver-"]').forEach(async function (btn) {
            const orderId = btn.id.replace('btn-deliver-', '');
            try {
                const res = await fetch(contextPath + '/sales/orders/' + orderId + '/ready');
                const data = await res.json();
                btn.disabled = !data.ready;
                btn.title = data.ready ? '' : 'Cần tích hết sản phẩm trước khi giao hàng';
            } catch (e) {
                btn.disabled = true;
            }
        });

        // ===== POPUP GIAO HÀNG =====
        async function loadProviders() {
            try {
                const res = await fetch(contextPath + '/sales/shipping-providers');
                const providers = await res.json();
                const select = document.getElementById('popupProvider');
                providers.forEach(function (p) {
                    const opt = document.createElement('option');
                    opt.value = p.id;
                    opt.textContent = p.name;
                    select.appendChild(opt);
                });
            } catch (e) {
                console.error('Lỗi load đơn vị vận chuyển', e);
            }
        }
        loadProviders();
// Config từng đơn vị vận chuyển
        const providerConfig = {
            'GHN':             { placeholder: 'VD: GHN12345678',    prefix: 'GHN',  digits: 8,  regex: /^GHN\d{8}$/ },
            'GHTK':            { placeholder: 'VD: GHTK12345678',   prefix: 'GHTK', digits: 8,  regex: /^GHTK\d{8}$/ },
            'J&T Express':     { placeholder: 'VD: JT1234567890',   prefix: 'JT',   digits: 10, regex: /^JT\d{10}$/ },
            'Viettel Post':    { placeholder: 'VD: VTP123456789',   prefix: 'VTP',  digits: 9,  regex: /^VTP\d{9}$/ },
            'VNPost':          { placeholder: 'VD: VN123456789',    prefix: 'VN',   digits: 9,  regex: /^VN\d{9}$/ },
            'Shopee Express':  { placeholder: 'VD: SPX1234567890',  prefix: 'SPX',  digits: 10, regex: /^SPX\d{10}$/ }
        };

        window.onProviderChange = function () {
            const select = document.getElementById('popupProvider');
            const selectedText = select.options[select.selectedIndex].text;
            const input = document.getElementById('popupShippingCode');
            const errorEl = document.getElementById('shippingCodeError');

            const config = providerConfig[selectedText];
            if (config) {
                input.placeholder = config.placeholder;
            } else {
                input.placeholder = 'Nhập mã vận đơn';
            }
            input.value = '';
            if (errorEl) errorEl.textContent = '';
        };

        function validateShippingCode() {
            const select = document.getElementById('popupProvider');
            const selectedText = select.options[select.selectedIndex].text;
            const code = document.getElementById('popupShippingCode').value.trim();
            const errorEl = document.getElementById('shippingCodeError');

            if (!code) {
                errorEl.textContent = 'Vui lòng nhập mã vận đơn.';
                return false;
            }
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
            const mm = String(tomorrow.getMonth() + 1).padStart(2, '0');
            const dd = String(tomorrow.getDate()).padStart(2, '0');
            document.getElementById('popupDeliveryDate').min = yyyy + '-' + mm + '-' + dd;
        }

        document.querySelectorAll('.btn-deliver').forEach(function (btn) {
            btn.addEventListener('click', function () {
                currentDeliverOrderId = btn.dataset.orderId;
                const row = btn.closest('tr');
                const cells = row.querySelectorAll('td');
                document.getElementById('popupOrderId').textContent = '#' + currentDeliverOrderId;
                document.getElementById('popupReceiver').textContent = cells[1].textContent.trim();
                document.getElementById('popupPhone').textContent = cells[2].textContent.trim();
                document.getElementById('popupAddress').textContent = cells[3].textContent.trim();
                document.getElementById('popupShippingCode').value = '';
                document.getElementById('popupDeliveryDate').value = '';
                setMinDate();
                document.getElementById('deliverOverlay').classList.add('show');
            });
        });

        window.closeDeliverPopup = function () {
            document.getElementById('deliverOverlay').classList.remove('show');
            currentDeliverOrderId = null;
        };

        window.submitDeliver = async function () {
            const providerId = document.getElementById('popupProvider').value;
            const shippingCode = document.getElementById('popupShippingCode').value.trim();
            const deliveryDate = document.getElementById('popupDeliveryDate').value;

            if (!providerId) { alert('Vui lòng chọn đơn vị vận chuyển'); return; }
            if (!validateShippingCode()) return;   // validate format
            if (!deliveryDate) { alert('Vui lòng chọn ngày dự kiến giao'); return; }

            try {
                const params = new URLSearchParams({ providerId, shippingCode, deliveryDate });
                const res = await fetch(contextPath + '/sales/orders/' + currentDeliverOrderId + '/deliver', {
                    method: 'POST',
                    body: params
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
    });
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
