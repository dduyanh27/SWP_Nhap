<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="ctx" value="${pageContext.request.contextPath}" />

<h1 class="admin-page-title">Review Management</h1>
<p class="admin-page-subtitle">Moderate customer product reviews</p>

<!-- ========== ALERTS ========== -->
<c:if test="${not empty success}">
    <div class="admin-alert success">${success}</div>
</c:if>
<c:if test="${not empty error}">
    <div class="admin-alert error">${error}</div>
</c:if>

<!-- ========== OVERALL ASSESSMENT CARD ========== -->
<div class="dashboard-card" style="display:flex;gap:48px;align-items:stretch;margin-bottom:24px;padding:28px 32px;">
    <!-- Left: overall score -->
    <div style="display:flex;flex-direction:column;align-items:center;justify-content:center;min-width:140px;">
        <span style="font-size:0.75rem;font-weight:700;color:#94a3b8;text-transform:uppercase;letter-spacing:1px;margin-bottom:8px;">Overall assessment</span>
        <span style="font-size:2.6rem;font-weight:900;color:#0f172a;line-height:1;">${overallRating}</span>
        <span style="font-size:1.3rem;color:#f59e0b;letter-spacing:3px;margin:4px 0;">
            <c:choose>
                <c:when test="${overallRating >= 4.5}">★★★★★</c:when>
                <c:when test="${overallRating >= 3.5}">★★★★☆</c:when>
                <c:when test="${overallRating >= 2.5}">★★★☆☆</c:when>
                <c:when test="${overallRating >= 1.5}">★★☆☆☆</c:when>
                <c:otherwise>★☆☆☆☆</c:otherwise>
            </c:choose>
        </span>
        <span style="font-size:0.85rem;color:#94a3b8;font-weight:500;">Total: <fmt:formatNumber value="${totalReviews}" /> reviews</span>
    </div>

    <!-- Right: star distribution bars -->
    <div style="flex:1;display:flex;flex-direction:column;gap:8px;justify-content:center;">
        <c:set var="maxStar" value="${count5Star + count4Star + count3Star + count2Star + count1Star}" />
        <c:if test="${maxStar == 0}"><c:set var="maxStar" value="1" /></c:if>

        <div style="display:flex;align-items:center;gap:8px;">
            <span style="font-size:0.82rem;font-weight:600;color:#334155;min-width:32px;">5 ★</span>
            <div style="flex:1;height:10px;background:#f1f5f9;border-radius:5px;overflow:hidden;">
                <div style="height:100%;width:${count5Star * 100 / maxStar}%;background:linear-gradient(90deg,#22c55e,#16a34a);border-radius:5px;min-width:${count5Star > 0 ? 4 : 0}px;"></div>
            </div>
            <span style="font-size:0.78rem;font-weight:600;color:#64748b;min-width:28px;text-align:right;">${count5Star}</span>
        </div>
        <div style="display:flex;align-items:center;gap:8px;">
            <span style="font-size:0.82rem;font-weight:600;color:#334155;min-width:32px;">4 ★</span>
            <div style="flex:1;height:10px;background:#f1f5f9;border-radius:5px;overflow:hidden;">
                <div style="height:100%;width:${count4Star * 100 / maxStar}%;background:linear-gradient(90deg,#a3e635,#65a30d);border-radius:5px;min-width:${count4Star > 0 ? 4 : 0}px;"></div>
            </div>
            <span style="font-size:0.78rem;font-weight:600;color:#64748b;min-width:28px;text-align:right;">${count4Star}</span>
        </div>
        <div style="display:flex;align-items:center;gap:8px;">
            <span style="font-size:0.82rem;font-weight:600;color:#334155;min-width:32px;">3 ★</span>
            <div style="flex:1;height:10px;background:#f1f5f9;border-radius:5px;overflow:hidden;">
                <div style="height:100%;width:${count3Star * 100 / maxStar}%;background:linear-gradient(90deg,#facc15,#ca8a04);border-radius:5px;min-width:${count3Star > 0 ? 4 : 0}px;"></div>
            </div>
            <span style="font-size:0.78rem;font-weight:600;color:#64748b;min-width:28px;text-align:right;">${count3Star}</span>
        </div>
        <div style="display:flex;align-items:center;gap:8px;">
            <span style="font-size:0.82rem;font-weight:600;color:#334155;min-width:32px;">2 ★</span>
            <div style="flex:1;height:10px;background:#f1f5f9;border-radius:5px;overflow:hidden;">
                <div style="height:100%;width:${count2Star * 100 / maxStar}%;background:linear-gradient(90deg,#fb923c,#ea580c);border-radius:5px;min-width:${count2Star > 0 ? 4 : 0}px;"></div>
            </div>
            <span style="font-size:0.78rem;font-weight:600;color:#64748b;min-width:28px;text-align:right;">${count2Star}</span>
        </div>
        <div style="display:flex;align-items:center;gap:8px;">
            <span style="font-size:0.82rem;font-weight:600;color:#334155;min-width:32px;">1 ★</span>
            <div style="flex:1;height:10px;background:#f1f5f9;border-radius:5px;overflow:hidden;">
                <div style="height:100%;width:${count1Star * 100 / maxStar}%;background:linear-gradient(90deg,#ef4444,#dc2626);border-radius:5px;min-width:${count1Star > 0 ? 4 : 0}px;"></div>
            </div>
            <span style="font-size:0.78rem;font-weight:600;color:#64748b;min-width:28px;text-align:right;">${count1Star}</span>
        </div>
    </div>
