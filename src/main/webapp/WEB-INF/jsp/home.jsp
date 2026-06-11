<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
            <%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

                <jsp:include page="common/header.jsp">
                    <jsp:param name="title" value="VMFruit - Trang chủ" />
                    <jsp:param name="activePage" value="home" />
                </jsp:include>

                <main class="main-content">

                    <!-- HERO BANNER SLIDESHOW -->
                    <section class="hero-slider">
                        <div class="slider-wrapper">
                            <div class="slide active">
                                <img src="${pageContext.request.contextPath}/asset/banner1.jpg" alt="Banner 1" />
                            </div>
                            <div class="slide">
                                <img src="${pageContext.request.contextPath}/asset/banner2.jpg" alt="Banner 2" />
                            </div>
                            <div class="slide">
                                <img src="${pageContext.request.contextPath}/asset/banner3.jpg" alt="Banner 3" />
                            </div>
                        </div>

                        <button class="slider-btn prev" onclick="changeSlide(-1)">&#8249;</button>
                        <button class="slider-btn next" onclick="changeSlide(1)">&#8250;</button>

                        <div class="slider-dots">
                            <span class="dot active" onclick="goToSlide(0)"></span>
                            <span class="dot" onclick="goToSlide(1)"></span>
                            <span class="dot" onclick="goToSlide(2)"></span>
                        </div>
                    </section>

                    <!-- FEATURE BAR -->
                    <div class="feature-bar">
                        <div class="feature-item">
                            <div class="feature-icon">
                                <img src="${pageContext.request.contextPath}/asset/icons/delivery.png"
                                    alt="Giao hàng" />
                            </div>
                            <div class="feature-text">
                                <p class="feature-title">GIAO HÀNG</p>
                                <p class="feature-desc">Tận nơi - Thanh toán tại nhà</p>
                            </div>
                        </div>
                        <div class="feature-item">
                            <div class="feature-icon">
                                <img src="${pageContext.request.contextPath}/asset/icons/product.png" alt="Sản phẩm" />
                            </div>
                            <div class="feature-text">
                                <p class="feature-title">SẢN PHẨM</p>
                                <p class="feature-desc">Cam kết 100% nguồn gốc xuất xứ rõ ràng</p>
                            </div>
                        </div>
                        <div class="feature-item">
                            <div class="feature-icon">
                                <img src="${pageContext.request.contextPath}/asset/icons/promo.png" alt="Khuyến mãi" />
                            </div>
                            <div class="feature-text">
                                <p class="feature-title">KHUYẾN MÃI</p>
                                <p class="feature-desc">Luôn luôn có các chương trình khuyến mãi</p>
                            </div>
                        </div>
                        <div class="feature-item">
                            <div class="feature-icon">
                                <img src="${pageContext.request.contextPath}/asset/icons/support.png" alt="Hỗ trợ" />
                            </div>
                            <div class="feature-text">
                                <p class="feature-title">HỖ TRỢ</p>
                                <p class="feature-desc">Hotline: 086.255.2155</p>
                            </div>
                        </div>
                    </div>

                    <script>
                        let current = 0;
                        const slides = document.querySelectorAll('.slide');
                        const dots = document.querySelectorAll('.dot');

                        function showSlide(n) {
                            slides[current].classList.remove('active');
                            dots[current].classList.remove('active');
                            current = (n + slides.length) % slides.length;
                            slides[current].classList.add('active');
                            dots[current].classList.add('active');
                        }

                        function changeSlide(dir) { showSlide(current + dir); }
                        function goToSlide(n) { showSlide(n); }

                        setInterval(() => changeSlide(1), 4000);
                    </script>

                    <!-- FLASH SALE SECTION -->
                    <section class="flash-sale">
                        <div class="section-banner">
                            <h2>SẢN PHẨM BÁN CHẠY</h2>
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

                                        <button class="btn-add-cart" onclick="handleAddToCart(${product.productId})">
                                            THÊM VÀO GIỎ
                                        </button>
                                    </div>

                                </div>
                            </c:forEach>

                        </div>
                    </section>

                    <!-- REVIEW SECTION -->
                    <section class="review-section">
                        <div class="section-banner">
                            <h2>KHÁCH HÀNG NÓI GÌ VỀ VMFRUIT</h2>
                        </div>

                        <div class="review-grid">
                            <c:forEach var="review" items="${reviews}" end ="2">
                                <div class="review-card">
                                    <div class="review-avatar">
                                        <c:choose>
                                            <c:when test="${not empty review.user.avatarUrl}">
                                                <img src="${review.user.avatarUrl}" alt="${review.user.fullName}" />
                                            </c:when>
                                            <c:otherwise>
                                                <div class="avatar-placeholder">
                                                        ${fn:substring(review.user.fullName, 0, 1)}
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>

                                    <div class="review-stars">
                                        <c:forEach begin="1" end="5" var="i">
                                            <span class="${i <= review.rating ? 'star filled' : 'star'}">★</span>
                                        </c:forEach>
                                    </div>

                                    <p class="review-comment">"${review.comment}"</p>

                                    <div class="review-author">
                                        <strong>${review.user.fullName}</strong>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </section>
                </main>
                <%-- MODAL ĐĂNG NHẬP --%>
                    <div id="loginModal" class="modal-overlay" style="display:none;" onclick="closeLoginModal()">
                        <div class="modal-box" onclick="event.stopPropagation()">
                            <div class="modal-icon">🔒</div>
                            <h2>Bạn chưa đăng nhập</h2>
                            <p>Bạn phải đăng nhập mới đặt được hàng!</p>
                            <div class="modal-actions">
                                <a href="${pageContext.request.contextPath}/login" class="btn-modal-login">Đăng nhập
                                    ngay</a>
                                <button class="btn-modal-cancel" onclick="closeLoginModal()">Để sau</button>
                            </div>
                        </div>
                    </div>

                    <script>
                        const isLoggedIn = ${ not empty sessionScope.currentUser };

                        function handleAddToCart(productId) {
                            if (!isLoggedIn) {
                                document.getElementById('loginModal').style.display = 'flex';
                                return;
                            }

                        }

                        function closeLoginModal() {
                            document.getElementById('loginModal').style.display = 'none';
                        }

                        document.addEventListener('keydown', function (e) {
                            if (e.key === 'Escape') closeLoginModal();
                        });
                    </script>

                    <jsp:include page="common/footer.jsp" />