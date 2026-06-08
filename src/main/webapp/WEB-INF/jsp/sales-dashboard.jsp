<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sales Dashboard — VMFruit Staff</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">
</head>
<body class="admin-body">

<div class="admin-wrapper">

    <!-- SIDEBAR FOR SALES STAFF -->
    <aside class="admin-sidebar">
        <div class="sidebar-brand">
            <h2>VMFruit Sales</h2>
        </div>
        <nav class="sidebar-nav">
            <a href="${pageContext.request.contextPath}/sales/dashboard" class="sidebar-nav-item active">
                Sales Dashboard
            </a>
            <a href="${pageContext.request.contextPath}/admin/products" class="sidebar-nav-item">
                Fruit Manage
            </a>
            <a href="${pageContext.request.contextPath}/admin/orders" class="sidebar-nav-item">
                Order Manage
            </a>
            <a href="${pageContext.request.contextPath}/admin/reviews" class="sidebar-nav-item">
                Review Manage
            </a>
            <a href="${pageContext.request.contextPath}/admin/discounts" class="sidebar-nav-item">
                Discount Code
            </a>
        </nav>
        <div class="sidebar-footer">
            <a href="${pageContext.request.contextPath}/logout" class="sidebar-nav-item">
                Logout
            </a>
        </div>
    </aside>

    <!-- MAIN CONTENT -->
    <main class="admin-main">
        <h1 class="admin-page-title">Sales Staff Dashboard</h1>

        <div style="background: #ffffff; padding: 40px; border-radius: 12px; border: 1px solid #e8ecf0; text-align: center; box-shadow: 0 4px 16px rgba(0,0,0,0.02);">
            <div style="font-size: 3rem; margin-bottom: 20px;">🛒</div>
            <h2 style="font-size: 1.5rem; color: #0f172a; margin-bottom: 10px; font-weight: 600;">Khu Vực Làm Việc Của Nhân Viên Bán Hàng</h2>
            <p style="color: #64748b; font-size: 0.95rem; max-width: 500px; margin: 0 auto 24px; line-height: 1.6;">
                Chào mừng Nhân viên bán hàng! Bạn có thể quản lý sản phẩm, đơn hàng, mã giảm giá và theo dõi phản hồi của khách hàng.
            </p>
            <div style="display: flex; gap: 12px; justify-content: center;">
                <a href="${pageContext.request.contextPath}/admin/products" style="background-color: #10b981; color: #ffffff; padding: 12px 24px; border-radius: 8px; font-weight: 600; font-size: 0.875rem; transition: background-color 0.2s;" onmouseover="this.style.backgroundColor='#059669'" onmouseout="this.style.backgroundColor='#10b981'">Quản lý sản phẩm</a>
                <a href="${pageContext.request.contextPath}/admin/orders" style="background-color: #3b82f6; color: #ffffff; padding: 12px 24px; border-radius: 8px; font-weight: 600; font-size: 0.875rem; transition: background-color 0.2s;" onmouseover="this.style.backgroundColor='#2563eb'" onmouseout="this.style.backgroundColor='#3b82f6'">Quản lý đơn hàng</a>
            </div>
        </div>
    </main>
</div>

</body>
</html>
