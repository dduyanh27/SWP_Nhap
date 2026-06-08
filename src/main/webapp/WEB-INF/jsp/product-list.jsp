<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <title>Danh sách sản phẩm - VMFruit</title>
                <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/css/product-list.css">
            </head>

            <body>

                <%@ include file="/WEB-INF/jsp/common/header.jsp" %>

                    <div class="product-page">
                        <div class="breadcrumb">
                            <a href="${pageContext.request.contextPath}/">Trang chủ</a>
                            <span> &rsaquo; </span>
                            <span>Sản phẩm</span>
                        </div>

                        <div class="product-layout">
                            <aside class="sidebar">
                                <form method="get" action="${pageContext.request.contextPath}/products" id="filterForm">

                                    <input type="hidden" name="categoryId" id="categoryIdInput"
                                        value="${selectedCategory}">
                                    <input type="hidden" name="sortBy" id="sortByInput" value="${sortBy}">
                                    <input type="hidden" name="sortDir" id="sortDirInput" value="${sortDir}">
                                    <input type="hidden" name="minPrice" id="minPriceInput" value="${minPrice}">
                                    <input type="hidden" name="maxPrice" id="maxPriceInput" value="${maxPrice}">
                                    <input type="hidden" name="page" id="pageInput" value="0">

                                    <div class="sidebar-section">
                                        <h3>DANH MỤC</h3>
                                        <label class="category-item">
                                            <input type="radio" value="" ${selectedCategory==null ? 'checked' : '' }
                                                onchange="selectCategory('')">
                                            <span>Tất cả</span>
                                        </label>
                                        <c:forEach var="cat" items="${categories}">
                                            <label class="category-item">
                                                <input type="radio" value="${cat.categoryId}"
                                                    ${selectedCategory==cat.categoryId ? 'checked' : '' }
                                                    onchange="selectCategory('${cat.categoryId}')">
                                                <span>${cat.categoryName}</span>
                                            </label>
                                        </c:forEach>
                                    </div>

                                    <div class="sidebar-section">
                                        <h3>KHOẢNG GIÁ</h3>
                                        <div class="price-range">
                                            <input type="range" id="minRange" min="0" max="1000000" step="10000"
                                                value="${minPrice}" oninput="updatePrice()">
                                            <input type="range" id="maxRange" min="0" max="1000000" step="10000"
                                                value="${maxPrice}" oninput="updatePrice()">
                                        </div>
                                        <div class="price-labels">
                                            <span>Từ: <b id="minLabel">
                                                    <fmt:formatNumber value="${minPrice}" pattern="#,###" />đ
                                                </b></span>
                                            <span> - <b id="maxLabel">
                                                    <c:choose>
                                                        <c:when test="${maxPrice >= 1000000}">Tối đa</c:when>
                                                        <c:otherwise>
                                                            <fmt:formatNumber value="${maxPrice}" pattern="#,###" />đ
                                                        </c:otherwise>
                                                    </c:choose>
                                                </b></span>
                                        </div>
                                        <button type="button" onclick="applyPrice()" class="btn-apply">Áp dụng</button>
                                    </div>

                                </form>
                            </aside>

                            <main class="product-main">
                                <div class="product-header">
                                    <h2>SẢN PHẨM</h2>
                                    <select class="sort-select" onchange="changeSort(this.value)">
                                        <option value="basePrice-asc" ${sortBy=='basePrice' && sortDir=='asc'
                                            ? 'selected' :''}>Giá tăng dần</option>
                                        <option value="basePrice-desc" ${sortBy=='basePrice' && sortDir=='desc'
                                            ? 'selected' :''}>Giá giảm dần</option>
                                        <option value="productName-asc" ${sortBy=='productName' && sortDir=='asc'
                                            ? 'selected' :''}>Tên A-Z</option>
                                        <option value="productName-desc" ${sortBy=='productName' && sortDir=='desc'
                                            ? 'selected' :''}>Tên Z-A</option>
                                    </select>
                                </div>

                                <div class="product-grid">
                                    <c:choose>
                                        <c:when test="${empty products}">
                                            <div class="no-product">
                                                <p>Không tìm thấy sản phẩm phù hợp</p>
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <c:forEach var="p" items="${products}">
                                                <div class="product-card">
                                                    <div class="product-img">
                                                        <c:choose>
                                                            <c:when test="${not empty p.imageUrl}">
                                                                <img src="${pageContext.request.contextPath}/${p.imageUrl}"
                                                                    alt="${p.productName}">
                                                            </c:when>
                                                            <c:otherwise>
                                                                <div class="img-placeholder"></div>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </div>
                                                    <div class="product-info">
                                                        <p class="product-name">${p.productName}</p>
                                                        <p class="product-price">
                                                            <fmt:formatNumber value="${p.basePrice}" pattern="#,###" />đ
                                                        </p>
                                                        <a href="${pageContext.request.contextPath}/products/${p.productId}"
                                                            class="btn-buy">CHỌN MUA</a>
                                                    </div>
                                                </div>
                                            </c:forEach>
                                        </c:otherwise>
                                    </c:choose>
                                </div>

                                <div class="pagination">
                                    <c:if test="${totalPages > 0}">
                                        <c:forEach begin="0" end="${totalPages - 1}" var="i">
                                            <a href="?page=${i}&categoryId=${selectedCategory}&minPrice=${minPrice}&maxPrice=${maxPrice}&sortBy=${sortBy}&sortDir=${sortDir}"
                                                class="page-btn ${i == currentPage ? 'active' : ''}">${i + 1}</a>
                                        </c:forEach>
                                    </c:if>
                                </div>
                            </main>
                        </div>
                    </div>

                    <%@ include file="/WEB-INF/jsp/common/footer.jsp" %>

                        <script>
                            function selectCategory(val) {
                                document.getElementById('categoryIdInput').value = val;
                                document.getElementById('pageInput').value = 0;
                                document.getElementById('filterForm').submit();
                            }

                            function updatePrice() {
                                const min = parseInt(document.getElementById('minRange').value);
                                const max = parseInt(document.getElementById('maxRange').value);
                                document.getElementById('minLabel').textContent = min.toLocaleString('vi-VN') + 'đ';
                                document.getElementById('maxLabel').textContent = max >= 1000000 ? 'Tối đa' : max.toLocaleString('vi-VN') + 'đ';
                            }

                            function applyPrice() {
                                document.getElementById('minPriceInput').value = document.getElementById('minRange').value;
                                document.getElementById('maxPriceInput').value = document.getElementById('maxRange').value;
                                document.getElementById('pageInput').value = 0;
                                document.getElementById('filterForm').submit();
                            }

                            function changeSort(value) {
                                const [sortBy, sortDir] = value.split('-');
                                document.getElementById('sortByInput').value = sortBy;
                                document.getElementById('sortDirInput').value = sortDir;
                                document.getElementById('pageInput').value = 0;
                                document.getElementById('filterForm').submit();
                            }
                        </script>
            </body>

            </html>