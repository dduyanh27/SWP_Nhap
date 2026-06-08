<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

            <jsp:include page="common/header.jsp">
                <jsp:param name="title" value="VMFruit - Trang chủ" />
                <jsp:param name="activePage" value="home" />
            </jsp:include>

            <main class="main-content">

                <!-- HERO BANNER -->
                <section class="hero-banner">
                    <div class="hero-text">
                        <span class="hero-tag">Sản Phẩm Nổi Bật</span>
                        <h1 class="hero-title">DƯA LƯỚI VIẾT MINH</h1>
                        <h2 class="hero-subtitle">Giòn tan - Mọng nước - Ngọt thanh</h2>
                        <p class="hero-desc">
                            Thưởng thức hương vị thiên nhiên từ vùng đất sạch. Đảm bảo chuẩn GlobalGAP.
                        </p>
                        <a href="#" class="hero-btn">MUA NGAY</a>
                    </div>

                    <div class="hero-izmage-wrapper">
                        <div class="hero-image-bg">
                            <span class="hero-image-placeholder">IMAGE PLACEHOLDER</span>
                        </div>
                    </div>
                </section>

                <!-- FLASH SALE SECTION -->
                <section class="flash-sale">
                    <div class="section-header">
                        <h2 class="section-title">
                            <span class="flash-icon">⚡</span> FLASH SALE
                        </h2>
                        <span class="countdown-timer">Kết thúc sau: 02:45</span>
                    </div>

                    <div class="product-grid">

                        <c:forEach var="product" items="${products}" begin="0" end="7">
                            <div class="product-card">

                                <div class="product-image-container">
                                    <c:choose>
                                        <c:when test="${not empty product.imageUrl}">
                                            <img class="product-img" src="${product.imageUrl}"
                                                alt="${product.productName}">
                                        </c:when>

                                        <c:otherwise>
                                            <span class="hero-image-placeholder">IMAGE PLACEHOLDER</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>

                                <div class="product-info">
                                    <h3 class="product-name">${product.productName}</h3>

                                    <p class="product-desc">
                                        ${product.description}
                                    </p>

                                    <div class="product-price">
                                        <fmt:formatNumber value="${product.basePrice}" pattern="#,###" />đ
                                    </div>

                                    <button class="btn-add-cart">
                                        THÊM VÀO GIỎ
                                    </button>
                                </div>

                            </div>
                        </c:forEach>

                    </div>
                </section>

            </main>

            <jsp:include page="common/footer.jsp" />