<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<jsp:include page="common/header.jsp">
    <jsp:param name="title" value="VMFruit - Thanh toán thành công" />
    <jsp:param name="activePage" value="cart" />
</jsp:include>

<link rel="stylesheet" href="${pageContext.request.contextPath}/css/checkout.css">

<main class="main-content">
    <div class="payment-success-wrapper">
        <div class="payment-success-card">
            <div class="payment-success-icon">✓</div>
            <h2>Thanh toán thành công</h2>
            <p>
                VMFruit đã ghi nhận xác nhận chuyển khoản của bạn.
                <c:if test="${not empty orderId}">
                    Mã đơn hàng của bạn là <strong>#${orderId}</strong>.
                </c:if>
            </p>
            <div class="payment-success-actions">
                <a href="${pageContext.request.contextPath}/profile?tab=orders" class="btn-place-order">
                    Xem đơn hàng
                </a>
                <a href="${pageContext.request.contextPath}/products" class="payment-success-secondary">
                    Tiếp tục mua sắm
                </a>
            </div>
        </div>
    </div>
</main>

<jsp:include page="common/footer.jsp" />
