<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Tài khoản của tôi - VMFRUIT</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="<c:url value='/css/style.css'/>">
    <link rel="stylesheet" href="<c:url value='/css/profile.css'/>">
</head>
<body class="bg-light">

<jsp:include page="common/header.jsp" />

<div class="container mt-3 mb-3">
    <small class="text-muted">Trang chủ / <b>Tài khoản của tôi</b></small>
</div>

<main class="container mb-5">

    <c:if test="${not empty successMessage}">
        <div class="alert alert-success alert-dismissible fade show mt-2" role="alert">
            ✓ ${successMessage}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>


    <c:if test="${not empty errorMessage}">
        <div class="alert alert-danger alert-dismissible fade show mt-2" role="alert">
            ✗ ${errorMessage}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>

    <div class="row">

        <div class="col-md-3 mb-4">
            <div class="profile-card">
                <div class="d-flex align-items-center mb-4 pb-3 border-bottom">
                    <div class="avatar-preview-container" style="width: 60px; height: 60px; margin-right: 15px;">
                        <c:choose>
                            <c:when test="${not empty user.avatarUrl}">
                                <img src="${user.avatarUrl}" alt="Avatar">
                            </c:when>
                            <c:otherwise>
                                <img src="<c:url value='/images/default-avatar.png'/>" alt="Avatar">
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <div>
                        <h6 class="mb-0 fw-bold">${user.fullName}</h6>
                        <small class="text-muted">${user.email}</small>
                    </div>
                </div>

                <ul class="list-group list-group-flush">
                    <li class="list-group-item ${empty param.tab or param.tab eq 'profile' ? 'active-tab' : ''}">
                        <a href="${pageContext.request.contextPath}/profile" class="text-decoration-none" style="color: inherit;">
                            <i class="fas fa-user me-2"></i> Thông tin cá nhân
                        </a>
                    </li>
                    <li class="list-group-item ${param.tab eq 'orders' ? 'active-tab' : ''}">
                        <a href="${pageContext.request.contextPath}/profile?tab=orders" class="text-decoration-none" style="color: inherit;">
                            <i class="fas fa-box me-2"></i> Lịch sử đơn hàng
                        </a>
                    </li>
                    <li class="list-group-item ${param.tab eq 'address' ? 'active-tab' : ''}">
                        <a href="${pageContext.request.contextPath}/profile?tab=address" class="text-decoration-none" style="color: inherit;">
                            <i class="fas fa-map-marker-alt me-2"></i> Địa chỉ của tôi
                        </a>
                    </li>
                    <li class="list-group-item ${param.tab eq 'password' ? 'active-tab' : ''}">
                        <a href="${pageContext.request.contextPath}/profile?tab=password" class="text-decoration-none" style="color: inherit;">
                            <i class="fas fa-lock me-2"></i> Đổi mật khẩu
                        </a>
                    </li>
                    <li class="list-group-item ${param.tab eq 'notification' ? 'active-tab' : ''}">
                        <a href="${pageContext.request.contextPath}/profile?tab=notification" class="text-decoration-none" style="color: inherit;">
                            <i class="fas fa-bell me-2"></i> Thông báo
                        </a>
                    </li>
                </ul>
            </div>
        </div>


        <div class="col-md-9">
            <c:choose>

                <c:when test="${empty param.tab or param.tab eq 'profile'}">
                    <div class="profile-card">
                        <div class="mb-4 border-bottom pb-3">
                            <h4 class="mb-1 fw-bold">Hồ Sơ Của Tôi</h4>
                            <p class="text-muted mb-0">Quản lý thông tin hồ sơ để bảo mật tài khoản</p>
                        </div>
                        <div class="row">
                            <div class="col-md-8 border-end pe-4">
                                <form action="${pageContext.request.contextPath}/profile/update" method="POST" enctype="multipart/form-data">
                                    <div class="mb-3 d-flex align-items-center">
                                        <label class="w-25 text-end pe-3 text-muted">Họ và tên</label>
                                        <input type="text" class="form-control w-75" name="fullName"
                                               value="${user.fullName}" required>
                                    </div>
                                    <div class="mb-3 d-flex align-items-center">
                                        <label class="w-25 text-end pe-3 text-muted">Email</label>
                                        <input type="email" class="form-control w-75"
                                               value="${user.email}" disabled>
                                    </div>
                                    <div class="mb-3 d-flex align-items-center">
                                        <label class="w-25 text-end pe-3 text-muted">Số điện thoại</label>
                                        <input type="text" class="form-control w-75" name="phone"
                                               value="${user.phone}" required>
                                    </div>
                                    <div class="mb-3 d-flex align-items-center">
                                        <label class="w-25 text-end pe-3 text-muted">Giới tính</label>
                                        <div class="w-75 d-flex gap-4 pt-2">
                                            <div class="form-check">
                                                <input class="form-check-input" type="radio" name="gender"
                                                       value="Nam" id="genderMale"
                                                    ${user.gender eq 'Nam' ? 'checked' : ''}>
                                                <label class="form-check-label" for="genderMale">Nam</label>
                                            </div>
                                            <div class="form-check">
                                                <input class="form-check-input" type="radio" name="gender"
                                                       value="Nữ" id="genderFemale"
                                                    ${user.gender eq 'Nữ' ? 'checked' : ''}>
                                                <label class="form-check-label" for="genderFemale">Nữ</label>
                                            </div>
                                            <div class="form-check">
                                                <input class="form-check-input" type="radio" name="gender"
                                                       value="Khác" id="genderOther"
                                                    ${user.gender eq 'Khác' ? 'checked' : ''}>
                                                <label class="form-check-label" for="genderOther">Khác</label>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="mb-4 d-flex align-items-center">
                                        <label class="w-25 text-end pe-3 text-muted">Ngày sinh</label>
                                        <input type="date" class="form-control w-75" name="dateOfBirth"
                                               value="<fmt:formatDate value='${user.dateOfBirth}' pattern='yyyy-MM-dd'/>">
                                    </div>
                                    <div class="d-flex">
                                        <div class="w-25"></div>
                                        <button type="submit" class="btn btn-success px-4">LƯU THAY ĐỔI</button>
                                    </div>
                                </form>
                            </div>
                            <div class="col-md-4 text-center">
                                <div class="avatar-upload-section d-flex flex-column align-items-center">
                                    <div class="avatar-preview-container">
                                        <c:choose>
                                            <c:when test="${not empty user.avatarUrl}">
                                                <img src="${user.avatarUrl}" id="avatarPreview" alt="Avatar">
                                            </c:when>
                                            <c:otherwise>
                                                <img src="<c:url value='/images/default-avatar.png'/>" id="avatarPreview" alt="Avatar">
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                    <button type="button" class="btn btn-outline-secondary btn-sm mb-2"
                                            onclick="document.getElementById('avatarFile').click()">Chọn ảnh</button>
                                    <input type="file" id="avatarFile" name="avatarFile" accept=".jpg, .jpeg, .png"
                                           style="display:none;" onchange="previewImage(event)">
                                    <div class="text-muted small">Dung lượng tối đa 5 MB<br>Định dạng: .JPEG, .PNG</div>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:when>


                <c:when test="${param.tab eq 'orders'}">
                    <div class="profile-card">
                        <div class="mb-4 border-bottom pb-3">
                            <h4 class="mb-1 fw-bold">Lịch sử đơn hàng</h4>
                            <p class="text-muted mb-0">Theo dõi trạng thái và chi tiết các đơn hàng.</p>
                        </div>
                        <ul class="nav nav-tabs mb-4 flex-nowrap overflow-auto">
                            <li class="nav-item"><a class="nav-link ${empty param.status ? 'active' : ''}"
                                                    href="${pageContext.request.contextPath}/profile?tab=orders">Tất cả</a></li>
                            <li class="nav-item"><a class="nav-link ${param.status eq 'PENDING' ? 'active' : ''}"
                                                    href="${pageContext.request.contextPath}/profile?tab=orders&status=PENDING">Chờ xác nhận</a></li>
                            <li class="nav-item"><a class="nav-link ${param.status eq 'SHIPPING' ? 'active' : ''}"
                                                    href="${pageContext.request.contextPath}/profile?tab=orders&status=SHIPPING">Đang giao</a></li>
                            <li class="nav-item"><a class="nav-link ${param.status eq 'DELIVERED' ? 'active' : ''}"
                                                    href="${pageContext.request.contextPath}/profile?tab=orders&status=DELIVERED">Hoàn thành</a></li>
                            <li class="nav-item"><a class="nav-link ${param.status eq 'CANCELLED' ? 'active' : ''}"
                                                    href="${pageContext.request.contextPath}/profile?tab=orders&status=CANCELLED">Đã hủy</a></li>
                        </ul>

                        <c:choose>
                            <c:when test="${not empty orderList and orderList.size() > 0}">
                                <c:forEach var="order" items="${orderList}">
                                    <div class="card mb-3">
                                        <div class="card-body">
                                            <div class="row align-items-center">
                                                <div class="col-md-3">
                                                    <strong>#Đơn ${order.orderId}</strong>
                                                    <br>
                                                    <small class="text-muted">
                                                        <fmt:formatDate value="${order.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                                                    </small>
                                                </div>
                                                <div class="col-md-3">
                                                    <div>Tổng tiền:</div>
                                                    <strong style="color: #198754; font-size: 18px;">
                                                        <fmt:formatNumber value="${order.totalAmount}" type="currency" currencySymbol="đ"/>
                                                    </strong>
                                                </div>
                                                <div class="col-md-3">
                                                    <span class="badge bg-${order.orderStatus eq 'DELIVERED' ? 'success' : order.orderStatus eq 'PENDING' ? 'warning' : order.orderStatus eq 'SHIPPING' ? 'info' : 'danger'}">
                                                            ${order.orderStatus eq 'PENDING' ? 'Chờ xác nhận' : order.orderStatus eq 'SHIPPING' ? 'Đang giao' : order.orderStatus eq 'DELIVERED' ? 'Hoàn thành' : 'Đã hủy'}
                                                    </span>
                                                </div>
                                                <div class="col-md-3 text-end">
                                                    <a href="${pageContext.request.contextPath}/order/${order.orderId}" class="btn btn-sm btn-outline-success">Chi tiết</a>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <div class="alert alert-info">Bạn chưa có đơn hàng nào</div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </c:when>


                <c:when test="${param.tab eq 'address'}">
                    <div class="profile-card">
                        <div class="d-flex justify-content-between align-items-center mb-4 border-bottom pb-3">
                            <div>
                                <h4 class="mb-1 fw-bold">Địa chỉ của tôi</h4>
                                <p class="text-muted mb-0">Quản lý thông tin giao hàng</p>
                            </div>
                            <button class="btn btn-success" data-bs-toggle="modal" data-bs-target="#addressModal">
                                <i class="fas fa-plus"></i> Thêm địa chỉ mới
                            </button>
                        </div>

                        <c:choose>
                            <c:when test="${param.tab eq 'address'}">
                                <div class="profile-card">
                                    <div class="d-flex justify-content-between align-items-center mb-4 border-bottom pb-3">
                                        <div>
                                            <h4 class="mb-1 fw-bold">Địa chỉ của tôi</h4>
                                            <p class="text-muted mb-0">Quản lý thông tin giao hàng</p>
                                        </div>
                                        <button class="btn btn-success" data-bs-toggle="modal" data-bs-target="#addressModal">
                                            <i class="fas fa-plus"></i> Thêm địa chỉ mới
                                        </button>
                                    </div>

                                    <c:choose>
                                        <c:when test="${not empty addressList and addressList.size() > 0}">
                                            <c:forEach var="address" items="${addressList}">
                                                <div class="card mb-3 ${address.isDefault ? 'border-success' : ''}">
                                                    <div class="card-body">
                                                        <div class="d-flex justify-content-between align-items-start">
                                                            <div>
                                                                <strong>${address.receiverName}</strong>
                                                                <c:if test="${address.isDefault}">
                                                                    <span class="badge bg-success">Mặc định</span>
                                                                </c:if>
                                                                <br>
                                                                <small class="text-muted">📞 ${address.phone}</small>
                                                                <br>
                                                                <small>${address.fullAddress}</small>
                                                            </div>
                                                            <form method="POST" action="${pageContext.request.contextPath}/profile/address/delete/${address.addressId}"
                                                                  style="display: inline;">
                                                                <button type="submit" class="btn btn-sm btn-danger"
                                                                        onclick="return confirm('Bạn chắc chắn muốn xóa?')">
                                                                    <i class="fas fa-trash"></i> Xóa
                                                                </button>
                                                            </form>
                                                        </div>
                                                    </div>
                                                </div>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="alert alert-info">Bạn chưa có địa chỉ nào</div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="alert alert-info">Bạn chưa có địa chỉ nào</div>
                            </c:otherwise>
                        </c:choose>
                    </div>


                    <div class="modal fade" id="addressModal" tabindex="-1">
                        <div class="modal-dialog">
                            <form action="${pageContext.request.contextPath}/profile/address/add" method="POST" class="modal-content p-3">
                                <h5 class="mb-3">Thêm địa chỉ</h5>
                                <input type="text" name="receiverName" class="form-control mb-2"
                                       placeholder="Tên người nhận" required>
                                <input type="text" name="phone" class="form-control mb-2"
                                       placeholder="Số điện thoại" required>
                                <textarea name="fullAddress" class="form-control mb-3"
                                          placeholder="Địa chỉ đầy đủ (VD: 123 Đường ABC, Phường XYZ, Quận 1, TP.HCM)"
                                          rows="3" required></textarea>
                                <div class="form-check mb-3">
                                    <input type="checkbox" name="isDefault" value="1" class="form-check-input" id="isDefault">
                                    <label class="form-check-label" for="isDefault">Đặt làm địa chỉ mặc định</label>
                                </div>
                                <div class="d-flex gap-2">
                                    <button type="submit" class="btn btn-success">Lưu địa chỉ</button>
                                    <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Hủy</button>
                                </div>
                            </form>
                        </div>
                    </div>
                </c:when>

                <c:when test="${param.tab eq 'password'}">
                    <div class="profile-card">
                        <div class="mb-4 border-bottom pb-3">
                            <h4 class="mb-1 fw-bold">Đổi Mật Khẩu</h4>
                            <p class="text-muted mb-0">Vui lòng không chia sẻ mật khẩu cho người khác</p>
                        </div>
                        <div class="row">
                            <div class="col-md-8 offset-md-2">
                                <form action="${pageContext.request.contextPath}/profile/change-password" method="POST"
                                      onsubmit="return validatePass()">
                                    <div class="mb-3 d-flex align-items-center">
                                        <label class="w-25 text-end pe-3 text-muted">Mật khẩu cũ</label>
                                        <input type="password" name="oldPassword" class="form-control w-75" required>
                                    </div>
                                    <div class="mb-3 d-flex align-items-center">
                                        <label class="w-25 text-end pe-3 text-muted">Mật khẩu mới</label>
                                        <input type="password" name="newPassword" id="newPass"
                                               class="form-control w-75" required>
                                    </div>
                                    <div class="mb-3 d-flex align-items-center">
                                        <label class="w-25 text-end pe-3 text-muted">Xác nhận</label>
                                        <input type="password" name="confirmPassword" id="confPass"
                                               class="form-control w-75" required>
                                    </div>
                                    <div class="d-flex">
                                        <div class="w-25"></div>
                                        <button type="submit" class="btn btn-success px-4">Xác nhận</button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                </c:when>


                <c:when test="${param.tab eq 'notification'}">
                    <div class="profile-card">
                        <div class="mb-4 border-bottom pb-3">
                            <h4 class="mb-1 fw-bold">Thông báo của tôi</h4>
                            <p class="text-muted mb-0">Cập nhật các hoạt động mới nhất từ VMFRUIT</p>
                        </div>
                        <c:choose>
                            <c:when test="${not empty notificationList and notificationList.size() > 0}">
                                <c:forEach var="notification" items="${notificationList}">
                                    <div class="card mb-3 ${!notification.isRead ? 'border-left border-success' : ''}">
                                        <div class="card-body">
                                            <div class="d-flex justify-content-between align-items-start">
                                                <div>
                                                    <strong>${notification.title}</strong>
                                                    <c:if test="${!notification.isRead}">
                                                        <span class="badge bg-success">Mới</span>
                                                    </c:if>
                                                    <br>
                                                    <p class="mb-1">${notification.message}</p>
                                                    <small class="text-muted">
                                                        <fmt:formatDate value="${notification.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                                                    </small>
                                                </div>
                                                <span class="badge bg-info">${notification.type}</span>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <div class="alert alert-info">
                                    <i class="fas fa-bell"></i> Chưa có thông báo mới
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </c:when>
            </c:choose>
        </div>
    </div>
</main>

<script>
    function previewImage(event) {
        var reader = new FileReader();
        reader.onload = function(){
            document.getElementById('avatarPreview').src = reader.result;
        };
        if(event.target.files[0]) reader.readAsDataURL(event.target.files[0]);
    }

    function validatePass() {
        const newPass = document.getElementById("newPass").value;
        const confPass = document.getElementById("confPass").value;

        if(newPass !== confPass) {
            alert("Mật khẩu mới không khớp!");
            return false;
        }

        if(newPass.length < 8) {
            alert("Mật khẩu phải có tối thiểu 8 ký tự!");
            return false;
        }

        return true;
    }
</script>

<jsp:include page="common/footer.jsp" />
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>