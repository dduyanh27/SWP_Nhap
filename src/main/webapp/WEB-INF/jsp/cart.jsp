<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<jsp:include page="common/header.jsp">
    <jsp:param name="title" value="VMFruit - Giỏ hàng" />
    <jsp:param name="activePage" value="cart" />
</jsp:include>

<link rel="stylesheet" href="${pageContext.request.contextPath}/css/cart.css">

<main class="main-content">
    <div class="cart-wrapper">
        <h2 class="cart-title">Giỏ hàng của bạn</h2>

        <c:if test="${not empty successMessage}">
            <div class="alert-success">${successMessage}</div>
        </c:if>
        <c:if test="${not empty errorMessage}">
            <div class="alert-error">${errorMessage}</div>
        </c:if>

        <c:choose>

            <c:when test="${empty cartItems}">
                <div class="cart-empty">
                    <svg xmlns="http://www.w3.org/2000/svg" width="64" height="64" fill="none"
                         viewBox="0 0 24 24" stroke="#94a3b8" stroke-width="1.5">
                        <path stroke-linecap="round" stroke-linejoin="round"
                              d="M3 3h2l.4 2M7 13h10l4-8H5.4M7 13L5.4 5M7 13l-2.293 2.293c-.63.63-.184 1.707.707 1.707H17m0 0a2 2 0 100 4 2 2 0 000-4zm-8 2a2 2 0 11-4 0 2 2 0 014 0z"/>
                    </svg>
                    <p>Giỏ hàng của bạn đang trống</p>
                    <a href="${pageContext.request.contextPath}/products" class="btn-shop">Tiếp tục mua sắm</a>
                </div>
            </c:when>


            <c:otherwise>
                <div class="cart-layout">

                        <%-- Danh sách sản phẩm --%>
                    <div class="cart-items-section">
                        <table class="cart-table">
                            <thead>
                            <tr>
                                <th>Sản phẩm</th>
                                <th>Đơn giá</th>
                                <th>Số lượng</th>
                                <th>Đơn vị</th>
                                <th>Thành tiền</th>
                                <th></th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach var="item" items="${cartItems}">
                                <tr>

                                    <td class="cart-product-cell">
                                        <img src="${pageContext.request.contextPath}/${item.imageUrl}"
                                             alt="${item.productName}"
                                             class="cart-product-img"
                                             onerror="this.src='${pageContext.request.contextPath}/asset/placeholder.png'">
                                        <span class="cart-product-name">${item.productName}</span>
                                    </td>


                                    <td class="cart-price">
                                        <fmt:formatNumber value="${item.unitPrice}" pattern="#,###"/>đ
                                    </td>


                                    <td>
                                        <div class="qty-control">
                                            <form action="${pageContext.request.contextPath}/cart/update/${item.cartItemId}"
                                                  method="POST" style="display:inline">
                                                <button type="submit" name="quantity"
                                                        value="${item.quantity.subtract(1)}"
                                                        class="qty-btn"
                                                    ${item.quantity <= 1 ? 'disabled' : ''}>−</button>
                                            </form>
                                            <span class="qty-value">${item.quantity}</span>
                                            <form action="${pageContext.request.contextPath}/cart/update/${item.cartItemId}"
                                                  method="POST" style="display:inline">
                                                <button type="submit" name="quantity"
                                                        value="${item.quantity.add(1)}"
                                                        class="qty-btn">+</button>
                                            </form>
                                        </div>
                                    </td>
                                    <td class="cart-unit">${item.unit}</td>


                                    <td class="cart-subtotal">
                                        <fmt:formatNumber value="${item.subtotal}" pattern="#,###"/>đ
                                    </td>
                                    <td>
                                        <form action="${pageContext.request.contextPath}/cart/remove/${item.cartItemId}"
                                              method="POST">
                                            <button type="submit" class="cart-remove-btn" title="Xóa">
                                                <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18"
                                                     fill="none" viewBox="0 0 24 24"
                                                     stroke="currentColor" stroke-width="2">
                                                    <path stroke-linecap="round" stroke-linejoin="round"
                                                          d="M6 18L18 6M6 6l12 12"/>
                                                </svg>
                                            </button>
                                        </form>
                                    </td>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>

                        <a href="${pageContext.request.contextPath}/products" class="cart-continue-link">
                            ← Tiếp tục mua sắm
                        </a>
                    </div>
                    <div class="cart-summary">
                        <h3 class="summary-title">Tóm tắt đơn hàng</h3>

                        <div class="summary-row">
                            <span>Số sản phẩm</span>
                            <span>${cartCount} sản phẩm</span>
                        </div>

                        <div class="summary-row summary-total">
                            <span>Tổng tiền</span>
                            <span class="summary-total-price">
                                <fmt:formatNumber value="${cartTotal}" pattern="#,###"/>đ
                            </span>
                        </div>

                        <div class="summary-promo">
                            <input type="text" class="promo-input" placeholder="Mã khuyến mãi">
                            <button class="btn-promo">Áp dụng</button>
                        </div>

                        <a href="${pageContext.request.contextPath}/checkout" class="btn-checkout">
                            Tiến hành thanh toán
                        </a>

                        <div class="summary-note">
                            <label>Ghi chú đơn hàng:</label>
                            <textarea class="note-textarea" rows="4" placeholder="Nhập ghi chú..."></textarea>
                        </div>
                    </div>

                </div>
            </c:otherwise>
        </c:choose>
    </div>
</main>

<jsp:include page="common/footer.jsp" />
