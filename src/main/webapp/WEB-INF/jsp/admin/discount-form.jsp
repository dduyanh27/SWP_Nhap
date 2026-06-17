<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:set var="isEdit" value="${not empty discount.discountId}" />

<h1 class="admin-page-title">${isEdit ? 'Edit' : 'Create'} Discount Code</h1>
<p class="admin-page-subtitle">${isEdit ? 'Update discount code information' : 'Create a new promotional discount code'}</p>

<c:if test="${not empty error}">
    <div class="admin-alert error">${error}</div>
</c:if>

<div class="admin-form-card">
    <form action="${pageContext.request.contextPath}/admin/discounts/${isEdit ? 'edit' : 'create'}" method="post">
        <c:if test="${isEdit}">
            <input type="hidden" name="discountId" value="${discount.discountId}" />
        </c:if>

        <div class="admin-form-group">
            <label for="code">Discount Code <span class="required">*</span></label>
            <input type="text" id="code" name="code" class="admin-input"
                   value="${discount.code}" maxlength="20" required
                   placeholder="e.g. SALE15">
        </div>

        <div class="admin-form-group">
            <label for="discountType">Discount Type <span class="required">*</span></label>
            <select id="discountType" name="discountType" class="admin-select" style="width:100%;">
                <option value="PERCENTAGE" ${discount.discountType == 'PERCENTAGE' ? 'selected' : ''}>Percentage (%)</option>
                <option value="FIXED" ${discount.discountType == 'FIXED' ? 'selected' : ''}>Fixed Amount (VND)</option>
            </select>
        </div>

        <div class="admin-form-row">
            <div class="admin-form-group" style="flex:1;">
                <label for="discountValue">Discount Value <span class="required">*</span></label>
                <input type="number" id="discountValue" name="discountValue" class="admin-input"
                       value="${discount.discountValue}" step="0.01" min="0.01" required
                       placeholder="e.g. 15">
            </div>
            <div class="admin-form-group" style="flex:1;">
                <label for="minOrderAmount">Min Order Amount</label>
                <input type="number" id="minOrderAmount" name="minOrderAmount" class="admin-input"
                       value="${discount.minOrderAmount}" step="1000" min="0"
                       placeholder="0">
            </div>
        </div>

        <div class="admin-form-group">
            <label for="maxDiscountAmount">Max Discount Amount (for percentage type)</label>
            <input type="number" id="maxDiscountAmount" name="maxDiscountAmount" class="admin-input"
                   value="${discount.maxDiscountAmount}" step="1000" min="0"
                   placeholder="Leave empty for no limit">
        </div>

        <div class="admin-form-row">
            <div class="admin-form-group" style="flex:1;">
                <label for="startDate">Start Date <span class="required">*</span></label>
                <input type="datetime-local" id="startDate" name="startDate" class="admin-input"
                       value="${discount.startDateFormatted}" required>
            </div>
            <div class="admin-form-group" style="flex:1;">
                <label for="endDate">End Date <span class="required">*</span></label>
                <input type="datetime-local" id="endDate" name="endDate" class="admin-input"
                       value="${discount.endDateFormattedInput}" required>
            </div>
        </div>

        <div class="admin-form-row">
            <div class="admin-form-group" style="flex:1;">
                <label for="usageLimit">Usage Limit</label>
                <input type="number" id="usageLimit" name="usageLimit" class="admin-input"
                       value="${discount.usageLimit}" min="1"
                       placeholder="Leave empty for unlimited">
            </div>
            <div class="admin-form-group" style="flex:1;">
                <label for="perUserLimit">Per User Limit</label>
                <input type="number" id="perUserLimit" name="perUserLimit" class="admin-input"
                       value="${discount.perUserLimit}" min="1"
                       placeholder="Leave empty for unlimited">
            </div>
        </div>

        <div class="admin-form-group">
            <label for="targetUserType">Target User Type <span class="required">*</span></label>
            <select id="targetUserType" name="targetUserType" class="admin-select" style="width:100%;">
                <option value="ALL" ${discount.targetUserType == 'ALL' ? 'selected' : ''}>All Users</option>
                <option value="CUSTOMER" ${discount.targetUserType == 'CUSTOMER' ? 'selected' : ''}>Customer</option>
                <option value="SALES_STAFF" ${discount.targetUserType == 'SALES_STAFF' ? 'selected' : ''}>Sales Staff</option>
                <option value="ADMIN" ${discount.targetUserType == 'ADMIN' ? 'selected' : ''}>Admin</option>
            </select>
        </div>

        <div class="admin-form-actions">
            <button type="submit" class="btn-add-product">
                ${isEdit ? 'Update' : 'Create'}
            </button>
            <a href="${pageContext.request.contextPath}/admin/discounts" class="btn-admin-secondary">
                Cancel
            </a>
        </div>
    </form>
</div>
