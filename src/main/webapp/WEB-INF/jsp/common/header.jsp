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
                        <a href="${pageContext.request.contextPath}/profile">
                            <span>Xin chào ${sessionScope.currentUser.fullName}</span>
                            </a>
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

                    <div class="search-bar" id="headerSearchBox" style="position:relative;">
                        <input type="text" id="headerSearchInput" class="search-input"
                               placeholder="Bạn cần tìm kiếm gì?..." autocomplete="off" />
                        <button type="button" id="headerSearchBtn" class="search-button">
                            <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" fill="none"
                                viewBox="0 0 24 24" stroke="currentColor" stroke-width="2.5">
                                <path stroke-linecap="round" stroke-linejoin="round"
                                    d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
                            </svg>
                        </button>
                        <ul id="searchSuggestions" style="display:none;position:absolute;top:100%;left:0;right:0;margin:8px 0 0;padding:0;list-style:none;background:#fff;border:1px solid #e2e8f0;border-radius:12px;box-shadow:0 8px 20px rgba(0,0,0,0.1);z-index:999;max-height:360px;overflow-y:auto;"></ul>
                    </div>

                    <div class="cart-info">
                        <span class="cart-icon">
                            <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="none"
                                viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                                <path stroke-linecap="round" stroke-linejoin="round"
                                    d="M3 3h2l.4 2M7 13h10l4-8H5.4M7 13L5.4 5M7 13l-2.293 2.293c-.63.63-.184 1.707.707 1.707H17m0 0a2 2 0 100 4 2 2 0 000-4zm-8 2a2 2 0 11-4 0 2 2 0 014 0z" />
                            </svg>
                        </span>
                        <a href="${pageContext.request.contextPath}/cart">Giỏ hàng</a>
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

            <script id="searchProductsData" type="application/json">${searchProductsJson}</script>
            <script>
                (function () {
                    const CTX = '${pageContext.request.contextPath}';
                    const input = document.getElementById('headerSearchInput');
                    const box = document.getElementById('headerSearchBox');
                    const list = document.getElementById('searchSuggestions');
                    if (!input || !list) return;

                    let allProducts = [];
                    try {
                        const dataEl = document.getElementById('searchProductsData');
                        allProducts = JSON.parse(dataEl ? dataEl.textContent : '[]') || [];
                    } catch (e) {
                        allProducts = [];
                    }

                    let debounceTimer = null;

                    function formatPrice(value) {
                        return Number(value).toLocaleString('vi-VN') + 'đ';
                    }

                    function hideSuggestions() {
                        list.style.display = 'none';
                        list.innerHTML = '';
                    }

                    function renderSuggestions(items) {
                        list.innerHTML = '';
                        if (!items.length) {
                            list.innerHTML = '<li style="padding:12px 16px;color:#64748b;">Không tìm thấy sản phẩm</li>';
                            list.style.display = 'block';
                            return;
                        }
                        items.forEach(function (item) {
                            const li = document.createElement('li');
                            li.style.cssText = 'display:flex;justify-content:space-between;gap:12px;padding:10px 16px;cursor:pointer;';
                            li.onmouseenter = function () { li.style.background = '#f8fafc'; };
                            li.onmouseleave = function () { li.style.background = ''; };
                            li.innerHTML =
                                '<span>' + item.productName + '</span>' +
                                '<span style="color:#00a88f;font-weight:600;">' + formatPrice(item.basePrice) + '</span>';
                            li.addEventListener('mousedown', function (e) {
                                e.preventDefault();
                                window.location.href = CTX + '/products/' + item.productId;
                            });
                            list.appendChild(li);
                        });
                        list.style.display = 'block';
                    }

                    function filterSuggestions(term) {
                        const q = term.trim().toLowerCase();
                        if (!q) {
                            hideSuggestions();
                            return;
                        }
                        const matches = allProducts.filter(function (item) {
                            return item.productName && item.productName.toLowerCase().includes(q);
                        });
                        renderSuggestions(matches);
                    }

                    input.addEventListener('input', function () {
                        clearTimeout(debounceTimer);
                        debounceTimer = setTimeout(function () {
                            filterSuggestions(input.value);
                        }, 150);
                    });

                    input.addEventListener('keydown', function (e) {
                        if (e.key === 'Escape') hideSuggestions();
                    });

                    document.addEventListener('click', function (e) {
                        if (!box.contains(e.target)) hideSuggestions();
                    });
                })();
            </script>