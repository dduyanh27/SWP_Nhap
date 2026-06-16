<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<%-- Determine mode: 'create' or 'edit' --%>
<c:set var="isEdit" value="${not empty product}"/>
<c:set var="pageTitle" value="${isEdit ? 'Edit Product Info' : 'Add New Product'}"/>
<c:set var="pageSubtitle" value="${isEdit ? 'Update details for product ID: P'.concat(product.productId) : 'Fill in the details to add a new fruit product'}"/>

<%-- Breadcrumb --%>
<nav class="nf-breadcrumb">
    <a href="${pageContext.request.contextPath}/admin/products" class="nf-breadcrumb-link">
        ← Back to Fruit Management
    </a>
</nav>

<%-- ── Main card ─────────────────────────────────────────────── --%>
<div class="nf-card">

    <%-- Card Header --%>
    <div class="nf-card-header">
        <div class="nf-card-header-info">
            <h2 class="nf-card-title">${pageTitle}</h2>
            <p class="nf-card-subtitle">${pageSubtitle}</p>
        </div>
        <a href="${pageContext.request.contextPath}/admin/products" class="nf-close-btn" title="Cancel">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                <line x1="18" y1="6" x2="6" y2="18"/><line x1="6" y1="6" x2="18" y2="18"/>
            </svg>
        </a>
    </div>

    <%-- Alert area --%>
    <div id="nfAlert" class="nf-alert" style="display:none;"></div>

    <%-- Flash message từ controller (tạo category thành công / lỗi) --%>
    <c:if test="${not empty catMsg}">
        <div class="nf-alert nf-alert--success" style="margin:16px 32px 0;">${catMsg}</div>
    </c:if>
    <c:if test="${not empty catError}">
        <div class="nf-alert nf-alert--error" style="margin:16px 32px 0;">${catError}</div>
    </c:if>

    <%-- Card Body --%>
    <div class="nf-card-body">

        <%-- LEFT: form fields --%>
        <div class="nf-form-section">

            <%-- Product Name --%>
            <div class="nf-field">
                <label for="fieldName">Product Name <span class="nf-req">*</span></label>
                <input type="text" id="fieldName" class="nf-input"
                       placeholder="e.g. Premium Cherry US"
                       value="${isEdit ? product.productName : ''}" />
            </div>

            <%-- ── CATEGORY MULTI-SELECT ────────────────────────────── --%>
            <div class="nf-field">
                <label>Category</label>

                <%-- Tags hiển thị các danh mục đã chọn --%>
                <div class="nf-cat-tags" id="catTags">
                    <span class="nf-cat-placeholder" id="catPlaceholder">No categories selected</span>
                </div>

                <%-- Dropdown panel chọn category --%>
                <div class="nf-cat-wrapper">
                    <button type="button" class="nf-cat-toggle" id="catToggleBtn"
                            onclick="toggleCatPanel()">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" class="nf-cat-icon">
                            <path d="M4 6h16M4 12h16M4 18h7"/>
                        </svg>
                        <span id="catToggleLabel">Select categories...</span>
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" class="nf-cat-chevron" id="catChevron">
                            <path d="M6 9l6 6 6-6"/>
                        </svg>
                    </button>

                    <div class="nf-cat-panel" id="catPanel">
                        <div class="nf-cat-search-wrap">
                            <input type="text" class="nf-cat-search" id="catSearch"
                                   placeholder="Search categories..."
                                   oninput="filterCategories(this.value)" />
                        </div>
                        <div class="nf-cat-list" id="catList">
                            <%-- Được render bởi JS từ biến allCategories --%>
                        </div>
                    </div>
                </div>

            <%-- ── THÊM CATEGORY MỚI (form HTML thuần, không JS) ──────── --%>
            <div class="nf-new-cat-box">
                <p class="nf-new-cat-title">Không tìm thấy category? Tạo mới ngay:</p>
                <form method="post"
                      action="${pageContext.request.contextPath}/admin/categories/create"
                      class="nf-new-cat-form">
                    <input type="hidden" name="returnId" value="${isEdit ? product.productId : ''}" />
                    <input type="text" name="categoryName" class="nf-input nf-new-cat-input"
                           placeholder="VD: Trái cây nhập khẩu" required />
                    <button type="submit" class="nf-new-cat-btn">+ Tạo &amp; thêm</button>
                </form>
            </div>
            </div>

            <%-- Price + Unit --%>
            <div class="nf-grid-2">
                <div class="nf-field">
                    <label for="fieldPrice">Price per Unit (VND) <span class="nf-req">*</span></label>
                    <input type="number" id="fieldPrice" class="nf-input"
                           placeholder="e.g. 400000" min="0" step="1000"
                           value="${isEdit ? product.basePrice : ''}" />
                </div>
                <div class="nf-field">
                    <label for="fieldUnit">Unit <span class="nf-req">*</span></label>
                    <input type="text" id="fieldUnit" class="nf-input"
                           placeholder="e.g. kg, box, bag"
                           value="${isEdit ? product.unit : ''}" />
                </div>
            </div>

            <%-- Origin + Status --%>
            <div class="nf-grid-2">
                <div class="nf-field">
                    <label for="fieldOrigin">Origin</label>
                    <input type="text" id="fieldOrigin" class="nf-input"
                           placeholder="e.g. New Zealand"
                           value="${isEdit ? product.origin : ''}" />
                </div>
                <div class="nf-field">
                    <label for="fieldStatus">Status</label>
                    <select id="fieldStatus" class="nf-input nf-select">
                        <option value="ACTIVE"   ${isEdit && product.sellingStatus == 'ACTIVE'   ? 'selected' : ''}>Active (Selling)</option>
                        <option value="INACTIVE" ${isEdit && product.sellingStatus == 'INACTIVE' ? 'selected' : ''}>Inactive (Hidden)</option>
                    </select>
                </div>
            </div>

            <%-- Description --%>
            <div class="nf-field">
                <label for="fieldDescription">Product Description</label>
                <textarea id="fieldDescription" class="nf-input nf-textarea"
                          placeholder="Fresh sweet cherries imported directly from premium orchards..."
                          >${isEdit ? product.description : ''}</textarea>
            </div>

        </div><%-- /nf-form-section --%>

        <%-- RIGHT: image preview --%>
        <div class="nf-image-section">
            <p class="nf-image-label">Fruit Image</p>

            <div class="nf-image-box" id="imgBox">
                <c:choose>
                    <c:when test="${isEdit && not empty product.imageUrl}">
                        <img id="imgPreview" src="${product.imageUrl}" alt="Product image" />
                        <div id="imgPlaceholder" class="nf-img-placeholder" style="display:none;"></div>
                    </c:when>
                    <c:otherwise>
                        <div id="imgPlaceholder" class="nf-img-placeholder">
                            <svg viewBox="0 0 80 80" fill="none">
                                <circle cx="40" cy="40" r="38" fill="#fee2e2" stroke="#fca5a5" stroke-width="2"/>
                                <ellipse cx="32" cy="44" rx="12" ry="14" fill="#ef4444" opacity="0.85"/>
                                <ellipse cx="48" cy="46" rx="12" ry="14" fill="#dc2626" opacity="0.9"/>
                                <path d="M40 20 Q44 12 50 14" stroke="#16a34a" stroke-width="3" stroke-linecap="round" fill="none"/>
                                <ellipse cx="52" cy="13" rx="5" ry="3" fill="#16a34a" transform="rotate(-20 52 13)"/>
                            </svg>
                        </div>
                        <img id="imgPreview" src="" alt="Product image" style="display:none;" />
                    </c:otherwise>
                </c:choose>
            </div>

            <div class="nf-field" style="margin-top:12px;">
                <label for="fieldImageUrl">Image URL</label>
                <input type="text" id="fieldImageUrl" class="nf-input"
                       placeholder="https://example.com/image.jpg"
                       value="${isEdit ? product.imageUrl : ''}"
                       oninput="previewImg(this.value)" />
            </div>

            <button type="button" class="nf-change-img-btn"
                    onclick="document.getElementById('fieldImageUrl').focus()">
                Change Image
            </button>
        </div><%-- /nf-image-section --%>

    </div><%-- /nf-card-body --%>

    <%-- Card Footer --%>
    <div class="nf-card-footer">
        <a href="${pageContext.request.contextPath}/admin/products" class="nf-btn-cancel">Cancel</a>
        <button type="button" id="btnSave" class="nf-btn-save" onclick="submitForm()">
            <span id="btnSaveText">Save</span>
            <span id="btnSaveSpinner" class="nf-spinner" style="display:none;"></span>
        </button>
    </div>

