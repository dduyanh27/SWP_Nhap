<%--
  Created by IntelliJ IDEA.
  User: ADMIN
  Date: 6/16/2026
  Time: 11:14 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>VMFRUIT - Quản Lý Tồn Kho &amp; Theo Dõi Lô Hàng</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/inventory-style.css">
</head>
<body class="inv-body-wrapper">

    <header class="inv-top-navbar text-white px-4 d-flex align-items-center justify-content-between">
        <div class="d-flex align-items-center">
            <span class="inv-brand-text">VMFRUIT STAFF PORTAL</span>
            <div class="vr bg-secondary mx-3" style="height: 22px;"></div>
            <span class="text-white-50" style="font-size: 13px; font-weight: 500;">Phân hệ tác vụ: Quản lý Kho Hoa Quả</span>
        </div>
        <div class="d-flex align-items-center">
            <div class="rounded-circle bg-dark d-flex align-items-center justify-content-center me-2 border border-secondary" style="width: 30px; height: 30px; font-size: 12px; font-weight: 700;">K</div>
            <span class="me-3 text-white-50" style="font-size: 13px;">Nhân viên: <strong class="text-white">Nguyễn Văn A</strong> (Inventory Staff)</span>
            <form action="${pageContext.request.contextPath}/logout" method="post" class="m-0">
                <button type="submit" class="btn btn-danger btn-sm fw-bold" style="font-size: 11px; padding: 4px 12px;">Đăng xuất</button>
            </form>
        </div>
    </header>

    <div class="d-flex">
        <%@ include file="../fragments/inventory-sidebar.jsp" %>

        <main class="flex-grow-1 p-4" style="max-width: calc(100% - 260px);">

            <div class="d-flex justify-content-between align-items-center mb-4">
                <h3 class="fw-bold text-dark m-0" style="font-size: 23px;">Quản Lý Tồn Kho Hoa Quả</h3>
                <span class="badge bg-secondary px-3 py-2" style="font-size: 12px;">Năm vận hành: 2026</span>
            </div>

            <div class="row g-3 mb-4">
                <div class="col-12 col-md-4">
                    <div class="inv-kpi-card inv-kpi-card-safe p-3 d-flex justify-content-between align-items-end">
                        <div>
                            <span class="text-muted d-block small fw-semibold mb-1">Tổng Số Lô Hoạt Động</span>
                            <span class="fs-2 fill-dark fw-bold text-dark lh-1">
                                <c:out value="${not empty totalActiveBatches ? totalActiveBatches : '42'}" />
                            </span>
                        </div>
                        <span class="text-success fw-bold small" style="font-size: 12px;">📊 Ổn định</span>
                    </div>
                </div>
                <div class="col-12 col-md-4">
                    <div class="inv-kpi-card inv-kpi-card-warning p-3 d-flex justify-content-between align-items-end">
                        <div>
                            <span class="text-muted d-block small fw-semibold mb-1">Lô Hàng Sắp Hết Hạn</span>
                            <span class="fs-2 fw-bold lh-1" style="color: #b45309;">
                                <c:out value="${not empty nearExpiryCount ? nearExpiryCount : '05'}" />
                            </span>
                        </div>
                        <span style="color: #b45309; font-size: 12px;" class="fw-bold small">⚠️ Cần xuất FEFO</span>
                    </div>
                </div>
                <div class="col-12 col-md-4">
                    <div class="inv-kpi-card inv-kpi-card-danger p-3 d-flex justify-content-between align-items-end">
                        <div>
                            <span class="text-muted d-block small fw-semibold mb-1">Lô Cần Thanh Lý Khẩn Cấp</span>
                            <span class="fs-2 fw-bold text-danger lh-1">
                                <c:out value="${not empty urgentClearanceCount ? urgentClearanceCount : '02'}" />
                            </span>
                        </div>
                        <span class="text-danger fw-bold small" style="font-size: 12px;">🚨 Xử lý ngay</span>
                    </div>
                </div>
            </div>

            <div class="bg-white p-2 rounded border mb-4 shadow-sm d-flex align-items-center justify-content-between">
                <form class="d-flex flex-grow-1 me-3" method="get" action="${pageContext.request.contextPath}/inventory/batches">
                    <div class="input-group" style="width: 420px;">
                        <span class="input-group-text bg-transparent border-end-0 text-muted">🔍</span>
                        <input type="text" class="form-control border-start-0 ps-1" name="inventoryKeyword" value="<c:out value='${param.inventoryKeyword}'/>" placeholder="Tìm kiếm mã lô hàng hoặc tên trái cây cụ thể..." style="font-size: 13px;">
                    </div>
                </form>
                <a href="${pageContext.request.contextPath}/inventory/batches/add" class="btn btn-success fw-bold px-3 d-flex align-items-center" style="font-size: 12px; height: 36px; background-color: #16a34a; border: none;">
                    + Nhập Lô Hàng Mới
                </a>
            </div>

            <div class="inv-data-table-wrapper">
                <table class="table table-hover align-middle mb-0" style="font-size: 13px;">
                    <thead class="inv-table-header">
                        <tr>
                            <th class="ps-3 py-3">Mã Lô</th>
                            <th>Tên Trái Cây</th>
                            <th>Số Lượng Tồn</th>
                            <th>Ngày Nhập Kho</th>
                            <th>Hạn Sử Dụng</th>
                            <th>Nhà Cung Cấp</th>
                            <th class="pe-3 text-center">Trạng Thái Cảnh Báo</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <%-- Trường hợp 1: Có dữ liệu được truyền từ Controller --%>
                            <c:when class="bold" test="${not empty inventoryBatchesList}">
                                <c:forEach var="batch" items="${inventoryBatchesList}">
                                    <tr class="${batch.alertStatus == 'DANGER' ? 'inv-row-danger-highlight' : ''}">
                                        <td class="ps-3 fw-bold text-primary"><c:out value="${batch.batchId}"/></td>
                                        <td class="fw-bold text-dark"><c:out value="${batch.fruitName}"/></td>
                                        <td><c:out value="${batch.currentWeight}"/> kg</td>
                                        <td class="text-muted"><c:out value="${batch.formattedImportDate}"/></td>
                                        <td class="${batch.alertStatus == 'DANGER' ? 'fw-bold text-danger' : ''}"><c:out value="${batch.formattedExpiryDate}"/></td>
                                        <td class="text-muted"><c:out value="${batch.supplierName}"/></td>
                                        <td class="pe-3 text-center">
                                            <c:choose>
                                                <c:when test="${batch.alertStatus == 'DANGER'}">
                                                    <span class="inv-status-badge inv-badge-danger">XUẤT GẤP</span>
                                                </c:when>
                                                <c:when test="${batch.alertStatus == 'WARNING'}">
                                                    <span class="inv-status-badge inv-badge-warning">CẬN HẠN</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="inv-status-badge inv-badge-safe">AN TOÀN</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>

                            <%-- Trường hợp 2: Nếu chưa có dữ liệu từ DB, hiển thị Mockup tĩnh chuẩn năm 2026 --%>
                            <c:otherwise>
                                <tr class="inv-row-danger-highlight">
                                    <td class="ps-3 fw-bold text-danger">B-190345</td>
                                    <td class="fw-bold text-dark">Dưa Lưới Viết Minh</td>
                                    <td>120 kg</td>
                                    <td class="text-muted">10/06/2026</td>
                                    <td class="fw-bold text-danger">19/06/2026</td>
                                    <td class="text-muted">Supplier-D01</td>
                                    <td class="pe-3 text-center">
                                        <span class="inv-status-badge inv-badge-danger">XUẤT GẤP</span>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="ps-3 text-dark fw-semibold">B-190234</td>
                                    <td class="text-dark">Xoài Cát Chu</td>
                                    <td>45 kg</td>
                                    <td class="text-muted">28/05/2026</td>
                                    <td class="text-dark">25/06/2026</td>
                                    <td class="text-muted">SUP-MT02</td>
                                    <td class="text-center pe-3">
                                        <span class="inv-status-badge inv-badge-warning">CẬN HẠN</span>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="ps-3 text-dark fw-semibold">B-189912</td>
                                    <td class="text-dark">Cam Sành Loại 1</td>
                                    <td>310 kg</td>
                                    <td class="text-muted">14/06/2026</td>
                                    <td class="text-dark">15/07/2026</td>
                                    <td class="text-muted">SUP-NK05</td>
                                    <td class="text-center pe-3">
                                        <span class="inv-status-badge inv-badge-safe">AN TOÀN</span>
                                    </td>
                                </tr>
                                <%-- Cảnh báo số lượng hàng hóa chạm ngưỡng tối thiểu an toàn (BR-45) --%>
                                <tr class="inv-row-danger-highlight">
                                    <td class="ps-3 text-dark fw-semibold">B-189750</td>
                                    <td class="text-dark">Táo Envy Size 24</td>
                                    <td class="text-danger fw-bold">8 kg ⚠️</td>
                                    <td class="text-muted">12/06/2026</td>
                                    <td class="text-dark">02/07/2026</td>
                                    <td class="text-muted">SUP-D01</td>
                                    <td class="text-center pe-3">
                                        <span class="inv-status-badge inv-badge-danger">SẮP CẠN</span>
                                    </td>
                                </tr>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>

            <div class="d-flex justify-content-between align-items-center mt-3 text-muted" style="font-size: 12px;">
                <span>Hiển thị dữ liệu kiểm tra từ 1 đến 4 trong tổng số 42 lô hàng hoa quả lưu kho.</span>
            </div>

        </main>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Lắng nghe thay đổi trạng thái checkbox lọc của kho
        document.querySelectorAll('#inventorySidebarFilterForm input[type="checkbox"]').forEach(element => {
            element.addEventListener('change', () => {
                document.getElementById('inventorySidebarFilterForm').submit();
            });
        });
    </script>
</body>
</html>