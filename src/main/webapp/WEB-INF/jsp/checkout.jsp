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
        <p class="checkout-subtitle">Chọn địa chỉ giao hàng, quét mã VietQR và xác nhận chuyển khoản.</p>

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
                            <div class="checkout-card">
                                <div class="checkout-card-heading">
                                    <h3 class="checkout-card-title">Địa chỉ giao hàng</h3>
                                    <button type="button" class="btn-add-address" id="btnOpenAddressModal">
                                        Thêm địa chỉ mới
                                    </button>
                                </div>

                                <c:if test="${not empty successMessage}">
                                    <div class="checkout-alert checkout-alert-success">${successMessage}</div>
                                </c:if>
                                <c:if test="${not empty errorMessage}">
                                    <div class="checkout-alert checkout-alert-error">${errorMessage}</div>
                                </c:if>

                                <c:choose>
                                    <c:when test="${not empty addressList}">
                                        <div class="saved-address-list">
                                            <c:forEach var="addr" items="${addressList}" varStatus="loop">
                                                <label class="saved-address-item${addr.isDefault or (empty defaultAddress and loop.first) ? ' selected' : ''}">
                                                    <input type="radio"
                                                           name="addressId"
                                                           value="${addr.addressId}"
                                                           required
                                                           ${addr.isDefault or (empty defaultAddress and loop.first) ? 'checked' : ''}>
                                                    <div class="saved-address-info">
                                                        <div class="saved-address-name">
                                                            ${addr.receiverName} - ${addr.phone}
                                                            <c:if test="${addr.isDefault}">
                                                                <span class="saved-address-badge">Mặc định</span>
                                                            </c:if>
                                                        </div>
                                                        <div class="saved-address-detail">${addr.fullAddress}</div>
                                                    </div>
                                                </label>
                                            </c:forEach>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="checkout-address-empty">
                                            Bạn chưa có địa chỉ giao hàng. Hãy thêm địa chỉ mới để tiếp tục đặt hàng.
                                        </div>
                                    </c:otherwise>
                                </c:choose>
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
                                <input type="text" class="promo-input" id="promoCode" placeholder="Mã khuyến mãi">
                                <button type="button" class="btn-promo" id="btnApplyPromo">Áp dụng</button>
                            </div>
                            <input type="hidden" name="discountCode" id="discountCode" value="" />

                            <div id="discountInfo" class="summary-row" style="display:none;">
                                <span>Giảm giá</span>
                                <span class="summary-discount" id="discountAmount" style="color:#10b981;">-0đ</span>
                            </div>

                            <div class="summary-row summary-total">
                                <span>Tổng thanh toán</span>
                                <span class="summary-total-price">
                                    <fmt:formatNumber value="${cartTotal}" pattern="#,###"/>đ
                                </span>
                            </div>

                            <button type="submit" class="btn-place-order" id="btnPlaceOrder" ${empty addressList ? 'disabled' : ''}>
                                Xác nhận chuyển khoản
                            </button>
                        </aside>
                    </div>
                </form>

                <div class="checkout-modal" id="addressModal" aria-hidden="true">
                    <div class="checkout-modal-backdrop" data-close-address-modal></div>
                    <div class="checkout-modal-dialog" role="dialog" aria-modal="true" aria-labelledby="addressModalTitle">
                        <div class="checkout-modal-header">
                            <h3 id="addressModalTitle">Thêm địa chỉ mới</h3>
                            <button type="button" class="checkout-modal-close" data-close-address-modal aria-label="Đóng">×</button>
                        </div>
                        <form action="${pageContext.request.contextPath}/checkout/address/add" method="POST">
                            <div class="checkout-form-group">
                                <label for="newReceiverName">Tên người nhận <span class="required">*</span></label>
                                <input type="text" id="newReceiverName" name="receiverName" class="checkout-input" required>
                            </div>
                            <div class="checkout-form-group">
                                <label for="newPhone">Số điện thoại <span class="required">*</span></label>
                                <input type="tel" id="newPhone" name="phone" class="checkout-input" required>
                            </div>
                            <div class="checkout-form-group">
                                <label for="newFullAddress">Địa chỉ đầy đủ <span class="required">*</span></label>
                                <textarea id="newFullAddress" name="fullAddress" class="checkout-textarea" required></textarea>
                            </div>
                            <label class="checkout-checkbox">
                                <input type="checkbox" name="isDefault" value="1">
                                Đặt làm địa chỉ mặc định
                            </label>
                            <div class="checkout-modal-actions">
                                <button type="button" class="btn-modal-secondary" data-close-address-modal>Hủy</button>
                                <button type="submit" class="btn-modal-primary">Lưu địa chỉ</button>
                            </div>
                        </form>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</main>

<script>
(function () {
    const form = document.getElementById('checkoutForm');
    const addressItems = document.querySelectorAll('.saved-address-item');

    addressItems.forEach(function (item) {
        item.addEventListener('click', function () {
            addressItems.forEach(function (el) { el.classList.remove('selected'); });
            item.classList.add('selected');
            const radio = item.querySelector('input[type="radio"]');
            if (radio) radio.checked = true;
        });
    });

    if (form) {
        form.addEventListener('submit', function (event) {
            if (!form.checkValidity()) {
                event.preventDefault();
                form.reportValidity();
            }
        });
    }

    // Discount code
    var cartTotal = ${cartTotal};
    var currentDiscount = 0;
    var codeApplied = false;

    document.getElementById('btnApplyPromo').addEventListener('click', function () {
        var code = document.getElementById('promoCode').value.trim();
        if (!code) {
            alert('Vui lòng nhập mã giảm giá.');
            return;
        }

        var xhr = new XMLHttpRequest();
        xhr.open('POST', '${pageContext.request.contextPath}/api/discounts/validate', true);
        xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
        xhr.onreadystatechange = function () {
            if (xhr.readyState === 4 && xhr.status === 200) {
                var res = JSON.parse(xhr.responseText);
                if (res.valid) {
                    var discountVal = parseFloat(res.discountValue);
                    var discount = 0;
                    if (res.discountType === 'PERCENTAGE') {
                        discount = cartTotal * discountVal / 100;
                        if (res.maxDiscountAmount && discount > parseFloat(res.maxDiscountAmount)) {
                            discount = parseFloat(res.maxDiscountAmount);
                        }
                    } else {
                        discount = discountVal;
                    }
                    if (discount > cartTotal) discount = cartTotal;
                    discount = Math.floor(discount);

                    currentDiscount = discount;
                    var finalTotal = Math.floor(cartTotal - discount);
                    codeApplied = true;

                    document.getElementById('discountCode').value = code;
                    document.getElementById('discountAmount').textContent = '-' + discount.toLocaleString('vi-VN') + 'đ';
                    document.getElementById('discountInfo').style.display = 'flex';
                    document.querySelector('.summary-total-price').textContent = finalTotal.toLocaleString('vi-VN') + 'đ';
                    document.getElementById('btnApplyPromo').textContent = 'Đã áp dụng';
                    document.getElementById('btnApplyPromo').style.background = '#10b981';
                    document.getElementById('promoCode').disabled = true;
                    alert(res.message);
                } else {
                    alert(res.message);
                }
            }
        };
        xhr.send('code=' + encodeURIComponent(code) + '&cartTotal=' + cartTotal);
    });
})();
</script>

<jsp:include page="common/footer.jsp" />
