<%--
  Created by IntelliJ IDEA.
  User: ADMIN
  Date: 6/16/2026
  Time: 11:11 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="inv-sidebar-container border-end d-flex flex-column flex-shrink-0 p-3">
    <p class="inv-sidebar-heading">CHỨC NĂNG KHO</p>
    <ul class="nav nav-pills flex-column mb-auto">
        <li class="nav-item mb-1">
            <a href="${pageContext.request.contextPath}/inventory/dashboard" class="inv-nav-link d-flex align-items-center">
                <span class="me-2">📊</span> Tổng quan trung tâm
            </a>
        </li>
        <li class="nav-item mb-1">
            <a href="${pageContext.request.contextPath}/inventory/batches" class="inv-nav-link inv-nav-link-active d-flex align-items-center">
                <span class="me-2">📦</span> Xem Lô Hàng &amp; Tồn Kho
            </a>
        </li>
        <li class="nav-item mb-1">
            <a href="${pageContext.request.contextPath}/inventory/batches/add" class="inv-nav-link d-flex align-items-center">
                <span class="me-2">📥</span> Nhập Hàng Mới (Tạo Batch)
            </a>
        </li>
        <li class="nav-item mb-1">
            <a href="${pageContext.request.contextPath}/inventory/audit" class="inv-nav-link d-flex align-items-center">
                <span class="me-2">🔍</span> Kiểm Kê Định Kỳ
            </a>
        </li>
        <li class="nav-item mb-1">
            <a href="${pageContext.request.contextPath}/inventory/wastage" class="inv-nav-link d-flex align-items-center">
                <span class="me-2">🗑️</span> Báo Cáo Hàng Hủy/Nát
            </a>
        </li>
    </ul>

    <hr class="text-muted my-3" />

    <p class="inv-sidebar-heading">BỘ LỌC TRẠNG THÁI LÔ</p>
    <form id="inventorySidebarFilterForm" method="get" action="${pageContext.request.contextPath}/inventory/batches">
        <div class="form-check mb-2">
            <input class="form-check-input" type="checkbox" name="invStatus" value="SAFE" id="invChkSafe" ${param.invStatus == 'SAFE' ? 'checked' : ''}>
            <label class="form-check-label text-dark" for="invChkSafe" style="font-size: 13px;">An toàn thực tế</label>
        </div>
        <div class="form-check mb-2">
            <input class="form-check-input" type="checkbox" name="invStatus" value="WARNING" id="invChkWarning" ${empty param.invStatus || param.invStatus == 'WARNING' ? 'checked' : ''}>
            <label class="form-check-label text-dark fw-bold" for="invChkWarning" style="font-size: 13px;">Lô cận hạn dùng</label>
        </div>
        <div class="form-check mb-3">
            <input class="form-check-input" type="checkbox" name="invStatus" value="DANGER" id="invChkDanger" ${param.invStatus == 'DANGER' ? 'checked' : ''}>
            <label class="form-check-label text-dark" for="invChkDanger" style="font-size: 13px;">Lô cần xuất gấp (FEFO)</label>
        </div>
    </form>
</div>