</div>

<!-- ========== FILTERS ========== -->
<form method="get" action="${ctx}/admin/reviews" class="admin-toolbar" style="margin-bottom:16px;">
    <div class="toolbar-left">
        <label for="starFilter" style="display:none;">Filter by star:</label>
        <select id="starFilter" name="star" class="admin-select"
                onchange="this.form.submit()">
            <option value="all" ${param.star == null || param.star == 'all' ? 'selected' : ''}>All Stars</option>
            <option value="5" ${param.star == '5' ? 'selected' : ''}>5 ★</option>
            <option value="4" ${param.star == '4' ? 'selected' : ''}>4 ★</option>
            <option value="3" ${param.star == '3' ? 'selected' : ''}>3 ★</option>
            <option value="2" ${param.star == '2' ? 'selected' : ''}>2 ★</option>
            <option value="1" ${param.star == '1' ? 'selected' : ''}>1 ★</option>
        </select>

        <label for="sortSelect" style="display:none;">Sort:</label>
        <select id="sortSelect" name="sort" class="admin-select"
                onchange="this.form.submit()">
            <option value="latest" ${param.sort == null || param.sort == 'latest' ? 'selected' : ''}>Latest</option>
            <option value="oldest" ${param.sort == 'oldest' ? 'selected' : ''}>Oldest</option>
        </select>

        <label for="searchInput" style="display:none;">Search by ID:</label>
        <input id="searchInput" type="search" name="search"
               placeholder="Search by ID, product, user..."
               value="${param.search}"
               class="admin-select"
               style="min-width:240px;padding:10px 14px;background-image:none;"
               onchange="this.form.submit()" />
    </div>
</form>

<!-- ========== REVIEWS TABLE ========== -->
<div class="admin-table-wrapper">
    <table class="admin-table">
        <thead>
            <tr>
                <th>Review ID</th>
                <th>Product</th>
                <th>User</th>
                <th>Rating</th>
                <th>Comment</th>
                <th>Status</th>
                <th>Action</th>
            </tr>
        </thead>
        <tbody>
            <c:choose>
                <c:when test="${not empty reviewList}">
                    <c:forEach var="r" items="${reviewList}">
                        <tr>
                            <td class="product-name">${r.reviewIdDisplay}</td>
                            <td>
                                <div class="product-info-cell">
                                    <div class="product-details">
                                        <span class="product-name">${r.productName}</span>
                                        <span class="product-category">${r.productIdDisplay}</span>
                                    </div>
                                </div>
                            </td>
                            <td>
                                <div class="product-info-cell">
                                    <div class="product-details">
                                        <span class="product-name">${r.userName}</span>
                                        <span class="product-category">${r.userIdDisplay}</span>
                                    </div>
                                </div>
                            </td>
                            <td>
                                <span style="color:#f59e0b;font-size:1rem;letter-spacing:2px;">
                                    <c:choose>
                                        <c:when test="${r.rating == 5}">★★★★★</c:when>
                                        <c:when test="${r.rating == 4}">★★★★☆</c:when>
                                        <c:when test="${r.rating == 3}">★★★☆☆</c:when>
                                        <c:when test="${r.rating == 2}">★★☆☆☆</c:when>
                                        <c:otherwise>★☆☆☆☆</c:otherwise>
                                    </c:choose>
                                </span>
                            </td>
                            <td style="max-width:220px;">
                                <span style="font-size:0.85rem;color:#334155;">${r.commentShort}</span>
                                <c:if test="${r.comment.length() > 50}">
                                    <button type="button" class="action-link edit"
                                            onclick="alert('${r.comment}')"
                                            style="background:none;border:none;cursor:pointer;font-size:0.75rem;margin-left:4px;">View</button>
                                </c:if>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${r.status == 'VISIBLE'}">
                                        <span class="status-badge normal">Approved</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="status-badge hidden">Hidden</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <div class="action-links">
                                    <button type="button" class="action-link edit"
                                            onclick="viewReviewDetail('${r.reviewId}', '${r.reviewIdDisplay}', '${r.productName}', '${r.userName}', '${r.rating}', '${r.comment}', '${r.createdAt}')"
                                            style="background:none;border:none;cursor:pointer;">View</button>
                                    <span class="action-sep">|</span>
                                    <c:choose>
                                        <c:when test="${r.status == 'VISIBLE'}">
                                            <form method="post" action="${ctx}/admin/reviews/hide" style="display:inline;"
                                                  onsubmit="return confirm('Hide this review?')">
                                                <input type="hidden" name="id" value="${r.reviewId}" />
                                                <button type="submit" class="action-link hide"
                                                        style="background:none;border:none;cursor:pointer;">Hide</button>
                                            </form>
                                        </c:when>
                                        <c:otherwise>
                                            <form method="post" action="${ctx}/admin/reviews/show" style="display:inline;"
                                                  onsubmit="return confirm('Show this review?')">
                                                <input type="hidden" name="id" value="${r.reviewId}" />
                                                <button type="submit" class="action-link edit"
                                                        style="background:none;border:none;cursor:pointer;">Show</button>
                                            </form>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <tr>
                        <td class="product-name">R001</td>
                        <td>
                            <div class="product-info-cell">
                                <div class="product-details">
                                    <span class="product-name">Táo Rockit New Zealand</span>
                                    <span class="product-category">P001</span>
                                </div>
                            </div>
                        </td>
                        <td>
                            <div class="product-info-cell">
                                <div class="product-details">
                                    <span class="product-name">Nguyen Van A</span>
                                    <span class="product-category">U001</span>
                                </div>
                            </div>
                        </td>
                        <td><span style="color:#f59e0b;font-size:1rem;letter-spacing:2px;">★★★★★</span></td>
                        <td style="max-width:220px;">
                            <span style="font-size:0.85rem;color:#334155;">Good product, fresh and delicious...</span>
                        </td>
                        <td><span class="status-badge normal">Approved</span></td>
                        <td>
                            <div class="action-links">
                                <button type="button" class="action-link edit" style="background:none;border:none;cursor:pointer;">View</button>
                                <span class="action-sep">|</span>
                                <button type="button" class="action-link hide" style="background:none;border:none;cursor:pointer;">Hide</button>
                            </div>
                        </td>
                    </tr>
                </c:otherwise>
            </c:choose>
        </tbody>
    </table>