</div><%-- /nf-card --%>

<%-- Hidden data --%>
<input type="hidden" id="hiddenProductId" value="${isEdit ? product.productId : ''}" />

<%-- Pass server-side categories + selected IDs to JS --%>
<script>
    /* ── Categories từ server ────────────────────────────────────── */
    const ALL_CATEGORIES = [
        <c:forEach var="cat" items="${categories}" varStatus="st">
        { id: ${cat.categoryId}, name: "${cat.categoryName}" }<c:if test="${!st.last}">,</c:if>
        </c:forEach>
    ];

    const INIT_SELECTED = [
        <c:forEach var="cid" items="${selectedCategoryIds}" varStatus="st">
        ${cid}<c:if test="${!st.last}">,</c:if>
        </c:forEach>
    ];

    /* ── State ───────────────────────────────────────────────────── */
    let selectedIds = new Set(INIT_SELECTED);

    /* ── Build category list UI ──────────────────────────────────── */
    function buildCatList(filter) {
        filter = filter || '';
        var container = document.getElementById('catList');
        var q = filter.trim().toLowerCase();
        var filtered = q
            ? ALL_CATEGORIES.filter(function(c) { return c.name.toLowerCase().indexOf(q) !== -1; })
            : ALL_CATEGORIES;

        if (filtered.length === 0) {
            container.innerHTML = '<div class="nf-cat-empty">No categories found</div>';
            return;
        }

        var CHECK_SVG = '<svg viewBox="0 0 12 12" fill="none" stroke="white" stroke-width="2.5"><polyline points="2,6 5,9 10,3"/></svg>';

        container.innerHTML = filtered.map(function(c) {
            var checked = selectedIds.has(c.id);
            return '<label class="nf-cat-item ' + (checked ? 'nf-cat-item--checked' : '') + '" id="catItem-' + c.id + '">'
                 + '<span class="nf-cat-checkbox ' + (checked ? 'nf-cat-checkbox--checked' : '') + '" id="chk-' + c.id + '">'
                 + (checked ? CHECK_SVG : '')
                 + '</span>'
                 + '<span class="nf-cat-name">' + c.name + '</span>'
                 + '</label>';
        }).join('');

        // Bind click events after rendering
        filtered.forEach(function(c) {
            var el = document.getElementById('catItem-' + c.id);
            if (el) {
                (function(catId, catName) {
                    el.addEventListener('click', function() { toggleCategory(catId, catName); });
                })(c.id, c.name);
            }
        });
    }

    /* ── Toggle select/deselect a category ──────────────────────── */
    function toggleCategory(id, name) {
        if (selectedIds.has(id)) {
            selectedIds.delete(id);
        } else {
            selectedIds.add(id);
        }
        buildCatList(document.getElementById('catSearch').value);
        renderTags();
        updateToggleBtnLabel();
    }

    /* ── Render selected tags ────────────────────────────────────── */
    function renderTags() {
        var tagsEl = document.getElementById('catTags');
        var placeholder = document.getElementById('catPlaceholder');

        // Remove old tags (keep placeholder)
        var oldTags = tagsEl.querySelectorAll('.nf-cat-tag');
        for (var i = 0; i < oldTags.length; i++) { oldTags[i].remove(); }

        if (selectedIds.size === 0) {
            placeholder.style.display = 'inline';
            return;
        }
        placeholder.style.display = 'none';

        selectedIds.forEach(function(id) {
            var cat = ALL_CATEGORIES.find(function(c) { return c.id === id; });
            if (!cat) return;
            var tag = document.createElement('span');
            tag.className = 'nf-cat-tag';
            tag.innerHTML = cat.name + ' <button type="button" onclick="removeCategory(' + id + ')">&times;</button>';
            tagsEl.insertBefore(tag, placeholder);
        });
    }

    function removeCategory(id) {
        selectedIds.delete(id);
        buildCatList(document.getElementById('catSearch').value);
        renderTags();
        updateToggleBtnLabel();
    }

    /* ── Toggle panel open/close ─────────────────────────────────── */
    function toggleCatPanel() {
        const panel   = document.getElementById('catPanel');
        const chevron = document.getElementById('catChevron');
        const open    = panel.classList.toggle('nf-cat-panel--open');
        chevron.style.transform = open ? 'rotate(180deg)' : '';
        if (open) document.getElementById('catSearch').focus();
    }

    function updateToggleBtnLabel() {
        var label = document.getElementById('catToggleLabel');
        label.textContent = selectedIds.size > 0
            ? selectedIds.size + ' categor' + (selectedIds.size === 1 ? 'y' : 'ies') + ' selected'
            : 'Select categories...';
    }

    /* ── Filter search ───────────────────────────────────────────── */
    function filterCategories(val) {
        buildCatList(val);
    }

    /* ── Close panel when clicking outside ──────────────────────── */
    document.addEventListener('click', function(e) {
        const wrapper = document.getElementById('catToggleBtn')?.closest('.nf-cat-wrapper');
        if (wrapper && !wrapper.contains(e.target)) {
            document.getElementById('catPanel').classList.remove('nf-cat-panel--open');
            document.getElementById('catChevron').style.transform = '';
        }
    });

    /* ── Init ────────────────────────────────────────────────────── */
    document.addEventListener('DOMContentLoaded', function() {
        buildCatList();
        renderTags();
        updateToggleBtnLabel();
    });

    /* ── Image preview ─────────────────────────────────────────── */
    function previewImg(url) {
        const img         = document.getElementById('imgPreview');
        const placeholder = document.getElementById('imgPlaceholder');
        if (url && url.trim()) {
            img.src = url.trim();
            img.style.display = 'block';
            if (placeholder) placeholder.style.display = 'none';
        } else {
            img.style.display = 'none';
            if (placeholder) placeholder.style.display = 'flex';
        }
    }

    /* ── Alert ─────────────────────────────────────────────────── */
    function showAlert(msg, type) {
        const el = document.getElementById('nfAlert');
        el.textContent = msg;
        el.className   = 'nf-alert nf-alert--' + type;
        el.style.display = 'block';
        el.scrollIntoView({ behavior: 'smooth', block: 'nearest' });
    }

    /* ── Submit ─────────────────────────────────────────────────── */
    const CTX = '${pageContext.request.contextPath}';

    async function submitForm() {
        const productId = document.getElementById('hiddenProductId').value.trim();
        const isEdit    = productId !== '';

        const name  = document.getElementById('fieldName').value.trim();
        const price = document.getElementById('fieldPrice').value;
        const unit  = document.getElementById('fieldUnit').value.trim();

        if (!name)  { showAlert('Vui lòng nhập tên sản phẩm.', 'error'); return; }
        if (!price) { showAlert('Vui lòng nhập giá sản phẩm.', 'error'); return; }
        if (!unit)  { showAlert('Vui lòng nhập đơn vị.', 'error'); return; }

        const btn     = document.getElementById('btnSave');
        const spinner = document.getElementById('btnSaveSpinner');
        const btnText = document.getElementById('btnSaveText');
        btn.disabled          = true;
        spinner.style.display = 'inline-block';
        btnText.style.opacity = '0.5';

        const payload = {
            productId:     isEdit ? parseInt(productId) : null,
            productName:   name,
            basePrice:     parseFloat(price),
            unit:          unit,
            origin:        document.getElementById('fieldOrigin').value.trim(),
            sellingStatus: document.getElementById('fieldStatus').value,
            imageUrl:      document.getElementById('fieldImageUrl').value.trim(),
            description:   document.getElementById('fieldDescription').value.trim(),
            categoryIds:   Array.from(selectedIds)   // list of selected category IDs
        };

        const url    = isEdit ? CTX + '/admin/products/update' : CTX + '/admin/products/create';
        const method = isEdit ? 'PUT' : 'POST';

        try {
            const res  = await fetch(url, {
                method,
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(payload)
            });
            const data = await res.json();
            if (data.success) {
                showAlert(data.message, 'success');
                setTimeout(() => { window.location.href = CTX + '/admin/products'; }, 1200);
            } else {
                showAlert(data.message || 'Có lỗi xảy ra.', 'error');
                btn.disabled = false; spinner.style.display = 'none'; btnText.style.opacity = '1';
            }
        } catch (err) {
            showAlert('Lỗi kết nối server!', 'error');
            btn.disabled = false; spinner.style.display = 'none'; btnText.style.opacity = '1';
        }
    }

    document.addEventListener('keydown', function(e) {
        if (e.key === 'Enter' && e.target.tagName !== 'TEXTAREA' && e.target.tagName !== 'SELECT'
                              && !e.target.closest('.nf-cat-wrapper')) {
            submitForm();
        }
    });
