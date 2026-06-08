<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${param.title != null ? param.title : 'Dashboard'} - VMFruit Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">
</head>
<body class="admin-body">
<div class="admin-wrapper">

    <!-- SIDEBAR: include admin-sidebar.jsp with activeMenu param -->
    <jsp:include page="/WEB-INF/jsp/common/admin-sidebar.jsp">
        <jsp:param name="activeMenu" value="${activeMenu}" />
    </jsp:include>

    <!-- MAIN CONTENT -->
    <main class="admin-main">
        <!-- HEADER: 64px white bar with Admin name + circular avatar on right -->
        <header class="admin-header">
            <div class="admin-header-user">
                <span>Admin</span>
                <div class="admin-header-avatar">A</div>
            </div>
        </header>

        <!-- PAGE CONTENT: included via contentPage model attribute -->
        <jsp:include page="/WEB-INF/jsp/${contentPage}.jsp" />
    </main>

</div>
</body>
</html>
