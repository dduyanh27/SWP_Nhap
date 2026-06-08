<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard — VMFruit Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">
</head>
<body class="admin-body">

<div class="admin-wrapper">

    <%-- Include common admin sidebar, mark 'dashboard' as active --%>
    <jsp:include page="/WEB-INF/jsp/common/admin-sidebar.jsp">
        <jsp:param name="activeMenu" value="dashboard"/>
    </jsp:include>

    <!-- MAIN CONTENT -->
    <main class="admin-main">
        <h1 class="admin-page-title">Admin Dashboard</h1>

        <div style="background: #ffffff; padding: 40px; border-radius: 12px; border: 1px solid #e8ecf0; text-align: center; box-shadow: 0 4px 16px rgba(0,0,0,0.02);">
            <div style="font-size: 3rem; margin-bottom: 20px;">📊</div>
            <h2 style="font-size: 1.5rem; color: #0f172a; margin-bottom: 10px; font-weight: 600;">Hệ Thống Báo Cáo & Quản Trị VMFruit</h2>
            <p style="color: #64748b; font-size: 0.95rem; max-width: 500px; margin: 0 auto 24px; line-height: 1.6;">
                Chào mừng Admin quay trở lại! Bạn có quyền quản trị toàn bộ hệ thống bán hàng, người dùng, sản phẩm và theo dõi doanh thu.
            </p>
            <div style="display: flex; gap: 12px; justify-content: center;">
                <a href="${pageContext.request.contextPath}/admin/products" style="background-color: #3b82f6; color: #ffffff; padding: 12px 24px; border-radius: 8px; font-weight: 600; font-size: 0.875rem; transition: background-color 0.2s;" onmouseover="this.style.backgroundColor='#2563eb'" onmouseout="this.style.backgroundColor='#3b82f6'">Quản lý sản phẩm</a>
                <a href="${pageContext.request.contextPath}/" style="background-color: #f1f5f9; color: #334155; padding: 12px 24px; border-radius: 8px; font-weight: 600; font-size: 0.875rem; transition: background-color 0.2s;" onmouseover="this.style.backgroundColor='#e2e8f0'" onmouseout="this.style.backgroundColor='#f1f5f9'">Quay lại Cửa hàng</a>
            </div>
        </div>
    </main>
</div>

</body>
</html>
