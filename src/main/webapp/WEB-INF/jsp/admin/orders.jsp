<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản Lý Đơn Hàng - VMFruit Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="<c:url value='/css/admin.css'/>">
</head>
<body>
<jsp:include page="/WEB-INF/jsp/common/admin-sidebar.jsp">
    <jsp:param name="activeMenu" value="orders" />
</jsp:include>

<div class="main-content">
    <div class="page-header">
        <div>
            <h1><i class="fas fa-shopping-bag"></i> Quản Lý Đơn Hàng</h1>
        </div>
    </div>

    <%-- Thông báo --%>
    <c:if test="${not empty successMessage}">
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            ✓ ${successMessage}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>
    <c:if test="${not empty errorMessage}">
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
            ✗ ${errorMessage}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>

    <div class="row mb-4">
        <div class="col-md-6">
            <div class="stat-card">
                <div class="stat-label">TỔNG DOANH THU</div>
                <div class="stat-value stat-revenue">
                    <fmt:formatNumber value="${totalRevenue}"/>đ
                </div>
            </div>
        </div>
        <div class="col-md-6">
            <div class="stat-card">
                <div class="stat-label">TỔNG ĐƠN HÀNG</div>
                <div class="stat-value stat-total">${totalOrders}</div>
            </div>
        </div>
    </div>

    <div class="table-container mb-3">
        <form method="GET" action="${pageContext.request.contextPath}/admin/orders" class="row g-3 align-items-end">

            <div class="col-md-2">
                <label class="form-label mb-1 fw-semibold">Trạng thái</label>
                <select name="status" class="form-select">
                    <option value="">-- Tất cả --</option>
                    <option value="PENDING"    ${filterStatus eq 'PENDING'    ? 'selected' : ''}>Chờ xác nhận</option>
                    <option value="CONFIRMED"  ${filterStatus eq 'CONFIRMED'  ? 'selected' : ''}>Đã xác nhận</option>
                    <option value="DELIVERING" ${filterStatus eq 'DELIVERING' ? 'selected' : ''}>Đang giao</option>
                    <option value="COMPLETED"  ${filterStatus eq 'COMPLETED'  ? 'selected' : ''}>Hoàn thành</option>
                    <option value="CANCELLED"  ${filterStatus eq 'CANCELLED'  ? 'selected' : ''}>Đã hủy</option>
                </select>
            </div>

            <div class="col-md-2">
                <label class="form-label mb-1 fw-semibold">Năm</label>
                <select name="year" class="form-select">
                    <option value="">-- Tất cả --</option>
                    <option value="2024" ${filterYear == 2024 ? 'selected' : ''}>2024</option>
                    <option value="2025" ${filterYear == 2025 ? 'selected' : ''}>2025</option>
                    <option value="2026" ${filterYear == 2026 ? 'selected' : ''}>2026</option>
                </select>
            </div>

            <div class="col-md-2">
                <label class="form-label mb-1 fw-semibold">Tháng</label>
                <select name="month" class="form-select">
                    <option value="">-- Tất cả --</option>
                    <c:forEach begin="1" end="12" var="m">
                        <option value="${m}" ${filterMonth == m ? 'selected' : ''}>Tháng ${m}</option>
                    </c:forEach>
                </select>
            </div>

            <div class="col-md-3">
                <button type="submit" class="btn btn-primary w-100 mb-1">
                    <i class="fas fa-filter"></i> Lọc
                </button>
                <a href="${pageContext.request.contextPath}/admin/orders" class="btn btn-outline-secondary w-100">
                    <i class="fas fa-undo"></i> Đặt lại
                </a>
            </div>

            <div class="col-md-3">
                <label class="form-label mb-1 fw-semibold">Tìm theo mã đơn</label>
                <input type="text" class="form-control" id="searchInput" placeholder="VD: FS-12" style="height: 40px;">
            </div>
        </form>
    </div>

    <%-- Bảng đơn hàng --%>
    <div class="table-container">
        <div class="d-flex justify-content-between align-items-center mb-3">
            <h5 class="mb-0">
                Danh sách đơn hàng
                <span class="badge bg-secondary ms-1">${orders.size()} đơn</span>
            </h5>
        </div>

        <div class="table-responsive">
            <table class="table table-hover align-middle" id="ordersTable">
                <thead class="table-header">
                <tr>
                    <th>MÃ ĐƠN</th>
                    <th>KHÁCH HÀNG</th>
                    <th>NGÀY ĐẶT</th>
                    <th>THANH TOÁN</th>
                    <th>TỔNG TIỀN</th>
                    <th>TRẠNG THÁI</th>
                    <th class="text-center">THAO TÁC</th>
                </tr>
                </thead>
                <tbody>
                <c:choose>
                    <c:when test="${not empty orders}">
                        <c:forEach var="order" items="${orders}">
                            <tr>
                                <td><strong>#FS-${order.orderId}</strong></td>

                                <td>${order.user.fullName}</td>

                                <td data-date="${order.orderDate}">
                                        ${order.orderDate}
                                </td>

                                <td>
                                    <c:choose>
                                        <c:when test="${order.paymentStatus eq 'PAID'}">
                                            <span class="badge bg-success">${order.paymentStatus}</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-warning text-dark">${order.paymentStatus}</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>

                                <td><fmt:formatNumber value="${order.totalAmount}" pattern="#,###"/>đ</td>

                                <td>
                                    <c:choose>
                                        <c:when test="${order.orderStatus eq 'PENDING'}">
                                            <span class="status-badge status-pending">Chờ xác nhận</span>
                                        </c:when>
                                        <c:when test="${order.orderStatus eq 'CONFIRMED'}">
                                            <span class="status-badge status-approved">Đã xác nhận</span>
                                        </c:when>
                                        <c:when test="${order.orderStatus eq 'DELIVERING'}">
                                            <span class="status-badge status-shipping">Đang giao</span>
                                        </c:when>
                                        <c:when test="${order.orderStatus eq 'COMPLETED'}">
                                            <span class="status-badge status-completed">Hoàn thành</span>
                                        </c:when>
                                        <c:when test="${order.orderStatus eq 'CANCELLED'}">
                                            <span class="status-badge status-cancelled">Đã hủy</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="status-badge">${order.orderStatus}</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>

                                <td class="text-center">
                                    <button type="button" class="btn btn-outline-primary btn-sm px-3"
                                            data-bs-toggle="modal"
                                            data-bs-target="#orderDetailsModal"
                                            onclick="openOrderDetails(
                                                ${order.orderId},
                                                    '${order.user.fullName}',
                                                    '${order.paymentStatus}',
                                                ${order.totalAmount},
                                                ${order.subtotalAmount},
                                                    '${order.orderStatus}')">
                                        <i class="fas fa-eye"></i> Chi tiết
                                    </button>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <tr>
                            <td colspan="7" class="text-center py-5 text-muted">
                                <i class="fas fa-box-open fa-3x mb-3 d-block text-secondary"></i>
                                <h5>Không có đơn hàng nào phù hợp với bộ lọc</h5>
                            </td>
                        </tr>
                    </c:otherwise>
                </c:choose>
                </tbody>
            </table>
        </div>
    </div>
