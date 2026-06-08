<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${param.title} - VMFruit Admin</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">

    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

    <style>
        .sidebar {
            background-color: #1a1a2e;
            min-height: 100vh;
        }
        .nav-link {
            color: #ccc !important;
            padding: 12px 20px;
        }
        .nav-link:hover, .nav-link.active {
            background-color: #16213e;
            color: white !important;
        }
        .card {
            border: none;
            box-shadow: 0 2px 10px rgba(0,0,0,0.08);
        }
    </style>
</head>
<body class="bg-light">
<div class="d-flex">
    <!-- SIDEBAR -->
    <div class="sidebar text-white" style="width: 260px;">
        <div class="p-4">
            <h4 class="text-center mb-5">
                <i class="bi bi-apple"></i> VMFruit Admin
            </h4>

            <ul class="nav flex-column">
                <li class="nav-item mb-1">
                    <a href="${pageContext.request.contextPath}/admin/dashboard"
                       class="nav-link ${param.active == 'dashboard' ? 'active' : ''}">
                        <i class="bi bi-speedometer2 me-2"></i> Dashboard
                    </a>
                </li>
                <li class="nav-item mb-1"><a href="#" class="nav-link"><i class="bi bi-people me-2"></i> User Manage</a></li>
                <li class="nav-item mb-1"><a href="#" class="nav-link"><i class="bi bi-box-seam me-2"></i> Product Manage</a></li>
                <li class="nav-item mb-1"><a href="#" class="nav-link"><i class="bi bi-cart me-2"></i> Order Manage</a></li>
                <li class="nav-item mb-1"><a href="#" class="nav-link"><i class="bi bi-star me-2"></i> Review Manage</a></li>
                <li class="nav-item mb-1"><a href="#" class="nav-link"><i class="bi bi-tag me-2"></i> Discount Code</a></li>
                <li class="nav-item mb-1"><a href="#" class="nav-link"><i class="bi bi-credit-card me-2"></i> Payment Manage</a></li>
                <li class="nav-item"><a href="#" class="nav-link"><i class="bi bi-bar-chart me-2"></i> Report Manage</a></li>
            </ul>
        </div>

        <div class="mt-auto p-4">
            <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline-light w-100">
                <i class="bi bi-box-arrow-right"></i> Logout
            </a>
        </div>
    </div>

    <!-- MAIN CONTENT -->
    <div class="flex-grow-1">
        <nav class="navbar navbar-light bg-white border-bottom px-4 py-3">
            <h5 class="mb-0 fw-bold">Admin Dashboard</h5>
            <div class="d-flex align-items-center gap-3">
                <span>Xin chào, <strong>Admin</strong></span>
            </div>
        </nav>

        <div class="p-4">
            <!-- Nội dung của từng trang sẽ được include vào đây -->
            <jsp:include page="${param.contentPage}" />
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>