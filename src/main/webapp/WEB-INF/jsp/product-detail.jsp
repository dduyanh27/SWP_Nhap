<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

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
                        <img src="${pageContext.request.contextPath}/${product.imageUrl}" alt="${product.productName}" />
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
                            <img src="${pageContext.request.contextPath}/${product.imageUrl}" alt="" />
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
                <button type="button" class="btn-add-cart" data-product-id="${product.productId}">THÊM VÀO GIỎ</button>
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

    <section class="reviews-section">
        <div class="reviews-container">
            <h2 class="reviews-title">Đánh giá sản phẩm</h2>

            <c:if test="${not empty reviewSuccess}">
                <div class="review-alert review-alert-success">${reviewSuccess}</div>
            </c:if>
            <c:if test="${not empty reviewError}">
                <div class="review-alert review-alert-error">${reviewError}</div>
            </c:if>

            <c:choose>
                <c:when test="${canReview}">
                    <div class="review-form-wrapper">
                        <h3>Viết đánh giá của bạn</h3>
                        <form action="${pageContext.request.contextPath}/products/${product.productId}/review" method="POST" class="review-form">
                            <div class="rating-select">
                                <span class="rating-label">Chất lượng sản phẩm:</span>
                                <div class="star-rating">
                                    <input type="radio" id="star5" name="rating" value="5" />
                                    <label for="star5" title="5 sao">★</label>
                                    <input type="radio" id="star4" name="rating" value="4" />
                                    <label for="star4" title="4 sao">★</label>
                                    <input type="radio" id="star3" name="rating" value="3" />
                                    <label for="star3" title="3 sao">★</label>
                                    <input type="radio" id="star2" name="rating" value="2" />
                                    <label for="star2" title="2 sao">★</label>
                                    <input type="radio" id="star1" name="rating" value="1" />
                                    <label for="star1" title="1 sao">★</label>
                                </div>
                            </div>
                            <textarea name="comment" class="review-textarea" placeholder="Chia sẻ trải nghiệm của bạn về sản phẩm này..." required></textarea>
                            <button type="submit" class="btn-submit-review">GỬI ĐÁNH GIÁ</button>
                        </form>
                    </div>
                </c:when>
                <c:when test="${not isLoggedIn}">
                    <div class="review-login-prompt">
                        <p>Vui lòng <a href="${pageContext.request.contextPath}/login">đăng nhập</a> để viết đánh giá.</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="review-login-prompt">
                        <p>Bạn đã đánh giá sản phẩm này rồi.</p>
                    </div>
                </c:otherwise>
            </c:choose>

            <c:choose>
                <c:when test="${not empty reviews and reviews.size() > 0}">
                    <div class="reviews-list">
                        <c:forEach var="review" items="${reviews}">
                            <div class="review-item">
                                <div class="review-header">
                                    <div class="reviewer-avatar">
                                        <c:choose>
                                            <c:when test="${not empty review.user.avatarUrl}">
                                                <img src="${pageContext.request.contextPath}/${review.user.avatarUrl}" alt="${review.user.fullName}" />
                                            </c:when>
                                            <c:otherwise>
                                                <span class="avatar-placeholder">${fn:substring(review.user.fullName, 0, 1)}</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                    <div class="reviewer-info">
                                        <span class="reviewer-name">${review.user.fullName}</span>
                                        <span class="review-date">${fn:substring(review.createdAt.toString(), 0, 10)}</span>
                                    </div>
                                    <div class="review-stars">
                                        <c:forEach begin="1" end="5" var="i">
                                            <c:choose>
                                                <c:when test="${i <= review.rating}">★</c:when>
                                                <c:otherwise><span class="empty">★</span></c:otherwise>
                                            </c:choose>
                                        </c:forEach>
                                    </div>
                                </div>
                                <p class="review-comment">${review.comment}</p>
                            </div>
                        </c:forEach>
                    </div>
                </c:when>
                <c:otherwise>
                    <p class="no-reviews">Chưa có đánh giá nào cho sản phẩm này.</p>
                </c:otherwise>
            </c:choose>
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

const isLoggedIn = ${ not empty sessionScope.currentUser };

document.querySelector('.btn-add-cart').addEventListener('click', function(e) {
    var productId = this.getAttribute('data-product-id');
    var quantity = document.getElementById('productQty').value || 1;

    if (!isLoggedIn) {
        window.location.href = '${pageContext.request.contextPath}/login';
        return;
    }

    var form = document.createElement('form');
    form.method = 'POST';
    form.style.display = 'none';
    form.action = '${pageContext.request.contextPath}/cart/add';
    var inputPid = document.createElement('input');
    inputPid.type = 'hidden';
    inputPid.name = 'productId';
    inputPid.value = productId;
    form.appendChild(inputPid);
    var inputQty = document.createElement('input');
    inputQty.type = 'hidden';
    inputQty.name = 'quantity';
    inputQty.value = quantity;
    form.appendChild(inputQty);
    document.body.appendChild(form);
    form.submit();
});
</script>

<jsp:include page="common/footer.jsp" />
