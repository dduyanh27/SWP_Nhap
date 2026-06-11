<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

            <h1 class="admin-page-title">Fruit Management</h1>

            <div class="stat-cards-grid">
                <div class="stat-card">
                    <div class="stat-card-label">Low Stock Product</div>
                    <div class="stat-card-value">${lowStockCount != null ? lowStockCount : '05'}</div>
                </div>
                <div class="stat-card">
                    <div class="stat-card-label">Expiring Soon</div>
                    <div class="stat-card-value">${expiringSoonCount != null ? expiringSoonCount : '03'}</div>
                </div>
                <div class="stat-card">
                    <div class="stat-card-label">Hidden Items</div>
                    <div class="stat-card-value">${hiddenCount != null ? hiddenCount : '2'}</div>
                </div>
                <div class="stat-card">
                    <div class="stat-card-label">Total Products</div>
                    <div class="stat-card-value">${totalProducts != null ? totalProducts : '90'}</div>
                </div>
            </div>

            <div class="admin-toolbar">
                <div class="toolbar-left">
                    <select id="sortSelect" name="sort" class="admin-select" onchange="applyFilters()">
                        <option value="stock_asc" ${param.sort=='stock_asc' ? 'selected' : '' }>Stock ASC (Sort)
                        </option>
                        <option value="stock_desc" ${param.sort=='stock_desc' ? 'selected' : '' }>Stock DESC (Sort)
                        </option>
                        <option value="price_asc" ${param.sort=='price_asc' ? 'selected' : '' }>Price ASC (Sort)
                        </option>
                        <option value="price_desc" ${param.sort=='price_desc' ? 'selected' : '' }>Price DESC (Sort)
                        </option>
                    </select>

                    <select id="priceFilter" name="price" class="admin-select" onchange="applyFilters()">
                        <option value="" ${param.price=='' ? 'selected' : '' }>All Price (Filter)</option>
                        <option value="under_100" ${param.price=='under_100' ? 'selected' : '' }>Under 100.000đ</option>
                        <option value="100_300" ${param.price=='100_300' ? 'selected' : '' }>100.000đ – 300.000đ
                        </option>
                        <option value="over_300" ${param.price=='over_300' ? 'selected' : '' }>Over 300.000đ</option>
                    </select>
                </div>

                <a href="${pageContext.request.contextPath}/admin/products/new" id="btnAddProduct"
                    class="btn-add-product">
                    + New Product
                </a>
            </div>

            <div class="admin-table-wrapper">
                <table class="admin-table">
                    <thead>
                        <tr>
                            <th style="width: 10%;">Mã SP</th>
                            <th style="width: 40%;">Sản phẩm</th>
                            <th style="width: 20%;">Giá cơ sở</th>
                            <th style="width: 12%;">Tổng kho</th>
                            <th style="width: 18%;">Trạng thái</th>
                            <th style="text-align:right;">Hành động</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${not empty productList}">
                                <c:forEach var="p" items="${productList}">
                                    <tr>
                                        <td class="product-name">P
                                            <fmt:formatNumber value="${p.productId}" minIntegerDigits="3"
                                                groupingUsed="false" />
                                        </td>
                                        <td>
                                            <div class="product-info-cell">
                                                <img src="${not empty p.imageUrl ? p.imageUrl : pageContext.request.contextPath+'/css/default-fruit.png'}"
                                                    alt="fruit" class="product-img" />
                                                <div class="product-details">
                                                    <span class="product-name">${p.productName}</span>
                                                    <span class="product-category">Danh mục: ${p.categoryName}</span>
                                                </div>
                                            </div>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${not empty p.price}">
                                                    <fmt:formatNumber value="${p.price}" type="number"
                                                        groupingUsed="true" />
                                                </c:when>
                                                <c:otherwise>0</c:otherwise>
                                            </c:choose>đ / ${p.unit}
                                        </td>
                                        <td class="product-name">
                                            <fmt:formatNumber value="${p.stock}" maxFractionDigits="0" />
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${p.status == 'INACTIVE' || p.status == 'hidden'}">
                                                    <span class="status-badge hidden">Hidden</span>
                                                </c:when>
                                                <c:when test="${p.stock > 0 && p.stock <= 5}">
                                                    <span class="status-badge low-stock">Low Stock</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="status-badge normal">Normal</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td style="text-align:right;">
                                            <div class="action-links" style="justify-content:flex-end;">
                                                <a href="${pageContext.request.contextPath}/admin/products/edit?id=${p.productId}"
                                                    class="action-link edit">Edit</a>
                                                <span class="action-sep">|</span>
                                                <a href="${pageContext.request.contextPath}/admin/products/hide?id=${p.productId}"
                                                    class="action-link hide"
                                                    onclick="return confirm('Ẩn sản phẩm này khỏi cửa hàng?')">Hide</a>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td class="product-name">P001</td>
                                    <td>
                                        <div class="product-info-cell">
                                            <div class="product-img" style="background: #FEF3C7;"></div>
                                            <div class="product-details">
                                                <span class="product-name">Táo Rockit New Zealand</span>
                                                <span class="product-category">Danh mục: Trái cây nhập khẩu</span>
                                            </div>
                                        </div>
                                    </td>
                                    <td>400.000đ / Hộp</td>
                                    <td class="product-name">50</td>
                                    <td><span class="status-badge normal">Normal</span></td>
                                    <td style="text-align:right;">
                                        <div class="action-links" style="justify-content:flex-end;">
                                            <a href="#" class="action-link edit">Edit</a>
                                            <span class="action-sep">|</span>
                                            <a href="#" class="action-link hide">Hide</a>
                                        </div>
                                    </td>
                                </tr>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>

            <script>
                function applyFilters() {
                    const sort = document.getElementById('sortSelect').value;
                    const price = document.getElementById('priceFilter').value;
                    const base = window.location.pathname;
                    window.location.href = base + '?sort=' + encodeURIComponent(sort) + '&price=' + encodeURIComponent(price);
                }
            </script>