</div>

<!-- ========== VIEW MODAL ========== -->
<div id="reviewModal" style="display:none;position:fixed;top:0;left:0;width:100%;height:100%;background:rgba(0,0,0,0.4);z-index:1000;align-items:center;justify-content:center;"
     onclick="if(event.target===this)closeReviewModal()">
    <div style="background:#fff;border-radius:12px;padding:32px;max-width:520px;width:90%;box-shadow:0 20px 60px rgba(0,0,0,0.15);position:relative;">
        <button onclick="closeReviewModal()" style="position:absolute;top:12px;right:16px;background:none;border:none;font-size:1.5rem;color:#94a3b8;cursor:pointer;">&times;</button>
        <h3 style="font-size:1.1rem;font-weight:700;color:#0f172a;margin-bottom:20px;">Review Detail</h3>
        <div style="display:grid;gap:12px;">
            <div><span style="font-weight:600;color:#64748b;font-size:0.85rem;">Review ID:</span> <span id="modalReviewId" style="color:#334155;"></span></div>
            <div><span style="font-weight:600;color:#64748b;font-size:0.85rem;">Product:</span> <span id="modalProduct" style="color:#334155;"></span></div>
            <div><span style="font-weight:600;color:#64748b;font-size:0.85rem;">User:</span> <span id="modalUser" style="color:#334155;"></span></div>
            <div><span style="font-weight:600;color:#64748b;font-size:0.85rem;">Rating:</span> <span id="modalRating" style="color:#f59e0b;font-size:1.1rem;letter-spacing:2px;"></span></div>
            <div><span style="font-weight:600;color:#64748b;font-size:0.85rem;">Date:</span> <span id="modalDate" style="color:#334155;"></span></div>
            <div style="margin-top:4px;">
                <span style="font-weight:600;color:#64748b;font-size:0.85rem;display:block;margin-bottom:6px;">Comment:</span>
                <p id="modalComment" style="background:#f8fafc;border-radius:8px;padding:12px;font-size:0.88rem;color:#334155;line-height:1.6;margin:0;"></p>
            </div>
        </div>
    </div>
</div>

<script>
function viewReviewDetail(id, reviewId, product, user, rating, comment, date) {
    document.getElementById('modalReviewId').textContent = reviewId;
    document.getElementById('modalProduct').textContent = product;
    document.getElementById('modalUser').textContent = user;
    var stars = '';
    for (var i = 0; i < rating; i++) stars += '\u2605';
    for (var i = rating; i < 5; i++) stars += '\u2606';
    document.getElementById('modalRating').textContent = stars;
    document.getElementById('modalComment').textContent = comment || 'No comment';
    document.getElementById('modalDate').textContent = date;
    document.getElementById('reviewModal').style.display = 'flex';
}

function closeReviewModal() {
    document.getElementById('reviewModal').style.display = 'none';
}
</script>
