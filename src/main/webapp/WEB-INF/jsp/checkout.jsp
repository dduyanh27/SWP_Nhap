<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<jsp:include page="common/header.jsp">
    <jsp:param name="title" value="VMFruit - Thanh toán" />
    <jsp:param name="activePage" value="cart" />
</jsp:include>

<link rel="stylesheet" href="${pageContext.request.contextPath}/css/checkout.css">

<main class="main-content">
    <div class="checkout-wrapper">

        <nav class="checkout-breadcrumb" aria-label="Breadcrumb">
            <a href="${pageContext.request.contextPath}/">Trang chủ</a>
            <span> / </span>
            <a href="${pageContext.request.contextPath}/cart">Giỏ hàng</a>
            <span> / </span>
            <span>Thanh toán</span>
        </nav>

        <h2 class="checkout-title">Thanh toán đơn hàng</h2>
        <p class="checkout-subtitle">Vui lòng điền thông tin giao hàng và xác nhận đơn hàng của bạn.</p>

        <c:choose>
            <c:when test="${empty cartItems}">
                <div class="checkout-empty">
                    <p>Giỏ hàng trống, không thể thanh toán.</p>
                    <a href="${pageContext.request.contextPath}/products" class="btn-place-order" style="display:inline-block;width:auto;padding:12px 28px;">
                        Tiếp tục mua sắm
                    </a>
                </div>
            </c:when>

            <c:otherwise>
                <form id="checkoutForm" action="${pageContext.request.contextPath}/checkout" method="POST" novalidate>
                    <div class="checkout-layout">

                        <div class="checkout-form-section">

                            <c:if test="${not empty addressList}">
                                <div class="checkout-card">
                                    <h3 class="checkout-card-title">Địa chỉ đã lưu</h3>
                                    <div class="saved-address-list">
                                        <c:forEach var="addr" items="${addressList}">
                                            <label class="saved-address-item${addr.isDefault ? ' selected' : ''}"
                                                   data-name="${addr.receiverName}"
                                                   data-phone="${addr.phone}"
                                                   data-address="${addr.fullAddress}">
                                                <input type="radio" name="savedAddress"
                                                       value="${addr.addressId}"
                                                       ${addr.isDefault ? 'checked' : ''}>
                                                <div class="saved-address-info">
                                                    <div class="saved-address-name">
                                                        ${addr.receiverName} — ${addr.phone}
                                                        <c:if test="${addr.isDefault}">
                                                            <span class="saved-address-badge">Mặc định</span>
                                                        </c:if>
                                                    </div>
                                                    <div class="saved-address-detail">${addr.fullAddress}</div>
                                                </div>
                                            </label>
                                        </c:forEach>
                                    </div>
                                </div>
                            </c:if>

                            <div class="checkout-card">
                                <h3 class="checkout-card-title">Thông tin giao hàng</h3>

                                <div class="checkout-form-group">
                                    <label for="receiverName">Họ và tên người nhận <span class="required">*</span></label>
                                    <input type="text" id="receiverName" name="receiverName" class="checkout-input"
                                           placeholder="Nhập họ và tên"
                                           value="${not empty defaultAddress ? defaultAddress.receiverName : currentUser.fullName}"
                                           required>
                                </div>

                                <div class="checkout-form-row">
                                    <div class="checkout-form-group">
                                        <label for="phone">Số điện thoại <span class="required">*</span></label>
                                        <input type="tel" id="phone" name="phone" class="checkout-input"
                                               placeholder="Nhập số điện thoại"
                                               value="${not empty defaultAddress ? defaultAddress.phone : currentUser.phone}"
                                               required>
                                    </div>
                                    <div class="checkout-form-group">
                                        <label for="email">Email <span class="required">*</span></label>
                                        <input type="email" id="email" name="email" class="checkout-input"
                                               placeholder="Nhập email"
                                               value="${currentUser.email}"
                                               required>
                                    </div>
                                </div>

                                <div class="checkout-form-group">
                                    <label for="fullAddress">Địa chỉ giao hàng <span class="required">*</span></label>
                                    <textarea id="fullAddress" name="fullAddress" class="checkout-textarea"
                                              placeholder="Số nhà, đường, phường/xã, quận/huyện, tỉnh/thành phố"
                                              required>${not empty defaultAddress ? defaultAddress.fullAddress : ''}</textarea>
                                </div>

                                <div class="checkout-form-group">
                                    <label for="orderNote">Ghi chú đơn hàng</label>
                                    <textarea id="orderNote" name="orderNote" class="checkout-textarea" rows="3"
                                              placeholder="Ghi chú thêm cho đơn hàng (không bắt buộc)"></textarea>
                                </div>
                            </div>

                            <div class="checkout-card">
                                <h3 class="checkout-card-title">Phương thức thanh toán</h3>
                                <div class="payment-options">
                                    <label class="payment-option">
                                        <input type="radio" name="paymentMethod" value="VIETQR" checked>
                                        <div class="payment-option-info">
                                            <div class="payment-option-name">Chuyển khoản VietQR</div>
                                            <div class="payment-option-desc">Quét mã QR bên dưới và bấm xác nhận sau khi chuyển khoản.</div>
                                        </div>
                                        <span class="payment-logo-text">VietQR</span>
                                    </label>
                                    <div class="vietqr-box">
                                        <img class="vietqr-image"
                                             src="https://img.vietqr.io/image/${vietQrBankId}-${vietQrAccountNo}-compact2.png?amount=${vietQrAmount}&addInfo=${vietQrInfoEncoded}&accountName=${vietQrAccountNameEncoded}"
                                             alt="VietQR ${vietQrBankId} ${vietQrAccountNo}">
                                        <div class="vietqr-details">
                                            <div><span>Ngân hàng:</span> <strong>${vietQrBankId}</strong></div>
                                            <div><span>Số tài khoản:</span> <strong>${vietQrAccountNo}</strong></div>
                                            <div><span>Chủ tài khoản:</span> <strong>${vietQrAccountName}</strong></div>
                                            <div><span>Nội dung:</span> <strong>${vietQrInfo}</strong></div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <a href="${pageContext.request.contextPath}/cart" class="checkout-back-link">
                                ← Quay lại giỏ hàng
                            </a>
                        </div>

                        <aside class="checkout-summary">
                            <h3 class="summary-title">Tóm tắt đơn hàng</h3>

                            <div class="summary-items">
                                <c:forEach var="item" items="${cartItems}">
                                    <div class="summary-item">
                                        <img src="${pageContext.request.contextPath}/${item.imageUrl}"
                                             alt="${item.productName}"
                                             class="summary-item-img"
                                             onerror="this.src='${pageContext.request.contextPath}/asset/placeholder.png'">
                                        <div class="summary-item-info">
                                            <div class="summary-item-name">${item.productName}</div>
                                            <div class="summary-item-meta">
                                                <fmt:formatNumber value="${item.unitPrice}" pattern="#,###"/>đ
                                                × ${item.quantity} ${item.unit}
                                            </div>
                                        </div>
                                        <div class="summary-item-price">
                                            <fmt:formatNumber value="${item.subtotal}" pattern="#,###"/>đ
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>

                            <div class="summary-row">
                                <span>Số sản phẩm</span>
                                <span>${cartCount} sản phẩm</span>
                            </div>

                            <div class="summary-promo">
                                <input type="text" class="promo-input" name="promoCode" placeholder="Mã khuyến mãi">
                                <button type="button" class="btn-promo">Áp dụng</button>
                            </div>

                            <div class="summary-row summary-total">
                                <span>Tổng thanh toán</span>
                                <span class="summary-total-price">
                                    <fmt:formatNumber value="${cartTotal}" pattern="#,###"/>đ
                                </span>
                            </div>

                            <button type="submit" class="btn-place-order" id="btnPlaceOrder">
                                Xác nhận chuyển khoản
                            </button>
                        </aside>

                    </div>
                </form>
            </c:otherwise>
        </c:choose>
    </div>
</main>

<script>
(function () {
    const form = document.getElementById('checkoutForm');
    if (!form) return;

    const addressItems = document.querySelectorAll('.saved-address-item');
    const receiverName = document.getElementById('receiverName');
    const phone = document.getElementById('phone');
    const fullAddress = document.getElementById('fullAddress');

    addressItems.forEach(function (item) {
        item.addEventListener('click', function () {
            addressItems.forEach(function (el) { el.classList.remove('selected'); });
            item.classList.add('selected');
            const radio = item.querySelector('input[type="radio"]');
            if (radio) radio.checked = true;
            if (receiverName) receiverName.value = item.dataset.name || '';
            if (phone) phone.value = item.dataset.phone || '';
            if (fullAddress) fullAddress.value = item.dataset.address || '';
        });
    });

    const btnPlaceOrder = document.getElementById('btnPlaceOrder');
    if (btnPlaceOrder) {
        btnPlaceOrder.addEventListener('click', function (event) {
            event.preventDefault();
            if (!form.checkValidity()) {
                form.reportValidity();
                return;
            }
            form.submit();
        });
    }
})();
</script>

<jsp:include page="common/footer.jsp" />
