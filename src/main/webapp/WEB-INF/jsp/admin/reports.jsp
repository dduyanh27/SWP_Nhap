<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tạo Phiếu Nhập Kho – VMFruit Admin</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">
</head>
<body class="admin-body">

<div class="admin-wrapper">

    <jsp:include page="/WEB-INF/jsp/common/admin-sidebar.jsp">
        <jsp:param name="activeMenu" value="import-receipts" />
    </jsp:include>

    <div class="admin-main">
        <div class="container-fluid py-2 px-0">

            <h2 class="admin-page-title mb-4">Tạo Phiếu Nhập Kho</h2>

            <div class="card shadow-sm border-0 rounded-3">
                <div class="card-body p-4">

                    <h6 class="fw-bold text-dark mb-3">1. Thông tin chung</h6>

                    <div class="row g-3 mb-4">
                        <div class="col-md-6">
                            <label class="form-label text-muted small fw-semibold">Chọn Nhà Cung Cấp *</label>
                            <input type="text" id="supplierInput" list="supplierList" class="admin-input form-control-custom" placeholder="Gõ nhập tên nhà cung cấp..." />
                            <datalist id="supplierList">
                                <c:forEach var="supplier" items="${suppliers}">
                                    <option value="${supplier.supplierName}" data-id="${supplier.supplierId}"></option>
                                </c:forEach>
                            </datalist>
                        </div>

                        <div class="col-md-6">
                            <label class="form-label text-muted small fw-semibold">Ngày Giao Hàng Dự Kiến *</label>
                            <input type="date" id="deliveryDate" class="admin-input form-control-custom"
                                   value="${defaultDate}" />
                        </div>
                    </div>

                    <h6 class="fw-bold text-dark mb-3">2. Thêm Trái Cây Vào Danh Sách Nhập</h6>

                    <div class="row g-2 align-items-center mb-3">
                        <div class="col-md-5">
                            <input type="text" id="productInput" list="productList" class="admin-input form-control-custom" placeholder="Gõ nhập tên loại trái cây..." />
                            <datalist id="productList">
                                <c:forEach var="product" items="${products}">
                                    <option value="${product.productName}" data-id="${product.productId}" data-unit="${product.unit}"></option>
                                </c:forEach>
                            </datalist>
                        </div>
                        <div class="col-md-3">
                            <input type="number" id="expectedQty" class="admin-input form-control-custom"
                                   placeholder="Số lượng nhập" min="0" step="0.01" />
                        </div>
                        <div class="col-md-2">
                            <input type="number" id="unitCost" class="admin-input form-control-custom"
                                   placeholder="Giá nhập dự kiến (đ)" min="0" step="1" />
                        </div>
                        <div class="col-md-2">
                            <button type="button" class="btn btn-add-item w-100" onclick="addItem()">
                                + Thêm Mục
                            </button>
                        </div>
                    </div>

                    <div class="table-responsive mb-3 border rounded">
                        <table class="table table-borderless table-hover mb-0" id="receiptTable">
                            <thead class="bg-light border-bottom">
                            <tr>
                                <th class="text-muted small fw-bold">Tên Sản Phẩm</th>
                                <th class="text-muted small fw-bold">Số Lượng Dự Kiến</th>
                                <th class="text-muted small fw-bold">Giá Nhập Dự Kiến</th>
                                <th class="text-muted small fw-bold">Thành Tiền Dự Kiến</th>
                                <th class="text-muted small fw-bold">Hành Động</th>
                            </tr>
                            </thead>
                            <tbody id="receiptTableBody">
                            <tr id="emptyRow">
                                <td colspan="5" class="text-center text-muted py-4">
                                    Chưa có sản phẩm nào được thêm vào danh sách.
                                </td>
                            </tr>
                            </tbody>
                        </table>
                    </div>

                    <div class="d-flex justify-content-between align-items-center bg-light p-3 rounded border">
                        <span class="fw-bold text-dark">Tổng Giá Trị Đầu Tư Dự Kiến:</span>
                        <span class="total-value-green" id="totalValue">0đ</span>
                    </div>

                </div></div><div class="d-flex justify-content-between mt-4">
            <a href="${pageContext.request.contextPath}/admin/reports/list"
               class="btn btn-outline-secondary px-4 fw-bold">Hủy Bỏ</a>
            <button type="button" class="btn btn-create-success px-5" onclick="submitReceipt()">
                Tạo Phiếu Nhập →
            </button>
        </div>

        </div></div></div><script>
    const items = [];
    const CONTEXT = '${pageContext.request.contextPath}';

    function fmt(num) {
        return num.toLocaleString('vi-VN') + 'đ';
    }

    function renderTable() {
        const tbody = document.getElementById('receiptTableBody');

        if (items.length === 0) {
            tbody.innerHTML = '<tr id="emptyRow"><td colspan="5" class="text-center text-muted py-4">Chưa có sản phẩm nào được thêm vào danh sách.</td></tr>';
            document.getElementById('totalValue').textContent = '0đ';
            return;
        }

        let total = 0;
        let html  = '';
        for (let idx = 0; idx < items.length; idx++) {
            const item = items[idx];
            const sub = item.qty * item.unitCost;
            total += sub;

            html += '<tr class="border-bottom">' +
                '<td class="align-middle text-dark fw-semibold">' + item.productName + '</td>' +
                '<td class="align-middle text-muted">' + item.qty + ' ' + item.unit + '</td>' +
                '<td class="align-middle text-muted">' + fmt(item.unitCost) + '</td>' +
                '<td class="align-middle fw-bold text-dark">' + fmt(sub) + '</td>' +
                '<td class="align-middle">' +
                '<a href="#" class="text-danger fw-bold text-decoration-none" onclick="removeItem(' + idx + '); return false;">Xóa</a>' +
                '</td>' +
                '</tr>';
        }
        tbody.innerHTML = html;
        document.getElementById('totalValue').textContent = fmt(total);
    }

    function addItem() {
        const productNameInput = document.getElementById('productInput').value.trim();
        const qtyEl = document.getElementById('expectedQty');
        const costEl = document.getElementById('unitCost');

        const qty = parseFloat(qtyEl.value);
        const unitCost = parseFloat(costEl.value);

        if (!productNameInput) {
            alert('Vui lòng gõ nhập tên loại trái cây!');
            return;
        }
        if (isNaN(qty) || qty <= 0 || isNaN(unitCost) || unitCost < 0) {
            alert('Vui lòng nhập Số lượng > 0 và Giá nhập lớn hơn hoặc bằng 0.');
            return;
        }
        let productId = null;
        let unit = 'kg';
        const productList = document.getElementById('productList');
        if (productList) {
            for (let i = 0; i < productList.options.length; i++) {
                if (productList.options[i].value.trim().normalize().toLowerCase() === productNameInput.normalize().toLowerCase()) {
                    productId = productList.options[i].getAttribute('data-id');
                    unit = productList.options[i].getAttribute('data-unit') || 'kg';
                    break;
                }
            }
        }

        const isExist = items.some(function(i) {
            return i.productName.toLowerCase() === productNameInput.toLowerCase();
        });
        if (isExist) {
            alert('Sản phẩm này đã được thêm vào danh sách bên dưới rồi!');
            return;
        }
        items.push({
            productId: productId ? parseInt(productId) : null,
            productName: productNameInput,
            unit: unit,
            qty: qty,
            unitCost: unitCost
        });

        renderTable();

        document.getElementById('productInput').value = '';
        qtyEl.value = '';
        costEl.value = '';
    }

    async function submitReceipt() {
        const supplierNameInput = document.getElementById('supplierInput').value;
        const supplierOption = document.querySelector('#supplierList option[value="' + supplierNameInput + '"]');
        const supplierId = supplierOption ? supplierOption.getAttribute('data-id') : null;
        const deliveryDate = document.getElementById('deliveryDate').value;

        if (!supplierId || !deliveryDate || items.length === 0) {
            alert('Vui lòng điền đủ thông tin nhà cung cấp, ngày giao hàng và chọn ít nhất 1 sản phẩm.');
            return;
        }

        const payload = {
            supplierId:           parseInt(supplierId),
            expectedDeliveryDate: deliveryDate,
            note:                 '',
            details: items.map(function(i) {
                return {
                    productId:        i.productId,
                    productName:      i.productName,
                    expectedQuantity: i.qty,
                    importPrice:      i.unitCost,
                    expectedExpiryDate: deliveryDate,
                    note: ''
                };
            })
        };

        try {
            const res = await fetch(CONTEXT + '/api/admin/reports?createdByUserId=${sessionScope.userId != null ? sessionScope.userId : 1}', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(payload)
            });

            if (res.ok || res.status === 201) {
                alert('Tạo phiếu nhập kho thành công!');
                window.location.href = CONTEXT + '/admin/reports';
            } else {
                const err = await res.json();
                alert(err.error || 'Đã xảy ra lỗi hệ thống.');
            }
        } catch (e) {
            alert('Không thể kết nối đến máy chủ backend.');
        }
    }
</script>
</body>
</html>