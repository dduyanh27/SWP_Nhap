<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>${param.title != null ? param.title : "VMFruit - Hệ thống cửa hàng Trái Cây Sạch"}</title>
            <!-- Main CSS -->
            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
        </head>

        <body>

            <!-- TOP BAR -->
            <div class="top-bar">
                <div class="top-bar-links">
                    <c:choose>
                        <c:when test="${not empty sessionScope.currentUser}">
                            <span>Xin chào, ${sessionScope.currentUser.fullName}</span>
                            <c:if test="${sessionScope.isAdmin}">
                                <span>|</span>
                                <a href="${pageContext.request.contextPath}/admin/dashboard">Admin</a>
                            </c:if>
                            <span>|</span>
                            <a href="${pageContext.request.contextPath}/logout">Đăng xuất</a>
                            <span>|</span>
                            <a href="${pageContext.request.contextPath}/contact">Liên hệ</a>
                        </c:when>
                        <c:otherwise>
                            <a href="${pageContext.request.contextPath}/login">Đăng nhập</a>
                            <span>|</span>
                            <a href="${pageContext.request.contextPath}/register">Đăng ký</a>
                            <span>|</span>
                            <a href="${pageContext.request.contextPath}/contact">Liên hệ</a>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <!-- HEADER CONTAINER -->
            <header class="header-container">
                <!-- MIDDLE HEADER -->
                <div class="header-middle">
                    <div class="logo">
                        <a href="${pageContext.request.contextPath}/">
                            <img src="${pageContext.request.contextPath}/asset/logo/rectangular_logo.jpg"
                                alt="VMFRUIT Logo" class="header-logo" style=" height: 70px; width: auto" />
                        </a>
                    </div>

                    <div class="search-bar">
                        <input type="text" class="search-input" placeholder="Bạn cần tìm kiếm gì?..." />
                        <button type="button" class="search-button">
                            <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" fill="none"
                                viewBox="0 0 24 24" stroke="currentColor" stroke-width="2.5">
                                <path stroke-linecap="round" stroke-linejoin="round"
                                    d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
                            </svg>
                        </button>
                    </div>

                    <div class="cart-info">
                        <span class="cart-icon">
                            <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="none"
                                viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                                <path stroke-linecap="round" stroke-linejoin="round"
                                    d="M3 3h2l.4 2M7 13h10l4-8H5.4M7 13L5.4 5M7 13l-2.293 2.293c-.63.63-.184 1.707.707 1.707H17m0 0a2 2 0 100 4 2 2 0 000-4zm-8 2a2 2 0 11-4 0 2 2 0 014 0z" />
                            </svg>
                        </span>
                        <span>Giỏ hàng (0)</span>
                    </div>
                </div>

                <!-- NAVIGATION MENU -->
                <nav class="nav-menu">
                    <a href="${pageContext.request.contextPath}/"
                        class="nav-link ${param.activePage == 'home' ? 'active' : ''}">Trang chủ</a>
                    <a href="${pageContext.request.contextPath}/gifts"
                        class="nav-link ${param.activePage == 'gifts' ? 'active' : ''}">Quà tặng trái cây</a>
                    <a href="${pageContext.request.contextPath}/new-products"
                        class="nav-link ${param.activePage == 'new-products' ? 'active' : ''}">Sản phẩm mới</a>
                    <a href="${pageContext.request.contextPath}/products"
                        class="nav-link ${param.activePage == 'product' ? 'active' : ''}">Danh mục trái cây</a>
                    <a href="${pageContext.request.contextPath}/promotions"
                        class="nav-link ${param.activePage == 'promotions' ? 'active' : ''}">Khuyến mãi</a>
                </nav>
            </header>