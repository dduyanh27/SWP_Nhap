<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:set var="isEdit" value="${not empty product}"/>
<c:set var="pageTitle" value="${isEdit ? 'Edit Product Info' : 'Add New Product'}"/>
<c:set var="pageSubtitle" value="${isEdit ? 'Update product information' : 'Fill in the details to add a new fruit product'}"/>

<nav class="nf-breadcrumb">
    <a href="${pageContext.request.contextPath}/admin/products" class="nf-breadcrumb-link">
        ← Back to Fruit Management
    </a>
</nav>

<div class="nf-card">
    <div class="nf-card-header">
        <div class="nf-card-header-info">
            <h2 class="nf-card-title">${pageTitle}</h2>
            <p class="nf-card-subtitle">${pageSubtitle}</p>
        </div>
        <a href="${pageContext.request.contextPath}/admin/products" class="nf-close-btn" title="Cancel">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                <line x1="18" y1="6" x2="6" y2="18"/>
                <line x1="6" y1="6" x2="18" y2="18"/>
            </svg>
        </a>
    </div>

    <c:if test="${not empty catMsg}">
        <div class="nf-alert nf-alert--success">${catMsg}</div>
    </c:if>
    <c:if test="${not empty catError}">
        <div class="nf-alert nf-alert--error">${catError}</div>
    </c:if>
    <c:if test="${not empty error}">
        <div class="nf-alert nf-alert--error">${error}</div>
    </c:if>

    <form method="post"
          action="${pageContext.request.contextPath}/admin/products/${isEdit ? 'update' : 'create'}">
        <c:if test="${isEdit}">
            <input type="hidden" name="productId" value="${product.productId}"/>
        </c:if>

        <div class="nf-card-body">
            <div class="nf-form-section">
                <div class="nf-field">
                    <label for="fieldName">Product Name <span class="nf-req">*</span></label>
                    <input type="text" id="fieldName" name="productName" class="nf-input"
                           placeholder="e.g. Premium Cherry US"
                           value="${isEdit ? product.productName : ''}" required/>
                </div>

                <div class="nf-field">
                    <label>Category</label>
                    <div class="nf-checkbox-list">
                        <c:forEach var="cat" items="${categories}">
                            <c:set var="isSelectedCategory" value="false"/>
                            <c:forEach var="selectedId" items="${selectedCategoryIds}">
                                <c:if test="${selectedId == cat.categoryId}">
                                    <c:set var="isSelectedCategory" value="true"/>
                                </c:if>
                            </c:forEach>
                            <label class="nf-checkbox-item">
                                <input type="checkbox" name="categoryIds" value="${cat.categoryId}"
                                    <c:if test="${isSelectedCategory}">checked</c:if>/>
                                <span>${cat.categoryName}</span>
                            </label>
                        </c:forEach>
                    </div>

                </div>

                <div class="nf-grid-2">
                    <div class="nf-field">
                        <label for="fieldPrice">Price per Unit (VND) <span class="nf-req">*</span></label>
                        <input type="number" id="fieldPrice" name="basePrice" class="nf-input"
                               placeholder="e.g. 400000" min="0" step="1000"
                               value="${isEdit ? product.basePrice : ''}" required/>
                    </div>
                    <div class="nf-field">
                        <label for="fieldUnit">Unit <span class="nf-req">*</span></label>
                        <input type="text" id="fieldUnit" name="unit" class="nf-input"
                               placeholder="e.g. kg, box, bag"
                               value="${isEdit ? product.unit : ''}" required/>
                    </div>
                </div>

                <div class="nf-grid-2">
                    <div class="nf-field">
                        <label for="fieldOrigin">Origin</label>
                        <input type="text" id="fieldOrigin" name="origin" class="nf-input"
                               placeholder="e.g. New Zealand"
                               value="${isEdit ? product.origin : ''}"/>
                    </div>
                    <div class="nf-field">
                        <label for="fieldStatus">Status</label>
                        <select id="fieldStatus" name="sellingStatus" class="nf-input nf-select">
                            <option value="ACTIVE" ${isEdit && product.sellingStatus == 'ACTIVE' ? 'selected' : ''}>Active (Selling)</option>
                            <option value="INACTIVE" ${isEdit && product.sellingStatus == 'INACTIVE' ? 'selected' : ''}>Inactive (Hidden)</option>
                        </select>
                    </div>
                </div>

                <div class="nf-field">
                    <label for="fieldDescription">Product Description</label>
                    <textarea id="fieldDescription" name="description" class="nf-input nf-textarea"
                              placeholder="Fresh sweet cherries imported directly from premium orchards...">${isEdit ? product.description : ''}</textarea>
                </div>
            </div>

            <div class="nf-image-section">
                <p class="nf-image-label">Fruit Image</p>
                <div class="nf-image-box">
                    <c:choose>
                        <c:when test="${isEdit && not empty product.imageUrl}">
                            <img src="${product.imageUrl}" alt="Product image"/>
                        </c:when>
                        <c:otherwise>
                            <div class="nf-img-placeholder">
                                <svg viewBox="0 0 80 80" fill="none">
                                    <circle cx="40" cy="40" r="38" fill="#fee2e2" stroke="#fca5a5" stroke-width="2"/>
                                    <ellipse cx="32" cy="44" rx="12" ry="14" fill="#ef4444" opacity="0.85"/>
                                    <ellipse cx="48" cy="46" rx="12" ry="14" fill="#dc2626" opacity="0.9"/>
                                    <path d="M40 20 Q44 12 50 14" stroke="#16a34a" stroke-width="3" stroke-linecap="round" fill="none"/>
                                    <ellipse cx="52" cy="13" rx="5" ry="3" fill="#16a34a" transform="rotate(-20 52 13)"/>
                                </svg>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>

                <div class="nf-field" style="margin-top:12px;">
                    <label for="fieldImageUrl">Image URL</label>
                    <input type="text" id="fieldImageUrl" name="imageUrl" class="nf-input"
                           placeholder="https://example.com/image.jpg"
                           value="${isEdit ? product.imageUrl : ''}"/>
                </div>
            </div>
        </div>

        <div class="nf-card-footer">
            <a href="${pageContext.request.contextPath}/admin/products" class="nf-btn-cancel">Cancel</a>
            <button type="submit" class="nf-btn-save">Save</button>
        </div>
    </form>