</div>

<%-- Modal chi tiết đơn và Cập nhật trạng thái --%>
<div class="modal fade" id="orderDetailsModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header bg-light">
                <h5 class="modal-title fw-bold">Chi tiết đơn #FS-<span id="modalOrderId"></span></h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <div class="row mb-3 bg-light p-3 rounded mx-0">
                    <div class="col-md-6 mb-2 mb-md-0">
                        <span class="text-muted d-block">Khách hàng:</span>
                        <strong id="modalCustomer" class="fs-6"></strong>
                    </div>
                    <div class="col-md-6">
                        <span class="text-muted d-block">Thanh toán:</span>
                        <strong id="modalPaymentMethod" class="fs-6"></strong>
                    </div>
                </div>

                <h6 class="fw-bold mb-3"><i class="fas fa-list-ul"></i> Sản phẩm đặt mua:</h6>
                <div class="table-responsive">
                    <table class="table table-bordered table-striped table-sm text-center align-middle">
                        <thead class="table-secondary">
                        <tr>
                            <th class="text-start">Tên sản phẩm</th>
                            <th>Số lượng</th>
                            <th>Đơn giá</th>
                            <th class="text-end">Thành tiền</th>
                        </tr>
                        </thead>
                        <tbody id="modalItemsTable">
                        <tr><td colspan="4" class="text-muted py-3">Đang tải...</td></tr>
                        </tbody>
                    </table>
                </div>

                <div class="row mt-4">
                    <div class="col-md-5 offset-md-7">
                        <div class="d-flex justify-content-between mb-2">
                            <span class="text-muted">Tạm tính:</span>
                            <strong id="modalSubtotal"></strong>
                        </div>
                        <div class="d-flex justify-content-between mb-2 border-top pt-2">
                            <span class="fw-bold fs-5">Tổng cộng:</span>
                            <strong id="modalGrandTotal" class="fs-5 text-success"></strong>
                        </div>
                    </div>
                </div>
            </div>

            <div class="modal-footer d-flex justify-content-between bg-light">
                <form id="updateStatusForm" method="POST" class="d-flex align-items-center m-0">
                    <label class="me-2 fw-bold text-nowrap">Đổi trạng thái:</label>
                    <select name="status" id="modalStatusSelect" class="form-select form-select-sm me-2 fw-bold" style="width: 160px;">
                        <option value="PENDING">Chờ xác nhận</option>
                        <option value="CONFIRMED">Đã xác nhận</option>
                        <option value="DELIVERING">Đang giao</option>
                        <option value="COMPLETED">Hoàn thành</option>
                        <option value="CANCELLED">Đã hủy</option>
                    </select>
                    <button type="submit" class="btn btn-success btn-sm text-nowrap" onclick="return confirm('Cập nhật trạng thái đơn hàng này?')">
                        <i class="fas fa-save"></i> Cập nhật
                    </button>
                </form>

                <button type="button" class="btn btn-secondary btn-sm px-4" data-bs-dismiss="modal">Đóng</button>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    const ctx = '${pageContext.request.contextPath}';
    const fmt = new Intl.NumberFormat('vi-VN');

    // Format Ngày giờ
    document.querySelectorAll('td[data-date]').forEach(td => {
        const raw = td.getAttribute('data-date');
        if (!raw) return;
        try {
            const d = new Date(raw);
            const pad = n => String(n).padStart(2, '0');
            td.textContent = pad(d.getDate()) + '/' + pad(d.getMonth() + 1) + '/' + d.getFullYear() + ' ' + pad(d.getHours()) + ':' + pad(d.getMinutes());
        } catch (_) {}
    });

    // Mở Modal & Setup form cập nhật trạng thái
    function openOrderDetails(orderId, customer, paymentMethod, total, subtotal, status) {
        document.getElementById('modalOrderId').textContent       = orderId;
        document.getElementById('modalCustomer').textContent      = customer;
        document.getElementById('modalPaymentMethod').textContent = paymentMethod;
        document.getElementById('modalSubtotal').textContent      = fmt.format(subtotal) + 'đ';
        document.getElementById('modalGrandTotal').textContent    = fmt.format(total)    + 'đ';

        // Set action cho Form cập nhật trạng thái
        document.getElementById('updateStatusForm').action = ctx + '/admin/orders/' + orderId + '/update-status';

        // Chọn đúng trạng thái hiện tại trên thẻ Select (Xử lý cả cái APPROVED bị cũ)
        let selectBox = document.getElementById('modalStatusSelect');
        if(status === 'APPROVED') {
            // Nếu là đơn hàng cũ bị lưu chữ APPROVED, gán tạm nó thành CONFIRMED để Admin lưu lại
            selectBox.value = 'CONFIRMED';
        } else {
            selectBox.value = status;
        }

        // Load sản phẩm từ API
        document.getElementById('modalItemsTable').innerHTML = '<tr><td colspan="4" class="text-center text-muted py-3">Đang tải dữ liệu...</td></tr>';
        fetch(ctx + '/admin/orders/' + orderId + '/items')
            .then(res => res.json())
            .then(items => {
                const tbody = document.getElementById('modalItemsTable');
                if (!items || items.length === 0) {
                    tbody.innerHTML = '<tr><td colspan="4" class="text-center text-muted py-3">Không có sản phẩm</td></tr>';
                    return;
                }
                tbody.innerHTML = items.map(item => `
                    <tr>
                        <td class="text-start fw-semibold">\${item.productName}</td>
                        <td>\${item.quantity}</td>
                        <td>\${fmt.format(item.unitPrice)} đ</td>
                        <td class="text-end fw-bold">\${fmt.format(item.quantity * item.unitPrice)} đ</td>
                    </tr>
                `).join('');
            })
            .catch(() => {
                document.getElementById('modalItemsTable').innerHTML = '<tr><td colspan="4" class="text-danger text-center py-3">Không thể tải sản phẩm</td></tr>';
            });
    }

    // Tìm kiếm trực tiếp Client-side
    document.getElementById('searchInput').addEventListener('keyup', function () {
        const term = this.value.toLowerCase();
        document.querySelectorAll('#ordersTable tbody tr').forEach(row => {
            const idCell = row.cells[0]?.textContent.toLowerCase() ?? '';
            row.style.display = idCell.includes(term) ? '' : 'none';
        });
    });
</script>
</body>
</html>