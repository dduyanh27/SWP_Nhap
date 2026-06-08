<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!-- PAGE HEADER -->
<div class="page-header">
    <div>
        <h1 class="admin-page-title">Admin Dashboard</h1>
        <p class="admin-page-subtitle">Business overview and real-time system statistics</p>
    </div>
</div>

<!-- STATS -->
<div class="stat-cards-grid">
    <div class="stat-card">
        <div class="stat-card-icon green">
            <svg width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="12" y1="1" x2="12" y2="23"/><path d="M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6"/></svg>
        </div>
        <div>
            <div class="stat-card-label">TOTAL REVENUE</div>
            <div class="stat-card-value">$<fmt:formatNumber value="${totalRevenue}" type="number" maxFractionDigits="0" /></div>
        </div>
    </div>
    <div class="stat-card">
        <div class="stat-card-icon blue">
            <svg width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M6 2L3 6v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2V6l-3-4z"/><line x1="3" y1="6" x2="21" y2="6"/><path d="M16 10a4 4 0 0 1-8 0"/></svg>
        </div>
        <div>
            <div class="stat-card-label">TOTAL ORDERS</div>
            <div class="stat-card-value"><fmt:formatNumber value="${totalOrders}" type="number" /></div>
        </div>
    </div>
    <div class="stat-card">
        <div class="stat-card-icon orange">
            <svg width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg>
        </div>
        <div>
            <div class="stat-card-label">PENDING ORDERS</div>
            <div class="stat-card-value"><fmt:formatNumber value="${pendingOrders}" type="number" /></div>
        </div>
    </div>
</div>

<!-- CHARTS -->
<div class="charts-row">
    <div class="dashboard-card">
        <div class="dashboard-card-header">
            <div>
                <div class="dashboard-card-title">Revenue Overview</div>
                <div class="dashboard-card-subtitle">Revenue statistics by selected period</div>
            </div>
            <div class="chart-tabs">
                <button class="chart-tab active">Week</button>
                <button class="chart-tab">Month</button>
                <button class="chart-tab">Year</button>
            </div>
        </div>
        <div class="chart-box">
            <div class="bar-chart">
                <div class="bar-col"><div class="bar bar-blue" style="height:55px"></div><span>Mon</span></div>
                <div class="bar-col"><div class="bar bar-blue" style="height:85px"></div><span>Tue</span></div>
                <div class="bar-col"><div class="bar bar-blue" style="height:40px"></div><span>Wed</span></div>
                <div class="bar-col"><div class="bar bar-blue" style="height:105px"></div><span>Thu</span></div>
                <div class="bar-col"><div class="bar bar-blue" style="height:70px"></div><span>Fri</span></div>
                <div class="bar-col"><div class="bar bar-blue" style="height:125px"></div><span>Sat</span></div>
                <div class="bar-col"><div class="bar bar-blue" style="height:45px"></div><span>Sun</span></div>
            </div>
        </div>
    </div>

    <div class="dashboard-card order-status-card">
        <div class="dashboard-card-header">
            <div>
                <div class="dashboard-card-title">Order Status</div>
                <div class="dashboard-card-subtitle">Current order processing status</div>
            </div>
        </div>
        <div class="order-status-list">
            <div class="order-status-item">
                <span class="order-status-dot pending-dot"></span>
                <span>Pending</span>
                <span class="order-status-count">42 orders</span>
            </div>
            <div class="order-status-item">
                <span class="order-status-dot shipping-dot"></span>
                <span>Shipping</span>
                <span class="order-status-count">86 orders</span>
            </div>
            <div class="order-status-item">
                <span class="order-status-dot completed-dot"></span>
                <span>Completed</span>
                <span class="order-status-count">1,020 orders</span>
            </div>
        </div>
    </div>
</div>