</div>

<form method="post"
      action="${pageContext.request.contextPath}/admin/categories/create"
      class="nf-create-category-form">
    <input type="hidden" name="returnId" value="${isEdit ? product.productId : ''}"/>
    <input type="text" name="categoryName" class="nf-input" placeholder="New category name" required/>
    <button type="submit" class="nf-new-cat-btn">+ Tạo category</button>
</form>

<style>
    .nf-breadcrumb { margin-bottom: 20px; }
    .nf-breadcrumb-link {
        font-size: 0.875rem; font-weight: 600; color: #3b82f6;
        text-decoration: none; display: inline-flex; align-items: center; gap: 6px;
    }
    .nf-card {
        background: #ffffff; border-radius: 16px; max-width: 900px;
        box-shadow: 0 4px 24px rgba(0,0,0,0.07), 0 1px 4px rgba(0,0,0,0.04);
        border: 1px solid #e8ecf0; overflow: visible;
    }
    .nf-card-header {
        display: flex; align-items: flex-start; justify-content: space-between;
        padding: 28px 32px 20px; border-bottom: 1px solid #f1f5f9;
    }
    .nf-card-title { font-size: 1.35rem; font-weight: 800; color: #0f172a; margin: 0 0 4px; }
    .nf-card-subtitle { font-size: 0.84rem; color: #94a3b8; margin: 0; }
    .nf-close-btn {
        display: flex; align-items: center; justify-content: center;
        width: 36px; height: 36px; border-radius: 50%;
        background: #f1f5f9; color: #64748b; text-decoration: none; flex-shrink: 0;
    }
    .nf-close-btn svg { width: 18px; height: 18px; }
    .nf-alert {
        margin: 16px 32px 0; padding: 12px 16px; border-radius: 8px;
        font-size: 0.875rem; font-weight: 500;
    }
    .nf-alert--success { background: #f0fdf4; color: #166534; border: 1px solid #bbf7d0; }
    .nf-alert--error { background: #fef2f2; color: #b91c1c; border: 1px solid #fecaca; }
    .nf-card-body { display: grid; grid-template-columns: 1fr 240px; gap: 32px; padding: 28px 32px; }
    .nf-form-section { display: flex; flex-direction: column; gap: 18px; }
    .nf-field { display: flex; flex-direction: column; gap: 7px; }
    .nf-field label { font-size: 0.84rem; font-weight: 600; color: #334155; }
    .nf-req { color: #ef4444; }
    .nf-input {
        width: 100%; padding: 11px 14px; border: 1.5px solid #e2e8f0;
        border-radius: 10px; font-size: 0.9rem; color: #1e293b;
        background: #ffffff; font-family: inherit; outline: none;
    }
    .nf-input:focus { border-color: #3b82f6; box-shadow: 0 0 0 3px rgba(59,130,246,0.1); }
    .nf-select { cursor: pointer; }
    .nf-textarea { resize: vertical; min-height: 100px; line-height: 1.6; }
    .nf-grid-2 { display: grid; grid-template-columns: 1fr 1fr; gap: 14px; }
    .nf-checkbox-list {
        display: grid; grid-template-columns: repeat(auto-fit, minmax(170px, 1fr));
        gap: 8px; padding: 10px; border: 1.5px solid #e2e8f0; border-radius: 10px;
        max-height: 180px; overflow: auto;
    }
    .nf-checkbox-item {
        display: flex; align-items: center; gap: 8px; font-size: 0.88rem;
        color: #334155; font-weight: 500;
    }
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
    .nf-card-footer {
        display: flex; align-items: center; justify-content: flex-end;
        gap: 12px; padding: 20px 32px 28px; border-top: 1px solid #f1f5f9;
    }
    .nf-btn-cancel {
        display: inline-flex; align-items: center; justify-content: center;
        padding: 11px 28px; border-radius: 10px; border: 1.5px solid #e2e8f0;
        background: #ffffff; color: #475569; font-size: 0.9rem; font-weight: 600;
        text-decoration: none; font-family: inherit;
    }
    .nf-btn-save, .nf-new-cat-btn {
        display: inline-flex; align-items: center; justify-content: center; gap: 8px;
        padding: 11px 32px; border-radius: 10px; border: none; background: #3b82f6;
        color: #ffffff; font-size: 0.9rem; font-weight: 700; cursor: pointer;
        font-family: inherit; min-width: 100px;
    }
    .nf-new-cat-btn { background: #10b981; padding: 9px 16px; min-width: auto; }
    .nf-create-category-form {
        display: flex; gap: 10px; align-items: center; max-width: 900px;
        margin-top: 14px; padding: 16px; background: #ffffff; border: 1px solid #e8ecf0;
        border-radius: 12px;
    }
    @media (max-width: 720px) {
        .nf-card-body { grid-template-columns: 1fr; }
        .nf-image-section { order: -1; }
        .nf-grid-2 { grid-template-columns: 1fr; }
        .nf-create-category-form { flex-direction: column; align-items: stretch; }
    }
</style>