</script>

<%-- ================================================================
     STYLES
     ================================================================ --%>
<style>
    .nf-breadcrumb { margin-bottom: 20px; }
    .nf-breadcrumb-link {
        font-size: 0.875rem; font-weight: 600; color: #3b82f6;
        text-decoration: none; display: inline-flex; align-items: center; gap: 6px;
        transition: color 0.2s;
    }
    .nf-breadcrumb-link:hover { color: #1d4ed8; }

    /* Card */
    .nf-card {
        background: #ffffff; border-radius: 16px; max-width: 900px;
        box-shadow: 0 4px 24px rgba(0,0,0,0.07), 0 1px 4px rgba(0,0,0,0.04);
        border: 1px solid #e8ecf0; overflow: visible;
    }

    /* Header */
    .nf-card-header {
        display: flex; align-items: flex-start; justify-content: space-between;
        padding: 28px 32px 20px; border-bottom: 1px solid #f1f5f9;
    }
    .nf-card-title  { font-size: 1.35rem; font-weight: 800; color: #0f172a; margin: 0 0 4px; }
    .nf-card-subtitle { font-size: 0.84rem; color: #94a3b8; margin: 0; }
    .nf-close-btn {
        display: flex; align-items: center; justify-content: center;
        width: 36px; height: 36px; border-radius: 50%;
        background: #f1f5f9; color: #64748b; text-decoration: none; flex-shrink: 0;
        transition: background 0.2s, color 0.2s; margin-top: 2px;
    }
    .nf-close-btn svg { width: 18px; height: 18px; }
    .nf-close-btn:hover { background: #fee2e2; color: #ef4444; }

    /* Alert */
    .nf-alert {
        margin: 16px 32px 0; padding: 12px 16px; border-radius: 8px;
        font-size: 0.875rem; font-weight: 500;
    }
    .nf-alert--success { background: #f0fdf4; color: #166534; border: 1px solid #bbf7d0; }
    .nf-alert--error   { background: #fef2f2; color: #b91c1c; border: 1px solid #fecaca; }

    /* Body */
    .nf-card-body {
        display: grid; grid-template-columns: 1fr 240px;
        gap: 32px; padding: 28px 32px;
    }
    .nf-form-section { display: flex; flex-direction: column; gap: 18px; }

    /* Fields */
    .nf-field { display: flex; flex-direction: column; gap: 7px; }
    .nf-field label { font-size: 0.84rem; font-weight: 600; color: #334155; }
    .nf-req { color: #ef4444; }
    .nf-input {
        width: 100%; padding: 11px 14px; border: 1.5px solid #e2e8f0;
        border-radius: 10px; font-size: 0.9rem; color: #1e293b;
        background: #ffffff; font-family: inherit; outline: none;
        transition: border-color 0.2s, box-shadow 0.2s;
    }
    .nf-input:focus { border-color: #3b82f6; box-shadow: 0 0 0 3px rgba(59,130,246,0.1); }
    .nf-select {
        appearance: none;
        background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='14' height='14' fill='none' viewBox='0 0 24 24' stroke='%2394a3b8' stroke-width='2'%3E%3Cpath stroke-linecap='round' stroke-linejoin='round' d='M19 9l-7 7-7-7'/%3E%3C/svg%3E");
        background-repeat: no-repeat; background-position: right 12px center;
        padding-right: 36px; cursor: pointer;
    }
    .nf-textarea { resize: vertical; min-height: 100px; line-height: 1.6; }
    .nf-grid-2 { display: grid; grid-template-columns: 1fr 1fr; gap: 14px; }

    /* ── Category multi-select ─────────────────────────────────── */
    .nf-cat-tags {
        display: flex; flex-wrap: wrap; gap: 6px;
        min-height: 34px; align-items: center;
        padding: 6px 4px 2px;
    }
    .nf-cat-placeholder { font-size: 0.82rem; color: #94a3b8; font-style: italic; }

    .nf-cat-tag {
        display: inline-flex; align-items: center; gap: 5px;
        background: #eff6ff; color: #1d4ed8;
        border: 1.5px solid #bfdbfe; border-radius: 20px;
        padding: 3px 10px 3px 12px; font-size: 0.8rem; font-weight: 600;
        animation: tagPop 0.18s ease;
    }
    @keyframes tagPop { from { transform: scale(0.85); opacity: 0; } to { transform: scale(1); opacity: 1; } }
    .nf-cat-tag button {
        background: none; border: none; cursor: pointer;
        color: #60a5fa; font-size: 1rem; line-height: 1;
        padding: 0; font-family: inherit; display: flex; align-items: center;
        transition: color 0.15s;
    }
    .nf-cat-tag button:hover { color: #dc2626; }

    /* Dropdown wrapper */
    .nf-cat-wrapper { position: relative; }

    .nf-cat-toggle {
        width: 100%; display: flex; align-items: center; gap: 8px;
        padding: 10px 14px; border: 1.5px solid #e2e8f0; border-radius: 10px;
        background: #ffffff; color: #475569; font-size: 0.88rem; font-weight: 500;
        cursor: pointer; font-family: inherit; text-align: left;
        transition: border-color 0.2s, box-shadow 0.2s;
    }
    .nf-cat-toggle:hover { border-color: #3b82f6; }
    .nf-cat-icon    { width: 16px; height: 16px; flex-shrink: 0; color: #94a3b8; }
    .nf-cat-chevron { width: 16px; height: 16px; flex-shrink: 0; color: #94a3b8; margin-left: auto; transition: transform 0.2s; }

    /* Panel */
    .nf-cat-panel {
        display: none; position: absolute; top: calc(100% + 6px); left: 0; right: 0;
        background: #ffffff; border: 1.5px solid #e2e8f0; border-radius: 12px;
        box-shadow: 0 8px 30px rgba(0,0,0,0.12); z-index: 500;
        overflow: hidden; animation: catDrop 0.18s ease;
    }
    .nf-cat-panel--open { display: block; }
    @keyframes catDrop { from { opacity: 0; transform: translateY(-6px); } to { opacity: 1; transform: translateY(0); } }

    .nf-cat-search-wrap { padding: 10px 10px 6px; border-bottom: 1px solid #f1f5f9; }
    .nf-cat-search {
        width: 100%; padding: 8px 12px; border: 1px solid #e2e8f0; border-radius: 8px;
        font-size: 0.85rem; color: #334155; font-family: inherit; outline: none;
        background: #f8fafc; transition: border-color 0.2s;
    }
    .nf-cat-search:focus { border-color: #3b82f6; background: #fff; }

    .nf-cat-list { max-height: 220px; overflow-y: auto; padding: 6px 0; }
    .nf-cat-list::-webkit-scrollbar { width: 5px; }
    .nf-cat-list::-webkit-scrollbar-thumb { background: #e2e8f0; border-radius: 3px; }

    .nf-cat-item {
        display: flex; align-items: center; gap: 10px;
        padding: 10px 14px; cursor: pointer;
        transition: background 0.12s; user-select: none;
    }
    .nf-cat-item:hover { background: #f8fafc; }
    .nf-cat-item--checked { background: #eff6ff; }
    .nf-cat-item--checked:hover { background: #dbeafe; }

    .nf-cat-checkbox {
        width: 18px; height: 18px; flex-shrink: 0;
        border: 2px solid #cbd5e1; border-radius: 5px;
        display: flex; align-items: center; justify-content: center;
        transition: border-color 0.15s, background 0.15s;
    }
    .nf-cat-checkbox svg { width: 10px; height: 10px; }
    .nf-cat-checkbox--checked { background: #3b82f6; border-color: #3b82f6; }

    .nf-cat-name { font-size: 0.88rem; color: #334155; font-weight: 500; }
    .nf-cat-empty { padding: 16px; text-align: center; color: #94a3b8; font-size: 0.85rem; }

    /* Image section */
    .nf-image-section { display: flex; flex-direction: column; gap: 0; }
    .nf-image-label { font-size: 0.84rem; font-weight: 600; color: #3b82f6; margin: 0 0 10px; }
    .nf-image-box {
        width: 100%; aspect-ratio: 1/1; background: #fff0f0; border-radius: 14px;
        display: flex; align-items: center; justify-content: center; overflow: hidden;
        border: 1.5px solid #fde8e8;
    }
    .nf-image-box img { width: 100%; height: 100%; object-fit: contain; border-radius: 12px; }
    .nf-img-placeholder { display: flex; flex-direction: column; align-items: center; gap: 8px; }
    .nf-img-placeholder svg { width: 72px; height: 72px; }

    .nf-change-img-btn {
        margin-top: 12px; width: 100%; padding: 9px 16px;
        border: 1.5px solid #e2e8f0; border-radius: 10px;
        background: #ffffff; color: #475569; font-size: 0.84rem; font-weight: 600;
        cursor: pointer; font-family: inherit; transition: border-color 0.2s, background 0.2s;
    }
    .nf-change-img-btn:hover { border-color: #3b82f6; background: #f0f7ff; color: #2563eb; }

    /* Footer */
    .nf-card-footer {
        display: flex; align-items: center; justify-content: flex-end;
        gap: 12px; padding: 20px 32px 28px; border-top: 1px solid #f1f5f9;
    }
    .nf-btn-cancel {
        display: inline-flex; align-items: center; justify-content: center;
        padding: 11px 28px; border-radius: 10px; border: 1.5px solid #e2e8f0;
        background: #ffffff; color: #475569; font-size: 0.9rem; font-weight: 600;
        text-decoration: none; font-family: inherit; transition: background 0.2s, border-color 0.2s;
    }
    .nf-btn-cancel:hover { background: #f8fafc; border-color: #cbd5e1; color: #334155; }
    .nf-btn-save {
        display: inline-flex; align-items: center; justify-content: center; gap: 8px;
        padding: 11px 32px; border-radius: 10px; border: none; background: #3b82f6;
        color: #ffffff; font-size: 0.9rem; font-weight: 700; cursor: pointer;
        font-family: inherit; transition: background 0.2s, transform 0.15s; min-width: 100px;
    }
    .nf-btn-save:hover:not(:disabled) { background: #2563eb; transform: translateY(-1px); }
    .nf-btn-save:disabled { opacity: 0.65; cursor: not-allowed; transform: none; }
    .nf-spinner {
        width: 14px; height: 14px; border: 2px solid rgba(255,255,255,0.35);
        border-top-color: #fff; border-radius: 50%; animation: nfSpin 0.65s linear infinite;
    }
    @keyframes nfSpin { to { transform: rotate(360deg); } }

    /* ── New category inline box ───────────────────────────────── */
    .nf-new-cat-box {
        margin-top: 10px; padding: 12px 14px;
        background: #f8fafc; border: 1.5px dashed #cbd5e1;
        border-radius: 10px;
    }
    .nf-new-cat-title {
        font-size: 0.78rem; font-weight: 600; color: #64748b;
        margin: 0 0 8px;
    }
    .nf-new-cat-form {
        display: flex; gap: 8px; align-items: center;
    }
    .nf-new-cat-input {
        flex: 1; padding: 9px 12px; font-size: 0.85rem;
    }
    .nf-new-cat-btn {
        white-space: nowrap; padding: 9px 16px;
        background: #10b981; color: #fff;
        border: none; border-radius: 9px;
        font-size: 0.85rem; font-weight: 700;
        cursor: pointer; font-family: inherit;
        transition: background 0.2s;
    }
    .nf-new-cat-btn:hover { background: #059669; }

    /* Responsive */
    @media (max-width: 720px) {
        .nf-card-body { grid-template-columns: 1fr; }
        .nf-image-section { order: -1; }
        .nf-image-box { max-height: 180px; aspect-ratio: auto; }
        .nf-grid-2 { grid-template-columns: 1fr; }
        .nf-new-cat-form { flex-direction: column; }
        .nf-new-cat-btn { width: 100%; }
    }
</style>