<!-- BEST-SELLING PRODUCTS -->
<div class="dashboard-card">
    <div class="dashboard-card-header">
        <div class="dashboard-card-title">Best-Selling Products</div>
    </div>
    <table class="bestseller-table" id="bestsellerTable">
        <thead>
            <tr><th>Product</th><th>Sold Qty</th><th>Revenue</th><th>Status</th></tr>
        </thead>
        <tbody id="bestsellerTableBody">
            <c:choose>
                <c:when test="${empty bestSellingProducts}">
                    <tr><td>Apple Fuji</td><td>320</td><td>$2,400</td><td><span class="badge badge-bestseller">Best Seller</span></td></tr>
                    <tr><td>Organic Banana</td><td>280</td><td>$1,120</td><td><span class="badge badge-trending">Trending</span></td></tr>
                    <tr><td>Red Grapes</td><td>195</td><td>$1,755</td><td><span class="badge badge-normal">Normal</span></td></tr>
                    <tr><td>Avocado Hass</td><td>150</td><td>$1,050</td><td><span class="badge badge-normal">Normal</span></td></tr>
                    <tr><td>Orange Navel</td><td>120</td><td>$540</td><td><span class="badge badge-low">Low</span></td></tr>
                </c:when>
                <c:otherwise>
                    <c:forEach var="p" items="${bestSellingProducts}">
                        <tr><td>${p.productName}</td><td>${p.soldQty}</td><td>$${p.revenue}</td><td><span class="badge ${p.statusClass}">${p.statusLabel}</span></td></tr>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </tbody>
    </table>
    <div class="pagination" id="productPagination"></div>
</div>

<script>
(function() {
    var table = document.getElementById('bestsellerTable');
    var tbody = table.querySelector('tbody');
    var rows = Array.from(tbody.querySelectorAll('tr'));
    var rowsPerPage = 3;
    var currentPage = 1;

    function renderPagination() {
        var totalPages = Math.ceil(rows.length / rowsPerPage);
        var container = document.getElementById('productPagination');
        container.innerHTML = '';

        var prevBtn = document.createElement('button');
        prevBtn.className = 'page-btn prev-next' + (currentPage === 1 ? ' disabled' : '');
        prevBtn.textContent = 'Previous';
        if (currentPage > 1) {
            prevBtn.addEventListener('click', function() { goToPage(currentPage - 1); });
        }
        container.appendChild(prevBtn);

        for (var i = 1; i <= totalPages; i++) {
            var btn = document.createElement('button');
            btn.className = 'page-btn' + (i === currentPage ? ' active' : '');
            btn.textContent = i;
            btn.addEventListener('click', (function(page) {
                return function() { goToPage(page); };
            })(i));
            container.appendChild(btn);
        }

        var nextBtn = document.createElement('button');
        nextBtn.className = 'page-btn prev-next' + (currentPage === totalPages ? ' disabled' : '');
        nextBtn.textContent = 'Next';
        if (currentPage < totalPages) {
            nextBtn.addEventListener('click', function() { goToPage(currentPage + 1); });
        }
        container.appendChild(nextBtn);
    }

    function goToPage(page) {
        currentPage = page;
        showPage(page);
        renderPagination();
    }

    function showPage(page) {
        var start = (page - 1) * rowsPerPage;
        var end = start + rowsPerPage;
        for (var i = 0; i < rows.length; i++) {
            rows[i].style.display = (i >= start && i < end) ? '' : 'none';
        }
    }

    var sortDirections = {};

    function sortTable(colIndex) {
        var key = 'col' + colIndex;
        sortDirections[key] = !(sortDirections[key] || false);
        var ascending = sortDirections[key];

        rows.sort(function(a, b) {
            var aText = a.children[colIndex].textContent.trim();
            var bText = b.children[colIndex].textContent.trim();
            var aNum = parseFloat(aText.replace(/[$,]/g, ''));
            var bNum = parseFloat(bText.replace(/[$,]/g, ''));

            if (!isNaN(aNum) && !isNaN(bNum)) {
                return ascending ? aNum - bNum : bNum - aNum;
            }
            return ascending ? aText.localeCompare(bText) : bText.localeCompare(aText);
        });

        rows.forEach(function(row) { tbody.appendChild(row); });
        showPage(currentPage);

        var ths = table.querySelectorAll('thead th');
        ths.forEach(function(th, idx) {
            th.innerHTML = th.innerHTML.replace(/ ?[▲▼]$/, '');
            if (idx === colIndex) {
                th.innerHTML += ascending ? ' ▲' : ' ▼';
            }
        });
    }

    var headerCells = table.querySelectorAll('thead th');
    headerCells.forEach(function(th, idx) {
        th.style.cursor = 'pointer';
        th.addEventListener('click', function() { sortTable(idx); });
    });

    showPage(1);
    renderPagination();
})();
</script>
