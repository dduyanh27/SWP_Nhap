<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<jsp:include page="common/header.jsp">
    <jsp:param name="title" value="${product.productName} - VMFRUIT" />
    <jsp:param name="activePage" value="product" />
</jsp:include>

<link rel="stylesheet" href="${pageContext.request.contextPath}/css/product-detail.css">

<main class="product-detail-page">

    <nav class="breadcrumb" aria-label="Breadcrumb">
        <a href="${pageContext.request.contextPath}/">Trang chủ</a>
        <span class="separator">/</span>
        <a href="${pageContext.request.contextPath}/products">Trái cây nhập khẩu</a>
        <span class="separator">/</span>
        <span class="current">${product.productName}</span>
    </nav>

    <section class="product-detail-layout" aria-label="Thông tin sản phẩm">

        <div class="product-images">
            <div class="main-image">
                <c:choose>
                    <c:when test="${not empty product.imageUrl}">
                        <img src="${product.imageUrl}" alt="${product.productName}" />
                    </c:when>
                    <c:otherwise>
                        <span class="placeholder">HÌNH ẢNH</span>
                    </c:otherwise>
                </c:choose>
            </div>
            <div class="thumbnail-list">
                <button type="button" class="thumbnail-item active" aria-label="Xem hình sản phẩm 1">
                    <c:choose>
                        <c:when test="${not empty product.imageUrl}">
                            <img src="${product.imageUrl}" alt="" />
                        </c:when>
                        <c:otherwise>
                            <span style="font-size:10px;color:#94a3b8;">IMG</span>
                        </c:otherwise>
                    </c:choose>
                </button>
                <button type="button" class="thumbnail-item" aria-label="Xem hình sản phẩm 2">
                    <span style="font-size:10px;color:#94a3b8;">IMG</span>
                </button>
                <button type="button" class="thumbnail-item" aria-label="Xem hình sản phẩm 3">
                    <span style="font-size:10px;color:#94a3b8;">IMG</span>
                </button>
            </div>
        </div>

        <div class="product-info-section">
            <c:if test="${not empty product.origin}">
                <span class="product-badge">GIÁ SỐC ⚡</span>
            </c:if>

            <h1 class="product-title">${product.productName}</h1>

            <div class="product-rating">
                <span class="stars" aria-label="${avgRating} sao">
                    <c:forEach begin="1" end="5" var="i">
                        <c:choose>
                            <c:when test="${i <= avgRating}">★</c:when>
                            <c:otherwise><span class="empty">★</span></c:otherwise>
                        </c:choose>
                    </c:forEach>
                </span>
                <span class="rating-text">(${reviewCount} Đánh giá từ khách hàng)</span>
            </div>

            <hr class="divider">

            <div class="price-section">
                <span class="current-price"><fmt:formatNumber value="${product.basePrice}" pattern="#,###" />₫</span>
            </div>

            <div class="product-meta">
                <div class="meta-row">
                    <span class="meta-label">Xuất xứ:</span>
                    <span class="meta-value">${not empty product.origin ? product.origin : 'Đang cập nhật'}</span>
                </div>
                <div class="meta-row">
                    <span class="meta-label">Danh mục:</span>
                    <span class="meta-value">${not empty product.productCategories ? product.productCategories[0].category.categoryName : 'Đang cập nhật'}</span>
                </div>
                <div class="meta-row">
                    <span class="meta-label">Tình trạng:</span>
                    <c:choose>
                        <c:when test="${stock > 0}">
                            <span class="meta-value in-stock">Còn hàng (<fmt:formatNumber value="${stock}" pattern="#,##0" />)</span>
                        </c:when>
                        <c:otherwise>
                            <span class="meta-value out-of-stock">Hết hàng</span>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <hr class="divider">

            <div class="quantity-section">
                <span class="quantity-label">Chọn số lượng:</span>
                <div class="quantity-control">
                    <button type="button" class="qty-btn" onclick="decrementQty()">−</button>
                    <input type="number" class="qty-input" id="productQty" value="1" min="1" max="${stock > 0 ? stock : 1}" inputmode="numeric" />
                    <button type="button" class="qty-btn" onclick="incrementQty()">+</button>
                </div>
                <span class="qty-unit">${product.unit}</span>
            </div>

            <div class="action-buttons">
                <button type="button" class="btn-add-cart">THÊM VÀO GIỎ</button>
                <button type="button" class="btn-buy-now">MUA NGAY</button>
            </div>
        </div>

    </section>

    <section class="product-tabs" aria-label="Chi tiết sản phẩm">
        <div class="tab-header">
            <button type="button" class="tab-btn active" data-tab="description">Mô tả sản phẩm</button>
            <button type="button" class="tab-btn" data-tab="nutrition">Giá trị dinh dưỡng</button>
            <button type="button" class="tab-btn" data-tab="storage">Hướng dẫn bảo quản</button>
        </div>
        <div class="tab-content" id="tab-description">
            <p>${not empty product.description ? product.description : 'Đang cập nhật mô tả sản phẩm.'}</p>
        </div>
        <div class="tab-content" id="tab-nutrition" style="display:none;">
            <p>Thông tin giá trị dinh dưỡng đang được cập nhật.</p>
        </div>
        <div class="tab-content" id="tab-storage" style="display:none;">
            <p>Hướng dẫn bảo quản đang được cập nhật.</p>
        </div>
    </section>

</main>

<script>
function decrementQty() {
    var input = document.getElementById('productQty');
    var val = parseInt(input.value) || 1;
    if (val > 1) input.value = val - 1;
}
function incrementQty() {
    var input = document.getElementById('productQty');
    var val = parseInt(input.value) || 1;
    var max = parseInt(input.getAttribute('max')) || 999;
    if (val < max) input.value = val + 1;
}

document.querySelectorAll('.tab-btn').forEach(function(btn) {
    btn.addEventListener('click', function() {
        document.querySelectorAll('.tab-btn').forEach(function(b) { b.classList.remove('active'); });
        document.querySelectorAll('.tab-content').forEach(function(c) { c.style.display = 'none'; });
        this.classList.add('active');
        document.getElementById('tab-' + this.getAttribute('data-tab')).style.display = '';
    });
});
</script>

<jsp:include page="common/footer.jsp" />
