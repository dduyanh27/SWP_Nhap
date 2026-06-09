<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Import Receipt — VMFruit Admin</title>
    <meta name="description" content="Manage import receipts in VMFruit admin panel.">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">
</head>

<body class="admin-body">

<div class="admin-wrapper">

    <jsp:include page="/WEB-INF/jsp/common/admin-sidebar.jsp">
        <jsp:param name="activeMenu" value="import-receipt-manage"/>
    </jsp:include>

    <main class="admin-main">

        <h1 class="admin-page-title">Import Receipt</h1>

        <div class="stat-cards-grid">
            <div class="stat-card">
                <div class="stat-card-label">Total</div>
                <div class="stat-card-value">12</div>
            </div>
            <div class="stat-card">
                <div class="stat-card-label">Pending Receipt</div>
                <div class="stat-card-value stat-value-warning">04</div>
            </div>
            <div class="stat-card">
                <div class="stat-card-label">Fully Received</div>
                <div class="stat-card-value stat-value-success">08</div>
            </div>
            <div class="stat-card">
                <div class="stat-card-label">Total Quantity</div>
                <div class="stat-card-value stat-value-info">600</div>
            </div>
        </div>

        <div class="admin-toolbar">
            <div class="toolbar-left">
                <select id="supplierFilter" name="supplier" class="admin-select">
                    <option value="">Filter by Supplier</option>
                    <option value="mien-tay">Nhà cung cấp Miền Tây</option>
                    <option value="lam-dong">Hợp tác xã Lâm Đồng</option>
                    <option value="tay-nguyen">Vườn Quả Tây Nguyên</option>
                </select>

                <select id="dateFilter" name="sortDate" class="admin-select">
                    <option value="recent" selected>Order Date: Recent</option>
                    <option value="oldest">Order Date: Oldest</option>
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
                        <th>Unit Cost</th>
                        <th>Total Expected Quantity</th>
                        <th>Status</th>
                        <th style="text-align:right;">Action</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td class="import-id">PO001</td>
                        <td>Nhà cung cấp Miền Tây</td>
                        <td>01/06/2026</td>
                        <td>40.000đ</td>
                        <td>100</td>
                        <td><span class="status-badge received">Received</span></td>
                        <td style="text-align:right;">
                            <a href="#" class="action-link edit">View</a>
                        </td>
                    </tr>
                    <tr>
                        <td class="import-id">PO002</td>
                        <td>Hợp tác xã Lâm Đồng</td>
                        <td>02/06/2026</td>
                        <td>40.000đ</td>
                        <td>200</td>
                        <td><span class="status-badge received">Received</span></td>
                        <td style="text-align:right;">
                            <a href="#" class="action-link edit">View</a>
                        </td>
                    </tr>
                    <tr>
                        <td class="import-id">PO003</td>
                        <td>Vườn Quả Tây Nguyên</td>
                        <td>03/06/2026</td>
                        <td>40.000đ</td>
                        <td>300</td>
                        <td><span class="status-badge pending">Pending</span></td>
                        <td style="text-align:right;">
                            <div class="action-links" style="justify-content:flex-end;">
                                <a href="#" class="action-link edit">Edit</a>
                                <span class="action-sep">|</span>
                                <a href="#" class="action-link cancel">Cancel</a>
                            </div>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>

    </main>
</div>

</body>
</html>
